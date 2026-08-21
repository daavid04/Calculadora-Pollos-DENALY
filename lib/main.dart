import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraPollosApp());
}

// Modelo de Lote para historial
class Lote {
  final String id;
  final int pollos;
  final double mortalidad; // en porcentaje
  final double precioVenta;
  final double precioAlimento;
  final double costoPollito;
  final double ganancia;
  final double gananciaXPollo;
  final DateTime fecha;

  const Lote({
    required this.id,
    required this.pollos,
    required this.mortalidad,
    required this.precioVenta,
    required this.precioAlimento,
    required this.costoPollito,
    required this.ganancia,
    required this.gananciaXPollo,
    required this.fecha,
  });
}

// App principal
class CalculadoraPollosApp extends StatelessWidget {
  const CalculadoraPollosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DENALY Group - Gestión Avícola',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E5631)),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E5631),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        cardTheme: const CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      home: const MenuPrincipal(),
    );
  }
}

// Menú principal con logo de pollo
class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const [
              Color(0xFF1E5631),
              Color(0xFF2E7D32),
              Color(0xFF4CAF50),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo: emoji de pollo
              const Text(
                '🐔',
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 16),
              const Text(
                'DENALY Group',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const Text(
                'Gestión Avícola Profesional',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 48),
              // Botones de navegación
              _buildMenuButton(
                context,
                icon: Icons.calculate,
                label: 'Nueva Simulación',
                color: const Color(0xFFF9A825),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CalculadoraScreen()),
                ),
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                context,
                icon: Icons.history,
                label: 'Historial de Lotes',
                color: Colors.white,
                textColor: const Color(0xFF1E5631),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistorialScreen()),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                '© 2026 DENALY Group',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    Color textColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: textColor, size: 28),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pantalla principal de cálculo
class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen>
    with SingleTickerProviderStateMixin {
  // Controladores de entrada
  final TextEditingController _pollosController = TextEditingController(text: '600');
  final TextEditingController _precioVentaController = TextEditingController(text: '11.0');
  final TextEditingController _precioAlimentoController = TextEditingController(text: '2.87');
  final TextEditingController _costoPollitoController = TextEditingController(text: '3.5');
  final TextEditingController _mortalidadController = TextEditingController(text: '5');
  String _mortalidadTipo = '%'; // '%' o 'cantidad'
  final TextEditingController _otrosCostosController = TextEditingController(text: '700');

  // Resultados
  double _totalKg = 0;
  double _sacosInicio = 0, _sacosCrec = 0, _sacosAcab = 0, _sacosTotal = 0;
  double _costoAlimento = 0, _costoPollitos = 0, _costoOtros = 0, _costoTotal = 0;
  double _pollosVivos = 0, _pollosMuertos = 0;
  double _ingresoReal = 0, _gananciaReal = 0, _gananciaXPollo = 0;
  List<Map<String, dynamic>> _flujoSemanal = [];

  // Tab index
  int _selectedTab = 0;
  late TabController _tabController;

  // Consumo por ave (kg) corregido: pico en semana 5
  final List<double> _consumoPorAve = const [
    0.18, // Semana 1
    0.42, // Semana 2
    0.90, // Semana 3
    1.50, // Semana 4
    2.10, // Semana 5 (pico)
    1.80, // Semana 6
  ];

  // Historial estático
  static final List<Lote> _historial = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _calcular(); // cálculo inicial
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Función principal de cálculo
  void _calcular() {
    setState(() {
      int pollos = int.tryParse(_pollosController.text) ?? 0;
      double precioVenta = double.tryParse(_precioVentaController.text) ?? 0.0;
      double precioAlimento = double.tryParse(_precioAlimentoController.text) ?? 0.0;
      double costoPollito = double.tryParse(_costoPollitoController.text) ?? 0.0;
      double mortalidadValor = double.tryParse(_mortalidadController.text) ?? 0.0;
      double otros = double.tryParse(_otrosCostosController.text) ?? 0.0;

      // Cálculo de pollos muertos según tipo
      double pollosMuertos = 0;
      if (_mortalidadTipo == '%') {
        pollosMuertos = pollos * (mortalidadValor / 100);
      } else {
        pollosMuertos = mortalidadValor.clamp(0.0, pollos.toDouble());
      }
      _pollosMuertos = pollosMuertos;
      _pollosVivos = pollos - pollosMuertos;

      // Alimento total: suma de consumos semanales * pollos
      double totalKg = _consumoPorAve.reduce((a, b) => a + b) * pollos;
      _totalKg = totalKg;

      // Sacos por etapa (20%, 35%, 45%)
      _sacosInicio = (totalKg * 0.20 / 50).ceilToDouble();
      _sacosCrec = (totalKg * 0.35 / 50).ceilToDouble();
      _sacosAcab = (totalKg * 0.45 / 50).ceilToDouble();
      _sacosTotal = _sacosInicio + _sacosCrec + _sacosAcab;

      // Costos
      _costoAlimento = totalKg * precioAlimento;
      _costoPollitos = pollos * costoPollito;
      _costoOtros = otros;
      _costoTotal = _costoAlimento + _costoPollitos + _costoOtros;

      // Ingresos: pollos vivos * 3kg * precioVenta
      double pesoVivoTotal = _pollosVivos * 3.0;
      _ingresoReal = pesoVivoTotal * precioVenta;

      // Ganancias
      _gananciaReal = _ingresoReal - _costoTotal;
      _gananciaXPollo = _pollosVivos > 0 ? _gananciaReal / _pollosVivos : 0;

      // Flujo semanal (kg y costo por semana)
      _flujoSemanal = [];
      for (int i = 0; i < _consumoPorAve.length; i++) {
        double kgSemana = _consumoPorAve[i] * pollos;
        double costoSemana = kgSemana * precioAlimento;
        _flujoSemanal.add({
          'semana': i + 1,
          'kg': kgSemana,
          'costo': costoSemana,
        });
      }
    });
  }

  // Guardar lote en historial
  void _guardarLote() {
    _calcular();
    final lote = Lote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      pollos: int.tryParse(_pollosController.text) ?? 0,
      mortalidad: _mortalidadTipo == '%'
          ? double.tryParse(_mortalidadController.text) ?? 0.0
          : ((double.tryParse(_mortalidadController.text) ?? 0) /
              (int.tryParse(_pollosController.text) ?? 1) *
              100),
      precioVenta: double.tryParse(_precioVentaController.text) ?? 0.0,
      precioAlimento: double.tryParse(_precioAlimentoController.text) ?? 0.0,
      costoPollito: double.tryParse(_costoPollitoController.text) ?? 0.0,
      ganancia: _gananciaReal,
      gananciaXPollo: _gananciaXPollo,
      fecha: DateTime.now(),
    );
    setState(() {
      _historial.add(lote);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lote guardado con éxito ✅'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }

  // Widget de entrada con ícono
  Widget _buildInputField(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon, {
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon, color: const Color(0xFF1E5631)),
        suffix: suffix,
      ),
      onChanged: (_) => _calcular(),
    );
  }

  // Widget resultado en tarjeta
  Widget _buildResultCard(String titulo, String valor, {Color? color}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titulo, style: TextStyle(color: Colors.grey[700])),
            Text(
              valor,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color ?? const Color(0xFF1E5631),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Simulación'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _guardarLote,
            tooltip: 'Guardar Lote',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Datos'),
            Tab(text: 'Alimento'),
            Tab(text: 'Resultados'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDatosTab(),
          _buildAlimentoTab(),
          _buildResultadosTab(),
        ],
      ),
    );
  }

  // Pestaña de Datos
  Widget _buildDatosTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInputField(
                    _pollosController,
                    'Cantidad de Pollos',
                    'Ej: 600',
                    Icons.numbers,
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    _precioVentaController,
                    'Precio de Venta (S/ kg)',
                    'Ej: 11.0',
                    Icons.attach_money,
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    _precioAlimentoController,
                    'Precio Alimento (S/ kg)',
                    'Ej: 2.87',
                    Icons.attach_money,
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    _costoPollitoController,
                    'Costo Pollito BB (S/)',
                    'Ej: 3.5',
                    Icons.attach_money,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildInputField(
                          _mortalidadController,
                          'Mortalidad',
                          'Ej: 5',
                          Icons.warning,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: _mortalidadTipo,
                          items: const [
                            DropdownMenuItem(value: '%', child: Text('%')),
                            DropdownMenuItem(value: 'cantidad', child: Text('Cantidad')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _mortalidadTipo = value;
                                _calcular();
                              });
                            }
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Tipo',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    _otrosCostosController,
                    'Otros Costos (S/)',
                    'Ej: 700',
                    Icons.money_off,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Los datos se actualizan automáticamente',
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  // Pestaña de Alimento
  Widget _buildAlimentoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'RESUMEN DE ALIMENTO',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E5631),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildResultCard('Total Kg Alimento', '${_totalKg.toStringAsFixed(0)} kg'),
                  const Divider(),
                  _buildResultCard('Sacos Inicio (20%)', _sacosInicio.toStringAsFixed(0)),
                  _buildResultCard('Sacos Crecimiento (35%)', _sacosCrec.toStringAsFixed(0)),
                  _buildResultCard('Sacos Acabado (45%)', _sacosAcab.toStringAsFixed(0)),
                  _buildResultCard(
                    'Total Sacos',
                    _sacosTotal.toStringAsFixed(0),
                    color: const Color(0xFFF9A825),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'FLUJO SEMANAL',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E5631),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Semana', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      Text('Alimento (kg)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      Text('Costo (S/)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    ],
                  ),
                  const Divider(),
                  ..._flujoSemanal.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${item['semana']}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E5631))),
                            Text('${item['kg'].toStringAsFixed(0)} kg'),
                            Text('S/ ${item['costo'].toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Pestaña de Resultados
  Widget _buildResultadosTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'RESULTADOS FINANCIEROS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E5631),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildResultCard('Costo Alimento', 'S/ ${_costoAlimento.toStringAsFixed(2)}', color: Colors.blue),
                  _buildResultCard('Costo Pollitos BB', 'S/ ${_costoPollitos.toStringAsFixed(2)}', color: Colors.blue),
                  _buildResultCard('Otros Costos', 'S/ ${_costoOtros.toStringAsFixed(2)}', color: Colors.blue),
                  _buildResultCard('Costo Total', 'S/ ${_costoTotal.toStringAsFixed(2)}', color: Colors.red),
                  const Divider(),
                  _buildResultCard('Pollos Vivos', _pollosVivos.toStringAsFixed(0)),
                  _buildResultCard('Pollos Muertos', _pollosMuertos.toStringAsFixed(0)),
                  const Divider(),
                  _buildResultCard('Ingreso Real', 'S/ ${_ingresoReal.toStringAsFixed(2)}', color: const Color(0xFF2E7D32)),
                  _buildResultCard(
                    'Ganancia Real',
                    'S/ ${_gananciaReal.toStringAsFixed(2)}',
                    color: _gananciaReal >= 0 ? const Color(0xFF4CAF50) : Colors.red,
                  ),
                  _buildResultCard(
                    'Ganancia por Pollo',
                    'S/ ${_gananciaXPollo.toStringAsFixed(2)}',
                    color: _gananciaXPollo >= 0 ? const Color(0xFF4CAF50) : Colors.red,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Los datos se guardan automáticamente al presionar el ícono de guardar',
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Pantalla de Historial
class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Lotes'),
      ),
      body: const _HistorialContent(),
    );
  }
}

class _HistorialContent extends StatefulWidget {
  const _HistorialContent();

  @override
  State<_HistorialContent> createState() => _HistorialContentState();
}

class _HistorialContentState extends State<_HistorialContent> {
  List<Lote> get _historial => _CalculadoraScreenState._historial;

  @override
  Widget build(BuildContext context) {
    if (_historial.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🐔', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            Text(
              'No hay lotes guardados',
              style: TextStyle(color: Colors.grey[600], fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Realiza una simulación y guarda el lote',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _historial.length,
      itemBuilder: (context, index) {
        final lote = _historial[_historial.length - 1 - index]; // más reciente primero
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border(
                left: BorderSide(
                  color: lote.ganancia >= 0 ? const Color(0xFF4CAF50) : Colors.red,
                  width: 6,
                ),
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Row(
                children: [
                  const Text('🐔', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Lote ${_historial.length - index}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E5631),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: lote.ganancia >= 0 ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'S/ ${lote.ganancia.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: lote.ganancia >= 0 ? const Color(0xFF2E7D32) : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.numbers, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('${lote.pollos} pollos'),
                      const SizedBox(width: 16),
                      const Icon(Icons.warning, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('Mortalidad: ${lote.mortalidad.toStringAsFixed(1)}%'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('Venta: S/ ${lote.precioVenta}/kg'),
                      const SizedBox(width: 16),
                      const Icon(Icons.money_off, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('Alimento: S/ ${lote.precioAlimento}/kg'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.trending_up, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('Ganancia x pollo: S/ ${lote.gananciaXPollo.toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${lote.fecha.day}/${lote.fecha.month}/${lote.fecha.year}',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red[300]),
                onPressed: () {
                  setState(() {
                    _historial.remove(lote);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lote eliminado'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

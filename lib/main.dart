import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class Lote {
  String id;
  int pollos;
  int dias;
  double consumo;
  double precio;
  double mortalidad;
  double ganancia;
  double gananciaXPollo;
  DateTime fecha;
  double costoPollitoBB;

  Lote({
    required this.id,
    required this.pollos,
    required this.dias,
    required this.consumo,
    required this.precio,
    required this.mortalidad,
    required this.ganancia,
    required this.gananciaXPollo,
    required this.fecha,
    required this.costoPollitoBB,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DENALY Group - Gestión Avícola',
      theme: ThemeData(
        primaryColor: Color(0xFF1B5E20),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF1B5E20),
          secondary: Color(0xFFF9A825),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(0xFF1B5E20),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: MainMenuPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF4CAF50)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Spacer(flex: 1),
              Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.agriculture,
                      size: 80,
                      color: Colors.white,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'DENALY Group',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      'Gestión Avícola Profesional',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(flex: 1),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildMenuButton(
                      context,
                      icon: Icons.calculate,
                      label: 'Nuevo Cálculo',
                      color: Color(0xFFF9A825),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CalculadoraPage()),
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildMenuButton(
                      context,
                      icon: Icons.history,
                      label: 'Historial de Lotes',
                      color: Colors.white,
                      textColor: Color(0xFF1B5E20),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HistorialPage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(flex: 2),
              Text(
                '© 2026 DENALY Group',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      Color textColor = Colors.white,
      required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 28),
              SizedBox(width: 16),
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

class HistorialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Lotes'),
        backgroundColor: Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),
      body: ConsumerHistorial(),
    );
  }
}

class ConsumerHistorial extends StatefulWidget {
  @override
  _ConsumerHistorialState createState() => _ConsumerHistorialState();
}

class _ConsumerHistorialState extends State<ConsumerHistorial> {
  @override
  Widget build(BuildContext context) {
    final historial = CalculadoraPageState.historialGlobal;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF5F5F5), Colors.white],
        ),
      ),
      child: historial.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'No hay lotes guardados',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Realiza un cálculo y guarda el lote',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: historial.length,
              itemBuilder: (context, index) {
                final lote = historial[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        left: BorderSide(
                          color: lote.ganancia > 0
                              ? Color(0xFF4CAF50)
                              : Color(0xFFE53935),
                          width: 6,
                        ),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Lote ${historial.length - index}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B5E20),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: lote.ganancia > 0
                                  ? Color(0xFFE8F5E9)
                                  : Color(0xFFFFEBEE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'S/ ${lote.ganancia.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lote.ganancia > 0
                                    ? Color(0xFF2E7D32)
                                    : Color(0xFFC62828),
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.pets, size: 16, color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Text('${lote.pollos} pollos'),
                              SizedBox(width: 16),
                              Icon(Icons.calendar_today, size: 16,
                                  color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Text(
                                  '${lote.dias} días'),
                              SizedBox(width: 16),
                              Icon(Icons.monetization_on, size: 16,
                                  color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Text('S/ ${lote.precio}/kg'),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.trending_up, size: 16,
                                  color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Text('Ganancia x pollo: S/ ${lote.gananciaXPollo.toStringAsFixed(2)}'),
                              SizedBox(width: 16),
                              Icon(Icons.warning, size: 16,
                                  color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Text('Mortalidad: ${lote.mortalidad}%'),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.date_range, size: 16,
                                  color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Text(
                                  '${lote.fecha.day}/${lote.fecha.month}/${lote.fecha.year}'),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red[300]),
                        onPressed: () {
                          setState(() {
                            historial.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
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
            ),
    );
  }
}

class CalculadoraPage extends StatefulWidget {
  @override
  _CalculadoraPageState createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  static List<Lote> historialGlobal = [];

  // Controladores
  final pollosCtrl = TextEditingController(text: '800');
  final diasCtrl = TextEditingController(text: '42');
  final consumoCtrl = TextEditingController(text: '4.5');
  final precioCtrl = TextEditingController(text: '11');
  final mortalidadCtrl = TextEditingController(text: '5');
  final costoBBController = TextEditingController(text: '3.5');
  final pesoMuertoController = TextEditingController(text: '2.8');

  // Resultados
  double totalKg = 0,
      costoAlimento = 0,
      costoPollitosBB = 0,
      costoOtros = 0,
      costoTotal = 0,
      gananciaReal = 0,
      gananciaXPollo = 0,
      ingresoReal = 0;
  double sacosI = 0, sacosC = 0, sacosA = 0, sacosT = 0;
  double kgMaiz = 0, kgSoya = 0, kgAceite = 0, kgNucleo = 0, costoIngred = 0;
  double pollosVivos = 0;
  List<Map<String, dynamic>> flujoSemanal = [];

  // Estado de visualización
  int _selectedTab = 0;

  void calcular() {
    setState(() {
      double pollos = double.parse(pollosCtrl.text);
      double dias = double.parse(diasCtrl.text);
      double consumo = double.parse(consumoCtrl.text);
      double precio = double.parse(precioCtrl.text);
      double mort = double.parse(mortalidadCtrl.text) / 100;
      double costoBB = double.parse(costoBBController.text);
      double pesoMuerto = double.parse(pesoMuertoController.text);

      // Cálculo de alimento
      totalKg = pollos * consumo;

      // Sacos por etapa
      sacosI = (totalKg * 0.20 / 50).ceilToDouble();
      sacosC = (totalKg * 0.35 / 50).ceilToDouble();
      sacosA = (totalKg * 0.45 / 50).ceilToDouble();
      sacosT = sacosI + sacosC + sacosA;

      // Ingredientes
      kgMaiz = totalKg * 0.64;
      double sMaiz = (kgMaiz / 50).ceilToDouble();
      kgSoya = totalKg * 0.28;
      double sSoya = (kgSoya / 50).ceilToDouble();
      kgAceite = totalKg * 0.009;
      double sAceite = (kgAceite / 50).ceilToDouble();
      kgNucleo = totalKg * 0.05;
      double sNucleo = (kgNucleo / 50).ceilToDouble();
      costoIngred = (sMaiz * 110) + (sSoya * 165) + (sAceite * 280) +
          (sNucleo * 220);

      // Costos
      costoAlimento = totalKg * 2.87;
      costoPollitosBB = pollos * costoBB;
      costoOtros = 700;
      costoTotal = costoAlimento + costoPollitosBB + costoOtros;

      // Mortalidad y peso
      double pollosMuertos = pollos * mort;
      pollosVivos = pollos - pollosMuertos;
      double pesoVivoTotal = pollosVivos * 3; // Peso promedio 3kg
      double pesoMuertoTotal = pollosMuertos * pesoMuerto;

      // Ingresos
      double ingresoVivos = pesoVivoTotal * precio;
      double ingresoMuertos = pesoMuertoTotal * precio;
      ingresoReal = ingresoVivos + ingresoMuertos;

      // Ganancias
      gananciaReal = ingresoReal - costoTotal;
      gananciaXPollo = pollosVivos > 0 ? gananciaReal / pollosVivos : 0;

      // Flujo semanal mejorado
      // Distribución porcentual del consumo por semana (aproximada)
      List<double> distribucion = [0.03, 0.07, 0.15, 0.25, 0.30, 0.20];
      flujoSemanal = [];
      for (int i = 0; i < distribucion.length; i++) {
        double kgSemana = totalKg * distribucion[i];
        double costoAlimSemana = kgSemana * 2.87;
        // Gasto en pollitos BB distribuido en las primeras semanas
        double costoBBProporcional = (i < 2) ? costoPollitosBB / 2 : 0;
        double otrosProporcionales = (i == 0) ? 500 : 0;
        double totalSemana = costoAlimSemana + costoBBProporcional +
            otrosProporcionales;

        flujoSemanal.add({
          'sem': i + 1,
          'kg': kgSemana,
          'costoAlimento': costoAlimSemana,
          'costoTotal': totalSemana,
          'porcentaje': distribucion[i] * 100,
        });
      }
    });
  }

  void guardarLote() {
    calcular();
    setState(() {
      historialGlobal.add(Lote(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        pollos: int.parse(pollosCtrl.text),
        dias: int.parse(diasCtrl.text),
        consumo: double.parse(consumoCtrl.text),
        precio: double.parse(precioCtrl.text),
        mortalidad: double.parse(mortalidadCtrl.text),
        ganancia: gananciaReal,
        gananciaXPollo: gananciaXPollo,
        fecha: DateTime.now(),
        costoPollitoBB: double.parse(costoBBController.text),
      ));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lote guardado con éxito ✅'),
        backgroundColor: Color(0xFF4CAF50),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildResultado(String titulo, String valor, {Color? color}) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              titulo,
              style: TextStyle(fontSize: 15, color: Colors.grey[800]),
            ),
            Text(
              valor,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color ?? Color(0xFF1B5E20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
      TextEditingController controller, String label, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      keyboardType: TextInputType.number,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Cálculo'),
        backgroundColor: Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: guardarLote,
            tooltip: 'Guardar Lote',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F5F5), Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tabs
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200]!,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _buildTab('Datos', 0),
                    _buildTab('Alimento', 1),
                    _buildTab('Resultados', 2),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Contenido según tab
              if (_selectedTab == 0) _buildDatosTab(),
              if (_selectedTab == 1) _buildAlimentoTab(),
              if (_selectedTab == 2) _buildResultadosTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    bool isActive = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? Color(0xFF1B5E20) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[600],
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatosTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DATOS DE PRODUCCIÓN',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                SizedBox(height: 16),
                _buildInputField(pollosCtrl, 'Cantidad de Pollos', 'Ej: 800'),
                SizedBox(height: 12),
                _buildInputField(diasCtrl, 'Días de Crianza', 'Ej: 42'),
                SizedBox(height: 12),
                _buildInputField(consumoCtrl, 'Consumo por Pollo (kg)',
                    'Ej: 4.5'),
                SizedBox(height: 12),
                _buildInputField(precioCtrl, 'Precio de Venta (S/ kg)',
                    'Ej: 11.0'),
                SizedBox(height: 12),
                _buildInputField(mortalidadCtrl, 'Porcentaje de Mortalidad',
                    'Ej: 5.0'),
                SizedBox(height: 12),
                _buildInputField(costoBBController, 'Costo Pollito BB (S/)',
                    'Ej: 3.5'),
                SizedBox(height: 12),
                _buildInputField(pesoMuertoController, 'Peso Pollo Muerto (kg)',
                    'Ej: 2.8'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: calcular,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF9A825),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'CALCULAR',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlimentoTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ALIMENTO',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                SizedBox(height: 12),
                _buildResultado('Total Kg Alimento', '${totalKg.toStringAsFixed(0)} kg'),
                SizedBox(height: 4),
                _buildResultado('Sacos Inicio 20%', sacosI.toStringAsFixed(0)),
                _buildResultado('Sacos Crecimiento 35%', sacosC.toStringAsFixed(0)),
                _buildResultado('Sacos Acabado 45%', sacosA.toStringAsFixed(0)),
                _buildResultado('Total Sacos', sacosT.toStringAsFixed(0),
                    color: Color(0xFFF9A825)),
              ],
            ),
          ),
        ),
        SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'INGREDIENTES',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                SizedBox(height: 12),
                _buildResultado('Maíz 64%', '${kgMaiz.toStringAsFixed(0)} kg'),
                _buildResultado('Torta de Soya 28%', '${kgSoya.toStringAsFixed(0)} kg'),
                _buildResultado('Aceite 0.9%', '${kgAceite.toStringAsFixed(0)} kg'),
                _buildResultado('Núcleo 5%', '${kgNucleo.toStringAsFixed(0)} kg'),
                SizedBox(height: 4),
                _buildResultado(
                    'Costo Ingredientes', 'S/ ${costoIngred.toStringAsFixed(2)}',
                    color: Color(0xFFE53935)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultadosTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RESULTADOS FINANCIEROS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                SizedBox(height: 12),
                _buildResultado('Costo Alimento', 'S/ ${costoAlimento.toStringAsFixed(2)}',
                    color: Colors.blue),
                _buildResultado('Costo Pollitos BB', 'S/ ${costoPollitosBB.toStringAsFixed(2)}',
                    color: Colors.blue),
                _buildResultado('Costo Otros', 'S/ ${costoOtros.toStringAsFixed(2)}',
                    color: Colors.blue),
                _buildResultado('Costo Total', 'S/ ${costoTotal.toStringAsFixed(2)}',
                    color: Color(0xFFE53935)),
                SizedBox(height: 8),
                Divider(),
                _buildResultado('Ingreso por Vivos', 'S/ ${(pollosVivos * 3 * double.parse(precioCtrl.text)).toStringAsFixed(2)}',
                    color: Color(0xFF2E7D32)),
                _buildResultado('Ingreso por Muertos', 'S/ ${((double.parse(mortalidadCtrl.text)/100 * double.parse(pollosCtrl.text)) * double.parse(pesoMuertoController.text) * double.parse(precioCtrl.text)).toStringAsFixed(2)}',
                    color: Color(0xFF2E7D32)),
                _buildResultado('Ingreso Total', 'S/ ${ingresoReal.toStringAsFixed(2)}',
                    color: Color(0xFF2E7D32)),
                SizedBox(height: 8),
                Divider(),
                _buildResultado('Ganancia Real', 'S/ ${gananciaReal.toStringAsFixed(2)}',
                    color: gananciaReal >= 0 ? Color(0xFF4CAF50) : Color(0xFFE53935)),
                _buildResultado('Ganancia x Pollo', 'S/ ${gananciaXPollo.toStringAsFixed(2)}',
                    color: gananciaXPollo >= 0 ? Color(0xFF4CAF50) : Color(0xFFE53935)),
              ],
            ),
          ),
        ),
        SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FLUJO SEMANAL',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text('Semana', style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey[600])),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text('Alimento (kg)', style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey[600])),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text('Costo (S/)', style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey[600])),
                    ),
                  ],
                ),
                Divider(),
                ...flujoSemanal.map((e) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text('${e['sem']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B5E20))),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text('${e['kg'].toStringAsFixed(0)} kg'),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                                'S/ ${e['costoTotal'].toStringAsFixed(2)}'),
                          ),
                        ],
                      ),
                    )).toList(),
              ],
            ),
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Los datos se guardan automáticamente en el historial',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

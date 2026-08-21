import 'package:flutter/material.dart';

void main() => runApp(MyApp());

// ============================================================
// MODELO DE DATOS
// ============================================================
class Lote {
  String id;
  int pollos;
  double mortalidadPorcentaje;
  int mortalidadCantidad;
  double precio;
  double costoPollitoBB;
  double ganancia;
  double gananciaXPollo;
  DateTime fecha;
  double kgAlimentoTotal;

  Lote({
    required this.id,
    required this.pollos,
    required this.mortalidadPorcentaje,
    required this.mortalidadCantidad,
    required this.precio,
    required this.costoPollitoBB,
    required this.ganancia,
    required this.gananciaXPollo,
    required this.fecha,
    required this.kgAlimentoTotal,
  });
}

// ============================================================
// PARSEO DE MORTALIDAD: admite PORCENTAJE ("5%") o CANTIDAD ("40")
// ============================================================
class MortalidadResultado {
  final double porcentaje;
  final int cantidad;
  const MortalidadResultado(this.porcentaje, this.cantidad);
}

/// Interpreta el texto de mortalidad ingresado por el usuario.
/// - Si el texto termina en "%": se interpreta como PORCENTAJE. Ej: "5%" -> 5%
/// - Si es un número simple (sin "%"): se interpreta como CANTIDAD absoluta
///   de pollos muertos. Ej: "40" -> 40 pollos muertos
MortalidadResultado parseMortalidad(String texto, int totalPollos) {
  final String valor = texto.trim();
  if (valor.isEmpty) return const MortalidadResultado(0, 0);

  if (valor.endsWith('%')) {
    final double porcentaje =
        double.parse(valor.substring(0, valor.length - 1).trim());
    final int cantidad =
        totalPollos > 0 ? ((totalPollos * porcentaje) / 100).round() : 0;
    return MortalidadResultado(porcentaje, cantidad);
  } else {
    final double numero = double.parse(valor);
    final int cantidad = numero.round();
    final double porcentaje =
        totalPollos > 0 ? (cantidad / totalPollos) * 100 : 0;
    return MortalidadResultado(porcentaje, cantidad);
  }
}

// ============================================================
// ÍCONO VECTORIAL DE GALLINA
// Se usa como logo temporal en el menú principal y como ícono
// junto a la cantidad de pollos en el historial (reemplaza las
// "patitas" de Icons.pets).
// ============================================================
class ChickenIcon extends StatelessWidget {
  final double size;
  final Color color;
  const ChickenIcon({super.key, this.size = 24, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _ChickenPainter(color)),
    );
  }
}

class _ChickenPainter extends CustomPainter {
  final Color color;
  _ChickenPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Cuerpo
    canvas.drawOval(
        Rect.fromLTWH(w * 0.06, h * 0.40, w * 0.58, h * 0.50), paint);

    // Cabeza
    canvas.drawOval(
        Rect.fromLTWH(w * 0.50, h * 0.14, w * 0.34, h * 0.34), paint);

    // Cresta
    final Path cresta = Path()
      ..moveTo(w * 0.58, h * 0.16)
      ..lineTo(w * 0.63, h * 0.00)
      ..lineTo(w * 0.68, h * 0.14)
      ..lineTo(w * 0.73, h * 0.00)
      ..lineTo(w * 0.78, h * 0.16)
      ..close();
    canvas.drawPath(cresta, paint);

    // Pico
    final Path pico = Path()
      ..moveTo(w * 0.82, h * 0.28)
      ..lineTo(w * 1.00, h * 0.33)
      ..lineTo(w * 0.82, h * 0.40)
      ..close();
    canvas.drawPath(pico, paint);

    // Cola
    final Path cola = Path()
      ..moveTo(w * 0.10, h * 0.46)
      ..quadraticBezierTo(w * -0.08, h * 0.22, w * 0.04, h * 0.10)
      ..quadraticBezierTo(w * 0.14, h * 0.28, w * 0.20, h * 0.44)
      ..close();
    canvas.drawPath(cola, paint);

    // Patas
    final Paint patasPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = h * 0.035;
    canvas.drawLine(
        Offset(w * 0.22, h * 0.88), Offset(w * 0.22, h * 1.00), patasPaint);
    canvas.drawLine(
        Offset(w * 0.38, h * 0.88), Offset(w * 0.38, h * 1.00), patasPaint);
  }

  @override
  bool shouldRepaint(covariant _ChickenPainter oldDelegate) =>
      oldDelegate.color != color;
}

// ============================================================
// APP
// ============================================================
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DENALY Group - Gestión Avícola',
      theme: ThemeData(
        primaryColor: const Color(0xFF1B5E20),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF1B5E20),
          secondary: const Color(0xFFF9A825),
        ),
        appBarTheme: const AppBarTheme(
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
        cardTheme: const CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const MainMenuPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF4CAF50)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 1),
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // ------------------------------------------------------
                    // LOGO INSTITUCIONAL
                    // Aún no se recibió el archivo de imagen del logo, así
                    // que se usa este ícono vectorial de gallina como
                    // marcador temporal. Para poner tu logo real:
                    //   1) Copia tu imagen (ej. logo_denaly.png) a una
                    //      carpeta "assets/" en la raíz del proyecto.
                    //   2) Decláralo en pubspec.yaml:
                    //        flutter:
                    //          assets:
                    //            - assets/logo_denaly.png
                    //   3) Reemplaza el widget de abajo por:
                    //        Image.asset('assets/logo_denaly.png',
                    //            width: 90, height: 90)
                    // ------------------------------------------------------
                    const ChickenIcon(
                      size: 90,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'DENALY Group',
                      style: TextStyle(
                        fontSize: 36,
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
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildMenuButton(
                      context,
                      icon: Icons.calculate,
                      label: 'Nuevo Cálculo',
                      color: const Color(0xFFF9A825),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CalculadoraPage()),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMenuButton(
                      context,
                      icon: Icons.history,
                      label: 'Historial de Lotes',
                      color: Colors.white,
                      textColor: const Color(0xFF1B5E20),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HistorialPage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              const Text(
                '© 2026 DENALY Group',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),
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
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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

class HistorialPage extends StatelessWidget {
  const HistorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Lotes'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),
      body: const ConsumerHistorial(),
    );
  }
}

class ConsumerHistorial extends StatefulWidget {
  const ConsumerHistorial({super.key});

  @override
  _ConsumerHistorialState createState() => _ConsumerHistorialState();
}

class _ConsumerHistorialState extends State<ConsumerHistorial> {
  // Acceso directo al historial global
  List<Lote> get historial => CalculadoraPage.historialGlobal;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[50]!, Colors.white],
        ),
      ),
      child: historial.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No hay lotes guardados',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
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
              padding: const EdgeInsets.all(16),
              itemCount: historial.length,
              itemBuilder: (context, index) {
                final lote = historial[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        left: BorderSide(
                          color: lote.ganancia > 0
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFE53935),
                          width: 6,
                        ),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Lote ${historial.length - index}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B5E20),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: lote.ganancia > 0
                                  ? const Color(0xFFE8F5E9)
                                  : const Color(0xFFFFEBEE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'S/ ${lote.ganancia.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lote.ganancia > 0
                                    ? const Color(0xFF2E7D32)
                                    : const Color(0xFFC62828),
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
                              // Ícono de gallina en lugar de "patitas" (Icons.pets)
                              ChickenIcon(size: 16, color: Colors.grey[600]!),
                              const SizedBox(width: 4),
                              Text('${lote.pollos} pollos'),
                              const SizedBox(width: 16),
                              Icon(Icons.monetization_on, size: 16,
                                  color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text('S/ ${lote.precio}/kg'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.trending_up, size: 16,
                                  color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text('Ganancia x pollo: S/ ${lote.gananciaXPollo.toStringAsFixed(2)}'),
                              const SizedBox(width: 16),
                              Icon(Icons.warning, size: 16,
                                  color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                  'Mortalidad: ${lote.mortalidadCantidad} (${lote.mortalidadPorcentaje.toStringAsFixed(1)}%)'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.date_range, size: 16,
                                  color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text('${lote.fecha.day}/${lote.fecha.month}/${lote.fecha.year}'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Costo BB: S/ ${lote.costoPollitoBB.toStringAsFixed(2)}  •  Alimento: ${lote.kgAlimentoTotal.toStringAsFixed(0)} kg',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
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
            ),
    );
  }
}

class CalculadoraPage extends StatefulWidget {
  static List<Lote> historialGlobal = [];
  const CalculadoraPage({super.key});

  @override
  _CalculadoraPageState createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  // ------------------------------------------------------------
  // Tabla estándar de consumo semanal de alimento por ave (kg),
  // para un ciclo de 6 semanas (42 días). Los valores van en
  // orden ASCENDENTE porque el ave come progresivamente más cada
  // semana a medida que crece; esto es lo que garantiza que el
  // Flujo Semanal salga siempre en orden ascendente.
  // ------------------------------------------------------------
  static const List<double> consumoPorAveSemana = [
    0.18, // Semana 1
    0.42, // Semana 2
    0.90, // Semana 3
    1.50, // Semana 4
    1.80, // Semana 5
    2.10, // Semana 6
  ];

  // Costos fijos varios (agua, luz, mano de obra puntual, etc.)
  static const double costoOtrosFijos = 700;

  // Controladores (ya NO incluye "días de crianza" ni "consumo por pollo"
  // manual: el alimento total ahora se calcula automáticamente)
  final pollosCtrl = TextEditingController(text: '800');
  final precioCtrl = TextEditingController(text: '11');
  final mortalidadCtrl = TextEditingController(text: '5%');
  final costoBBController = TextEditingController(text: '3.5');
  final pesoMuertoController = TextEditingController(text: '2.8');
  final precioAlimentoKgController = TextEditingController(text: '2.87');

  // Resultados
  double totalKg = 0,
      costoAlimento = 0,
      costoPollitosBB = 0,
      costoOtros = 0,
      costoTotal = 0,
      gananciaReal = 0,
      gananciaXPollo = 0,
      ingresoReal = 0,
      ingresoPorVivos = 0,
      ingresoPorMuertos = 0;
  double sacosI = 0, sacosC = 0, sacosA = 0, sacosT = 0;
  double kgMaiz = 0, kgSoya = 0, kgAceite = 0, kgNucleo = 0, costoIngred = 0;
  double pollosVivos = 0;
  double mortalidadPorcentajeActual = 0;
  int mortalidadCantidadActual = 0;
  List<Map<String, dynamic>> flujoSemanal = [];

  // Vista previa en vivo del campo de mortalidad
  String _mortalidadPreview = '';

  // Estado de visualización
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    pollosCtrl.addListener(_actualizarPreviewMortalidad);
    mortalidadCtrl.addListener(_actualizarPreviewMortalidad);
    _actualizarPreviewMortalidad();
  }

  @override
  void dispose() {
    pollosCtrl.dispose();
    precioCtrl.dispose();
    mortalidadCtrl.dispose();
    costoBBController.dispose();
    pesoMuertoController.dispose();
    precioAlimentoKgController.dispose();
    super.dispose();
  }

  void _actualizarPreviewMortalidad() {
    try {
      final int pollos = int.parse(pollosCtrl.text);
      final r = parseMortalidad(mortalidadCtrl.text, pollos);
      setState(() {
        _mortalidadPreview =
            '= ${r.cantidad} pollos muertos (${r.porcentaje.toStringAsFixed(1)}%)';
      });
    } catch (_) {
      setState(() => _mortalidadPreview = '');
    }
  }

  /// Función lineal: kg de alimento total = pendiente × cantidad de pollos.
  /// La pendiente es el consumo estándar total por ave (suma de la tabla
  /// semanal de arriba). Si cuentas con datos reales de otros lotes
  /// (pares "cantidad de pollos" / "kg de alimento consumido") y quieres
  /// una pendiente más precisa obtenida por regresión lineal, reemplaza
  /// el valor devuelto aquí.
  double _calcularKgAlimentoTotal(int pollos) {
    final double pendiente =
        consumoPorAveSemana.reduce((a, b) => a + b); // 6.90 kg/pollo
    return pollos * pendiente;
  }

  void calcular() {
    try {
      setState(() {
        final int pollos = int.parse(pollosCtrl.text);
        final double precio = double.parse(precioCtrl.text);
        final double costoBB = double.parse(costoBBController.text);
        final double pesoMuerto = double.parse(pesoMuertoController.text);
        final double precioAlimentoKg =
            double.parse(precioAlimentoKgController.text);

        // Mortalidad: admite "5%" (porcentaje) o "40" (cantidad)
        final mort = parseMortalidad(mortalidadCtrl.text, pollos);
        mortalidadPorcentajeActual = mort.porcentaje;
        mortalidadCantidadActual = mort.cantidad;

        // Alimento total = función lineal de la cantidad de pollos
        totalKg = _calcularKgAlimentoTotal(pollos);

        // Sacos por etapa (50 kg por saco)
        sacosI = (totalKg * 0.20 / 50).ceilToDouble();
        sacosC = (totalKg * 0.35 / 50).ceilToDouble();
        sacosA = (totalKg * 0.45 / 50).ceilToDouble();
        sacosT = sacosI + sacosC + sacosA;

        // Ingredientes
        kgMaiz = totalKg * 0.64;
        final double sMaiz = (kgMaiz / 50).ceilToDouble();
        kgSoya = totalKg * 0.28;
        final double sSoya = (kgSoya / 50).ceilToDouble();
        kgAceite = totalKg * 0.009;
        final double sAceite = (kgAceite / 50).ceilToDouble();
        kgNucleo = totalKg * 0.05;
        final double sNucleo = (kgNucleo / 50).ceilToDouble();
        costoIngred =
            (sMaiz * 110) + (sSoya * 165) + (sAceite * 280) + (sNucleo * 220);

        // Costos
        costoAlimento = totalKg * precioAlimentoKg;
        costoPollitosBB = pollos * costoBB;
        costoOtros = costoOtrosFijos;
        costoTotal = costoAlimento + costoPollitosBB + costoOtros;

        // Mortalidad y peso
        pollosVivos = (pollos - mort.cantidad).toDouble();
        final double pesoVivoTotal = pollosVivos * 3; // Peso promedio 3 kg
        final double pesoMuertoTotal = mort.cantidad * pesoMuerto;

        // Ingresos
        ingresoPorVivos = pesoVivoTotal * precio;
        ingresoPorMuertos = pesoMuertoTotal * precio;
        ingresoReal = ingresoPorVivos + ingresoPorMuertos;

        // Ganancias
        gananciaReal = ingresoReal - costoTotal;
        gananciaXPollo = pollosVivos > 0 ? gananciaReal / pollosVivos : 0;

        // ------------------------------------------------------
        // Flujo semanal: SOLO costo de alimento por semana, calculado
        // directamente desde la tabla ascendente de consumo por ave.
        // Al ser la tabla estrictamente creciente, el costo de cada
        // semana es siempre mayor que el de la semana anterior.
        // ------------------------------------------------------
        flujoSemanal = [];
        for (int i = 0; i < consumoPorAveSemana.length; i++) {
          final double kgSemana = pollos * consumoPorAveSemana[i];
          final double costoSemana = kgSemana * precioAlimentoKg;
          flujoSemanal.add({
            'sem': i + 1,
            'kg': kgSemana,
            'costoTotal': costoSemana,
          });
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Revisa los datos: todos los campos deben ser numéricos válidos'),
          backgroundColor: Color(0xFFE53935),
        ),
      );
    }
  }

  void guardarLote() {
    calcular();
    setState(() {
      final int pollos = int.tryParse(pollosCtrl.text) ?? 0;
      CalculadoraPage.historialGlobal.add(Lote(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        pollos: pollos,
        mortalidadPorcentaje: mortalidadPorcentajeActual,
        mortalidadCantidad: mortalidadCantidadActual,
        precio: double.tryParse(precioCtrl.text) ?? 0,
        costoPollitoBB: double.tryParse(costoBBController.text) ?? 0,
        ganancia: gananciaReal,
        gananciaXPollo: gananciaXPollo,
        fecha: DateTime.now(),
        kgAlimentoTotal: totalKg,
      ));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lote guardado con éxito ✅'),
        backgroundColor: Color(0xFF4CAF50),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildResultado(String titulo, String valor, {Color? color}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                color: color ?? const Color(0xFF1B5E20),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Cálculo'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
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
            colors: [Colors.grey[50]!, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
                      offset: const Offset(0, 2),
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
              const SizedBox(height: 16),

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
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1B5E20) : Colors.transparent,
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DATOS DE PRODUCCIÓN',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ciclo estándar: 42 días (6 semanas) — el alimento se calcula automáticamente según la cantidad de pollos',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInputField(pollosCtrl, 'Cantidad de Pollos', 'Ej: 800'),
                const SizedBox(height: 12),
                _buildInputField(precioCtrl, 'Precio de Venta (S/ kg)',
                    'Ej: 11.0'),
                const SizedBox(height: 12),
                _buildInputField(mortalidadCtrl, 'Mortalidad (% o cantidad)',
                    'Ej: 5% ó 40'),
                if (_mortalidadPreview.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      _mortalidadPreview,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                _buildInputField(costoBBController, 'Costo Pollito BB (S/)',
                    'Ej: 3.5'),
                const SizedBox(height: 12),
                _buildInputField(pesoMuertoController, 'Peso Pollo Muerto (kg)',
                    'Ej: 2.8'),
                const SizedBox(height: 12),
                _buildInputField(precioAlimentoKgController,
                    'Precio de Alimento por Kg (S/)', 'Ej: 2.87'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: calcular,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9A825),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ALIMENTO',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                const SizedBox(height: 12),
                _buildResultado('Total Kg Alimento', '${totalKg.toStringAsFixed(0)} kg'),
                const SizedBox(height: 4),
                _buildResultado('Sacos Inicio 20%', sacosI.toStringAsFixed(0)),
                _buildResultado('Sacos Crecimiento 35%', sacosC.toStringAsFixed(0)),
                _buildResultado('Sacos Acabado 45%', sacosA.toStringAsFixed(0)),
                _buildResultado('Total Sacos', sacosT.toStringAsFixed(0),
                    color: const Color(0xFFF9A825)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'INGREDIENTES',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                const SizedBox(height: 12),
                _buildResultado('Maíz 64%', '${kgMaiz.toStringAsFixed(0)} kg'),
                _buildResultado('Torta de Soya 28%', '${kgSoya.toStringAsFixed(0)} kg'),
                _buildResultado('Aceite 0.9%', '${kgAceite.toStringAsFixed(0)} kg'),
                _buildResultado('Núcleo 5%', '${kgNucleo.toStringAsFixed(0)} kg'),
                const SizedBox(height: 4),
                _buildResultado(
                    'Costo Ingredientes', 'S/ ${costoIngred.toStringAsFixed(2)}',
                    color: const Color(0xFFE53935)),
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'RESULTADOS FINANCIEROS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                const SizedBox(height: 12),
                _buildResultado('Costo Alimento', 'S/ ${costoAlimento.toStringAsFixed(2)}',
                    color: Colors.blue),
                _buildResultado('Costo Pollitos BB', 'S/ ${costoPollitosBB.toStringAsFixed(2)}',
                    color: Colors.blue),
                _buildResultado('Costo Otros', 'S/ ${costoOtros.toStringAsFixed(2)}',
                    color: Colors.blue),
                _buildResultado('Costo Total', 'S/ ${costoTotal.toStringAsFixed(2)}',
                    color: const Color(0xFFE53935)),
                const SizedBox(height: 8),
                const Divider(),
                _buildResultado('Ingreso por Vivos', 'S/ ${ingresoPorVivos.toStringAsFixed(2)}',
                    color: const Color(0xFF2E7D32)),
                _buildResultado('Ingreso por Muertos', 'S/ ${ingresoPorMuertos.toStringAsFixed(2)}',
                    color: const Color(0xFF2E7D32)),
                _buildResultado('Ingreso Total', 'S/ ${ingresoReal.toStringAsFixed(2)}',
                    color: const Color(0xFF2E7D32)),
                const SizedBox(height: 8),
                const Divider(),
                _buildResultado('Ganancia Real', 'S/ ${gananciaReal.toStringAsFixed(2)}',
                    color: gananciaReal >= 0 ? const Color(0xFF4CAF50) : const Color(0xFFE53935)),
                _buildResultado('Ganancia x Pollo', 'S/ ${gananciaXPollo.toStringAsFixed(2)}',
                    color: gananciaXPollo >= 0 ? const Color(0xFF4CAF50) : const Color(0xFFE53935)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FLUJO SEMANAL',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Solo costo de alimento — orden ascendente porque el ave come más cada semana',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Text('Semana', style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                    ),
                    const Expanded(
                      flex: 3,
                      child: Text('Alimento (kg)', style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                    ),
                    const Expanded(
                      flex: 4,
                      child: Text('Costo (S/)', style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                    ),
                  ],
                ),
                const Divider(),
                ...flujoSemanal.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text('${e['sem']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B5E20))),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text('${(e['kg'] as double).toStringAsFixed(0)} kg'),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                                'S/ ${(e['costoTotal'] as double).toStringAsFixed(2)}'),
                          ),
                        ],
                      ),
                    )).toList(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Los datos se guardan automáticamente en el historial',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

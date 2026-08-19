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
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Pollos La Joya',
      theme: ThemeData(primarySwatch: Colors.green),
      home: CalculadoraPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculadoraPage extends StatefulWidget {
  @override
  _CalculadoraPageState createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  final pollosCtrl = TextEditingController(text: '800');
  final diasCtrl = TextEditingController(text: '42');
  final consumoCtrl = TextEditingController(text: '4.5');
  final precioCtrl = TextEditingController(text: '11');
  final mortalidadCtrl = TextEditingController(text: '5');

  List<Lote> historial = [];

  // Resultados
  double totalKg=0, costoTotal=0, gananciaReal=0, gananciaXPollo=0, ingresoReal=0;
  double sacosI=0, sacosC=0, sacosA=0, sacosT=0;
  double kgMaiz=0, kgSoya=0, kgAceite=0, kgNucleo=0, costoIngred=0;
  double pollosVivos=0;
  List<Map<String, dynamic>> flujoSemanal = [];

  void calcular() {
    setState(() {
      double pollos = double.parse(pollosCtrl.text);
      double dias = double.parse(diasCtrl.text);
      double consumo = double.parse(consumoCtrl.text);
      double precio = double.parse(precioCtrl.text);
      double mort = double.parse(mortalidadCtrl.text) / 100;

      totalKg = pollos * consumo;
      sacosI = (totalKg * 0.20 / 50).ceilToDouble();
      sacosC = (totalKg * 0.35 / 50).ceilToDouble();
      sacosA = (totalKg * 0.45 / 50).ceilToDouble();
      sacosT = sacosI + sacosC + sacosA;

      kgMaiz = totalKg * 0.64;
      double sMaiz = (kgMaiz/50).ceilToDouble();
      kgSoya = totalKg * 0.28;
      double sSoya = (kgSoya/50).ceilToDouble();
      kgAceite = totalKg * 0.009;
      double sAceite = (kgAceite/50).ceilToDouble();
      kgNucleo = totalKg * 0.05;
      double sNucleo = (kgNucleo/50).ceilToDouble();
      costoIngred = (sMaiz*110)+(sSoya*165)+(sAceite*280)+(sNucleo*220);

      double costoAlimento = totalKg * 2.87;
      double costoPollitos = pollos * 3;
      double costoOtros = 700;
      costoTotal = costoAlimento + costoPollitos + costoOtros;

      pollosVivos = pollos * (1 - mort);
      double pesoTotal = pollosVivos * 3;
      ingresoReal = pesoTotal * precio;

      gananciaReal = ingresoReal - costoTotal;
      gananciaXPollo = pollosVivos > 0? gananciaReal / pollosVivos : 0;

      flujoSemanal = [
        {'sem':1, 'kg':totalKg*0.03, 'costo':totalKg*0.03*2.87},
        {'sem':2, 'kg':totalKg*0.07, 'costo':totalKg*0.07*2.87},
        {'sem':3, 'kg':totalKg*0.15, 'costo':totalKg*0.15*2.87},
        {'sem':4, 'kg':totalKg*0.25, 'costo':totalKg*0.25*2.87},
        {'sem':5, 'kg':totalKg*0.30, 'costo':totalKg*0.30*2.87},
        {'sem':6, 'kg':totalKg*0.20, 'costo':totalKg*0.20*2.87},
      ];
    });
  }

  void guardarLote() {
    calcular();
    setState(() {
      historial.add(Lote(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        pollos: int.parse(pollosCtrl.text),
        dias: int.parse(diasCtrl.text),
        consumo: double.parse(consumoCtrl.text),
        precio: double.parse(precioCtrl.text),
        mortalidad: double.parse(mortalidadCtrl.text),
        ganancia: gananciaReal,
        gananciaXPollo: gananciaXPollo,
        fecha: DateTime.now(),
      ));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lote guardado con éxito ✅'), backgroundColor: Colors.green)
    );
  }

  void verHistorial() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('HISTORIAL DE LOTES', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: historial.isEmpty
             ? Center(child: Text('No hay lotes guardados'))
              : ListView.builder(
                itemCount: historial.length,
                itemBuilder: (context, index) {
                  final lote = historial[index];
                  return Card(
                    child: ListTile(
                      title: Text('Lote ${historial.length - index}: ${lote.pollos} Pollos - ${lote.dias} días'),
                      subtitle: Text('Ganancia: S/ ${lote.ganancia.toStringAsFixed(2)}\nFecha: ${lote.fecha.day}/${lote.fecha.month}/${lote.fecha.year}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() => historial.removeAt(index));
                          Navigator.pop(context);
                          verHistorial();
                        },
                      ),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultado(String titulo, String valor, {Color? color}) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(titulo),
        trailing: Text(valor, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color?? Colors.black)),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CALCULADORA POLLOS LA JOYA'),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.history), onPressed: verHistorial, tooltip: 'Ver Historial')
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // DATOS
            Text('DATOS DEL LOTE', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(controller: pollosCtrl, decoration: InputDecoration(labelText: 'Cantidad de Pollos', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            SizedBox(height: 10),
            TextField(controller: diasCtrl, decoration: InputDecoration(labelText: 'Días de crianza', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            SizedBox(height: 10),
            TextField(controller: consumoCtrl, decoration: InputDecoration(labelText: 'Consumo por pollo kg', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            SizedBox(height: 10),
            TextField(controller: precioCtrl, decoration: InputDecoration(labelText: 'Precio venta S/kg', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            SizedBox(height: 10),
            TextField(controller: mortalidadCtrl, decoration: InputDecoration(labelText: '% Mortalidad', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            SizedBox(height: 20),

            // BOTONES
            Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: calcular, child: Text('CALCULAR'))),
                SizedBox(width: 10),
                Expanded(child: ElevatedButton(onPressed: guardarLote, child: Text('GUARDAR LOTE'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange))),
              ],
            ),
            SizedBox(height: 20),

            // RESULTADOS
            Text('ALIMENTO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildResultado('Total Kg Alimento', '${totalKg.toStringAsFixed(0)} kg'),
            _buildResultado('Sacos Inicio 20%', sacosI.toStringAsFixed(0)),
            _buildResultado('Sacos Crecimiento 35%', sacosC.toStringAsFixed(0)),
            _buildResultado('Sacos Acabado 45%', sacosA.toStringAsFixed(0)),

            SizedBox(height: 10),
            Text('INGREDIENTES', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildResultado('Maiz 64%', '${kgMaiz.toStringAsFixed(0)} kg'),
            _buildResultado('Torta Soya 28%', '${kgSoya.toStringAsFixed(0)} kg'),
            _buildResultado('Costo Ingredientes', 'S/ ${costoIngred.toStringAsFixed(2)}', color: Colors.red),

            SizedBox(height: 10),
            Text('RESULTADOS FINALES', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildResultado('Costo Total', 'S/ ${costoTotal.toStringAsFixed(2)}', color: Colors.red),
            _buildResultado('Ingreso Real', 'S/ ${ingresoReal.toStringAsFixed(2)}', color: Colors.blue),
            _buildResultado('Ganancia Real', 'S/ ${gananciaReal.toStringAsFixed(2)}', color: Colors.green),
            _buildResultado('Ganancia x Pollo', 'S/ ${gananciaXPollo.toStringAsFixed(2)}', color: Colors.green),

            SizedBox(height: 10),
            Text('FLUJO SEMANAL', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           ...flujoSemanal.map((e) =>
              _buildResultado('Semana ${e['sem']}', '${e['kg'].toStringAsFixed(0)} kg - S/ ${e['costo'].toStringAsFixed(2)}')
            ).toList(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const DenalyGroupApp());
}

// ============================================================
// MODELO DE MOVIMIENTO
// ============================================================

class Movimiento {
  final String tipo; // 'Ingreso' o 'Salida'
  final double monto;
  final String categoria;
  final String descripcion;
  final DateTime fecha;
  final String lote; // Ej: Lote 01-2026
  final double? cantidad; // Cantidad de Kg, sacos o cabezas (Opcional)

  Movimiento({
    required this.tipo,
    required this.monto,
    required this.categoria,
    required this.descripcion,
    required this.fecha,
    required this.lote,
    this.cantidad,
  });
}

// ============================================================
// APLICACIÓN
// ============================================================

class DenalyGroupApp extends StatelessWidget {
  const DenalyGroupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DENALY GROUP - AVICOLA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const InicioPage(),
    );
  }
}

// ============================================================
// PANTALLA PRINCIPAL
// ============================================================

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final List<Movimiento> movimientos = [];

  // Categorías Avícolas
  final List<String> categoriasIngreso = [
    'Venta Pollo Vivo',
    'Venta Pollo Beneficiado',
    'Venta Gallinaza / Abono',
    'Otros Ingresos',
  ];

  final List<String> categoriasSalida = [
    'Alimento / Balanceado',
    'Pollo Bebé (BB)',
    'Sanidad / Fármacos',
    'Cama / Viruta',
    'Gas / Cefelección / Luz',
    'Mano de Obra / Salarios',
    'Transporte / Flete',
    'Otros Gastos',
  ];

  // Listado de Lotes activos
  final List<String> lotes = ['Lote 01-2026', 'Lote 02-2026'];
  String loteSeleccionadoFiltro = 'Todos';

  // ----------------------------------------------------------
  // CÁLCULOS FILTRADOS POR LOTE Y FECHA
  // ----------------------------------------------------------

  List<Movimiento> get movimientosFiltrados {
    if (loteSeleccionadoFiltro == 'Todos') {
      return movimientos;
    }
    return movimientos.where((m) => m.lote == loteSeleccionadoFiltro).toList();
  }

  double get ingresosDia {
    final ahora = DateTime.now();
    return movimientosFiltrados
        .where((m) =>
            m.tipo == 'Ingreso' &&
            m.fecha.year == ahora.year &&
            m.fecha.month == ahora.month &&
            m.fecha.day == ahora.day)
        .fold(0, (total, m) => total + m.monto);
  }

  double get salidasDia {
    final ahora = DateTime.now();
    return movimientosFiltrados
        .where((m) =>
            m.tipo == 'Salida' &&
            m.fecha.year == ahora.year &&
            m.fecha.month == ahora.month &&
            m.fecha.day == ahora.day)
        .fold(0, (total, m) => total + m.monto);
  }

  double get ingresosMes {
    final ahora = DateTime.now();
    return movimientosFiltrados
        .where((m) =>
            m.tipo == 'Ingreso' &&
            m.fecha.year == ahora.year &&
            m.fecha.month == ahora.month)
        .fold(0, (total, m) => total + m.monto);
  }

  double get salidasMes {
    final ahora = DateTime.now();
    return movimientosFiltrados
        .where((m) =>
            m.tipo == 'Salida' &&
            m.fecha.year == ahora.year &&
            m.fecha.month == ahora.month)
        .fold(0, (total, m) => total + m.monto);
  }

  // ----------------------------------------------------------
  // FORMULARIO DE REGISTRO
  // ----------------------------------------------------------

  void mostrarFormulario() {
    String tipo = 'Ingreso';
    String categoria = categoriasIngreso.first;
    String loteSeleccionado = lotes.first;
    DateTime fechaSeleccionada = DateTime.now();

    final montoController = TextEditingController();
    final cantidadController = TextEditingController();
    final descripcionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, cambiar) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'REGISTRO AVICOLA',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 10),

                    // TIPO DE MOVIMIENTO
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'Ingreso',
                          label: Text('Ingreso'),
                          icon: Icon(Icons.arrow_downward, color: Colors.green),
                        ),
                        ButtonSegment(
                          value: 'Salida',
                          label: Text('Gasto/Salida'),
                          icon: Icon(Icons.arrow_upward, color: Colors.red),
                        ),
                      ],
                      selected: {tipo},
                      onSelectionChanged: (valor) {
                        cambiar(() {
                          tipo = valor.first;
                          categoria = tipo == 'Ingreso'
                              ? categoriasIngreso.first
                              : categoriasSalida.first;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    // LOTE
                    DropdownButtonFormField<String>(
                      value: loteSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Lote / Campaña',
                        prefixIcon: Icon(Icons.grid_view),
                        border: OutlineInputBorder(),
                      ),
                      items: lotes
                          .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                          .toList(),
                      onChanged: (valor) => cambiar(() => loteSeleccionado = valor!),
                    ),

                    const SizedBox(height: 15),

                    // MONTO Y CANTIDAD EN PARALELO
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: montoController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Monto Total',
                              prefixText: 'S/ ',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: cantidadController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                              labelText: tipo == 'Ingreso' ? 'Kg / Aves' : 'Sacos / Unid',
                              hintText: 'Opcional',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // CATEGORÍA DINÁMICA
                    DropdownButtonFormField<String>(
                      value: categoria,
                      decoration: const InputDecoration(
                        labelText: 'Categoría Avícola',
                        prefixIcon: Icon(Icons.category),
                        border: OutlineInputBorder(),
                      ),
                      items: (tipo == 'Ingreso'
                              ? categoriasIngreso
                              : categoriasSalida)
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (valor) => cambiar(() => categoria = valor!),
                    ),

                    const SizedBox(height: 15),

                    // DESCRIPCIÓN
                    TextField(
                      controller: descripcionController,
                      decoration: const InputDecoration(
                        labelText: 'Detalles / Observación',
                        hintText: 'Ej. Compra de inicio 50 Sacos / Pollo 2kg prom',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // FECHA
                    OutlinedButton.icon(
                      onPressed: () async {
                        final fecha = await showDatePicker(
                          context: context,
                          initialDate: fechaSeleccionada,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (fecha != null) {
                          cambiar(() => fechaSeleccionada = fecha);
                        }
                      },
                      icon: const Icon(Icons.calendar_month),
                      label: Text(
                        'Fecha: ${fechaSeleccionada.day}/${fechaSeleccionada.month}/${fechaSeleccionada.year}',
                      ),
                    ),

                    const SizedBox(height: 20),

                    // BOTÓN GUARDAR
                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          final monto = double.tryParse(montoController.text.trim());
                          final cantidad = double.tryParse(cantidadController.text.trim());

                          if (monto == null || monto <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Ingrese un monto válido')),
                            );
                            return;
                          }

                          setState(() {
                            movimientos.add(
                              Movimiento(
                                tipo: tipo,
                                monto: monto,
                                categoria: categoria,
                                descripcion: descripcionController.text.trim(),
                                fecha: fechaSeleccionada,
                                lote: loteSeleccionado,
                                cantidad: cantidad,
                              ),
                            );
                          });

                          Navigator.pop(context);

                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '$tipo en $loteSeleccionado por S/ ${monto.toStringAsFixed(2)} guardado',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.save),
                        label: const Text(
                          'GUARDAR REGISTRO',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ----------------------------------------------------------
  // WIDGET TARJETA DE RESUMEN CON COLORES
  // ----------------------------------------------------------

  Widget tarjetaVisual(
    String titulo,
    double monto,
    IconData icono,
    Color colorTheme,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: colorTheme.withOpacity(0.15),
              child: Icon(icono, color: colorTheme),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                  Text(
                    'S/ ${monto.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorTheme,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // PANTALLA PRINCIPAL
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final saldoDia = ingresosDia - salidasDia;
    final saldoMes = ingresosMes - salidasMes;
    final ahora = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text(
          'DENALY GROUP',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ENCABEZADO Y FILTRO DE LOTE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Control Avícola',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Hoy: ${ahora.day}/${ahora.month}/${ahora.year}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  DropdownButton<String>(
                    value: loteSeleccionadoFiltro,
                    underline: Container(),
                    icon: const Icon(Icons.filter_alt, color: Colors.teal),
                    items: ['Todos', ...lotes]
                        .map((l) => DropdownMenuItem(
                              value: l,
                              child: Text(
                                l,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        loteSeleccionadoFiltro = val!;
                      });
                    },
                  )
                ],
              ),

              const SizedBox(height: 15),

              // TARJETAS DEL DÍA
              tarjetaVisual(
                'Ingresos del día',
                ingresosDia,
                Icons.arrow_downward,
                Colors.green[700]!,
              ),
              tarjetaVisual(
                'Gastos del día',
                salidasDia,
                Icons.arrow_upward,
                Colors.red[700]!,
              ),
              tarjetaVisual(
                'Saldo Neto del día',
                saldoDia,
                Icons.account_balance_wallet,
                saldoDia >= 0 ? Colors.blue[800]! : Colors.orange[800]!,
              ),

              const SizedBox(height: 15),

              // RESUMEN MENSUAL / LOTE
              Card(
                color: Colors.teal.shade50,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.teal.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'RESUMEN ($loteSeleccionadoFiltro)',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const Icon(Icons.analytics, color: Colors.teal),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Ingresos del Mes:'),
                          Text(
                            'S/ ${ingresosMes.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Gastos del Mes:'),
                          Text(
                            'S/ ${salidasMes.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'BALANCE NETO:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'S/ ${saldoMes.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: saldoMes >= 0
                                  ? Colors.green[900]
                                  : Colors.red[900],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // BOTONES PRINCIPALES
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: mostrarFormulario,
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text(
                    'NUEVO MOVIMIENTO',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistorialPage(
                          movimientos: movimientosFiltrados,
                          eliminarMovimiento: (m) {
                            setState(() {
                              movimientos.remove(m);
                            });
                          },
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.list_alt),
                  label: const Text(
                    'HISTORIAL DE LOTES',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PANTALLA HISTORIAL
// ============================================================

class HistorialPage extends StatefulWidget {
  final List<Movimiento> movimientos;
  final Function(Movimiento) eliminarMovimiento;

  const HistorialPage({
    super.key,
    required this.movimientos,
    required this.eliminarMovimiento,
  });

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  @override
  Widget build(BuildContext context) {
    final lista = [...widget.movimientos];
    lista.sort((a, b) => b.fecha.compareTo(a.fecha));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Granja'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: lista.isEmpty
          ? const Center(
              child: Text(
                'No hay datos registrados en este filtro.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final m = lista[index];
                final esIngreso = m.tipo == 'Ingreso';

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          esIngreso ? Colors.green.shade100 : Colors.red.shade100,
                      child: Icon(
                        esIngreso ? Icons.arrow_downward : Icons.arrow_upward,
                        color: esIngreso ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          m.categoria,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'S/ ${m.monto.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: esIngreso ? Colors.green[700] : Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Lote: ${m.lote} ${m.cantidad != null ? "| Cantidad: ${m.cantidad}" : ""}'),
                          if (m.descripcion.isNotEmpty) Text('Nota: ${m.descripcion}'),
                          Text('Fecha: ${m.fecha.day}/${m.fecha.month}/${m.fecha.year}'),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.grey),
                      onPressed: () {
                        widget.eliminarMovimiento(m);
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registro eliminado')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const DenalyGroupApp());
}

// ============================================================
// MODELO DE MOVIMIENTO
// ============================================================

class Movimiento {
  final String tipo;
  final double monto;
  final String categoria;
  final String descripcion;
  final DateTime fecha;

  Movimiento({
    required this.tipo,
    required this.monto,
    required this.categoria,
    required this.descripcion,
    required this.fecha,
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
      title: 'DENALY GROUP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
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

  // ----------------------------------------------------------
  // INGRESOS DEL DÍA
  // ----------------------------------------------------------

  double get ingresosDia {
    final ahora = DateTime.now();

    return movimientos
        .where((m) =>
            m.tipo == 'Ingreso' &&
            m.fecha.year == ahora.year &&
            m.fecha.month == ahora.month &&
            m.fecha.day == ahora.day)
        .fold(0, (total, m) => total + m.monto);
  }

  // ----------------------------------------------------------
  // SALIDAS DEL DÍA
  // ----------------------------------------------------------

  double get salidasDia {
    final ahora = DateTime.now();

    return movimientos
        .where((m) =>
            m.tipo == 'Salida' &&
            m.fecha.year == ahora.year &&
            m.fecha.month == ahora.month &&
            m.fecha.day == ahora.day)
        .fold(0, (total, m) => total + m.monto);
  }

  // ----------------------------------------------------------
  // INGRESOS DEL MES
  // ----------------------------------------------------------

  double get ingresosMes {
    final ahora = DateTime.now();

    return movimientos
        .where((m) =>
            m.tipo == 'Ingreso' &&
            m.fecha.year == ahora.year &&
            m.fecha.month == ahora.month)
        .fold(0, (total, m) => total + m.monto);
  }

  // ----------------------------------------------------------
  // SALIDAS DEL MES
  // ----------------------------------------------------------

  double get salidasMes {
    final ahora = DateTime.now();

    return movimientos
        .where((m) =>
            m.tipo == 'Salida' &&
            m.fecha.year == ahora.year &&
            m.fecha.month == ahora.month)
        .fold(0, (total, m) => total + m.monto);
  }

  // ----------------------------------------------------------
  // MOSTRAR FORMULARIO
  // ----------------------------------------------------------

  void mostrarFormulario() {
    String tipo = 'Ingreso';
    String categoria = 'Ventas';
    DateTime fechaSeleccionada = DateTime.now();

    final montoController = TextEditingController();
    final descripcionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, cambiar) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'REGISTRAR MOVIMIENTO',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'Ingreso',
                          label: Text('Ingreso'),
                          icon:
                              Icon(Icons.arrow_downward),
                        ),
                        ButtonSegment(
                          value: 'Salida',
                          label: Text('Salida'),
                          icon:
                              Icon(Icons.arrow_upward),
                        ),
                      ],
                      selected: {tipo},
                      onSelectionChanged: (valor) {
                        cambiar(() {
                          tipo = valor.first;
                        });
                      },
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      controller: montoController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration:
                          const InputDecoration(
                        labelText: 'Monto',
                        prefixText: 'S/ ',
                        border:
                            OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField<String>(
                      value: categoria,
                      decoration:
                          const InputDecoration(
                        labelText: 'Categoría',
                        border:
                            OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Ventas',
                          child: Text('Ventas'),
                        ),
                        DropdownMenuItem(
                          value: 'Compras',
                          child: Text('Compras'),
                        ),
                        DropdownMenuItem(
                          value: 'Servicios',
                          child: Text('Servicios'),
                        ),
                        DropdownMenuItem(
                          value: 'Transporte',
                          child: Text('Transporte'),
                        ),
                        DropdownMenuItem(
                          value: 'Sueldos',
                          child: Text('Sueldos'),
                        ),
                        DropdownMenuItem(
                          value: 'Otros',
                          child: Text('Otros'),
                        ),
                      ],
                      onChanged: (valor) {
                        cambiar(() {
                          categoria = valor!;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller:
                          descripcionController,
                      maxLines: 2,
                      decoration:
                          const InputDecoration(
                        labelText: 'Descripción',
                        hintText:
                            'Ejemplo: Venta de productos',
                        border:
                            OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // FECHA
                    OutlinedButton.icon(
                      onPressed: () async {
                        final fecha =
                            await showDatePicker(
                          context: context,
                          initialDate:
                              fechaSeleccionada,
                          firstDate:
                              DateTime(2020),
                          lastDate:
                              DateTime(2100),
                        );

                        if (fecha != null) {
                          cambiar(() {
                            fechaSeleccionada =
                                fecha;
                          });
                        }
                      },
                      icon: const Icon(
                          Icons.calendar_month),
                      label: Text(
                        'Fecha: '
                        '${fechaSeleccionada.day}/'
                        '${fechaSeleccionada.month}/'
                        '${fechaSeleccionada.year}',
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final monto =
                              double.tryParse(
                            montoController.text
                                .trim(),
                          );

                          if (monto == null ||
                              monto <= 0) {
                            ScaffoldMessenger.of(
                                    context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Ingrese un monto válido',
                                ),
                              ),
                            );
                            return;
                          }

                          final movimiento =
                              Movimiento(
                            tipo: tipo,
                            monto: monto,
                            categoria:
                                categoria,
                            descripcion:
                                descripcionController
                                    .text
                                    .trim(),
                            fecha:
                                fechaSeleccionada,
                          );

                          setState(() {
                            movimientos.add(
                              movimiento,
                            );
                          });

                          Navigator.pop(context);

                          ScaffoldMessenger.of(
                                  this.context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                '$tipo de S/ '
                                '${monto.toStringAsFixed(2)} '
                                'registrado correctamente',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.save),
                        label: const Text(
                          'GUARDAR MOVIMIENTO',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
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
  // HISTORIAL
  // ----------------------------------------------------------

  void mostrarHistorial() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistorialPage(
          movimientos: movimientos,
          eliminarMovimiento: (movimiento) {
            setState(() {
              movimientos.remove(movimiento);
            });
          },
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // TARJETA
  // ----------------------------------------------------------

  Widget tarjeta(
    String titulo,
    double monto,
    IconData icono,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(
              icono,
              size: 32,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style:
                        const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'S/ ${monto.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
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
    final saldoDia =
        ingresosDia - salidasDia;

    final saldoMes =
        ingresosMes - salidasMes;

    final ahora = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DENALY GROUP',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 5),

              const Text(
                'Movimiento Económico',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Hoy: ${ahora.day}/'
                '${ahora.month}/'
                '${ahora.year}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 20),

              tarjeta(
                'Ingresos del día',
                ingresosDia,
                Icons.arrow_downward,
              ),

              const SizedBox(height: 10),

              tarjeta(
                'Salidas del día',
                salidasDia,
                Icons.arrow_upward,
              ),

              const SizedBox(height: 10),

              tarjeta(
                'Saldo del día',
                saldoDia,
                Icons.account_balance_wallet,
              ),

              const SizedBox(height: 25),

              // RESUMEN MENSUAL
              Card(
                elevation: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        'RESUMEN DEL MES',
                        style:
                            const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        'Ingresos: '
                        'S/ ${ingresosMes.toStringAsFixed(2)}',
                        style:
                            const TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Salidas: '
                        'S/ ${salidasMes.toStringAsFixed(2)}',
                        style:
                            const TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Saldo mensual: '
                        'S/ ${saldoMes.toStringAsFixed(2)}',
                        style:
                            const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  onPressed:
                      mostrarFormulario,
                  icon:
                      const Icon(Icons.add),
                  label: const Text(
                    'REGISTRAR MOVIMIENTO',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 55,
                child: OutlinedButton.icon(
                  onPressed:
                      mostrarHistorial,
                  icon: const Icon(
                    Icons.list_alt,
                  ),
                  label: const Text(
                    'VER HISTORIAL',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          FontWeight.bold,
                    ),
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
  final Function(Movimiento)
      eliminarMovimiento;

  const HistorialPage({
    super.key,
    required this.movimientos,
    required this.eliminarMovimiento,
  });

  @override
  State<HistorialPage> createState() =>
      _HistorialPageState();
}

class _HistorialPageState
    extends State<HistorialPage> {

  @override
  Widget build(BuildContext context) {
    final lista =
        [...widget.movimientos];

    lista.sort(
      (a, b) =>
          b.fecha.compareTo(a.fecha),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Historial de movimientos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: lista.isEmpty
          ? const Center(
              child: Text(
                'Todavía no hay movimientos',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          : ListView.builder(
              padding:
                  const EdgeInsets.all(12),
              itemCount: lista.length,
              itemBuilder:
                  (context, index) {
                final movimiento =
                    lista[index];

                final esIngreso =
                    movimiento.tipo ==
                        'Ingreso';

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        esIngreso
                            ? Icons
                                .arrow_downward
                            : Icons
                                .arrow_upward,
                      ),
                    ),

                    title: Text(
                      '${movimiento.tipo} - '
                      'S/ ${movimiento.monto.toStringAsFixed(2)}',
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    subtitle: Text(
                      '${movimiento.categoria}\n'
                      '${movimiento.descripcion}\n'
                      'Fecha: '
                      '${movimiento.fecha.day}/'
                      '${movimiento.fecha.month}/'
                      '${movimiento.fecha.year}',
                    ),

                    isThreeLine: true,

                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                      ),
                      onPressed: () {
                        widget.eliminarMovimiento(
                            movimiento);

                        setState(() {});

                        ScaffoldMessenger.of(
                                context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Movimiento eliminado',
                            ),
                          ),
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import '../services/api_service.dart';
import 'edit_book_dialog.dart';

class BookDetailPage extends StatefulWidget {
  final Map<String, dynamic> libro;
  const BookDetailPage({super.key, required this.libro});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final ApiService apiService = ApiService();
  late Map<String, dynamic> _libro;

  @override
  void initState() {
    super.initState();
    _libro = Map.from(widget.libro);
  }

  String formatFecha(String? fechaStr) {
    if (fechaStr == null || fechaStr.isEmpty) return '';
    try {
      final dateUtc = DateTime.parse(fechaStr);
      final bogotaLocation = tz.getLocation('America/Bogota');
      final dateBogota = tz.TZDateTime.from(dateUtc, bogotaLocation);
      final formatter = DateFormat("EEEE, d 'de' MMMM 'de' y 'a las' HH:mm", 'es_ES');
      return formatter.format(dateBogota);
    } catch (e) {
      return fechaStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00008B), // Strong dark blue
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info, color: Colors.white),
            SizedBox(width: 8),
            Text('Detalles del libro'),
          ],
        ),
      ),
      body: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(seconds: 3),
        builder: (context, double value, child) {
          final animatedColor = Color.lerp(Colors.black, Colors.blue.shade900, value)!;
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [animatedColor, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: child,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade900, Colors.black],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.book, color: Colors.white),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _libro['nombre'] ?? '',
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.person, color: Colors.white),
                              const SizedBox(width: 8),
                              Text('Autor: ${_libro['autor'] ?? ''}', style: TextStyle(color: Colors.blue.shade200)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.qr_code, color: Colors.white),
                              const SizedBox(width: 8),
                              Text('ISBN: ${_libro['isbn'] ?? ''}', style: TextStyle(color: Colors.blue.shade200)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade900, Colors.black],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Estado de lectura:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text(_libro['estadoLectura'] ?? '', style: TextStyle(color: Colors.blue.shade200)),
                          const SizedBox(height: 12),
                          const Text('Calificación:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          Row(
                            children: List.generate(5, (i) => Icon(
                              i < (_libro['calificacion'] ?? 0) ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_libro['notasPersonales'] != null && _libro['notasPersonales'].isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade900, Colors.black],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 4,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Notas personales:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            const SizedBox(height: 8),
                            Text(_libro['notasPersonales'], style: TextStyle(color: Colors.blue.shade200)),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade900, Colors.black],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.update, color: Colors.white),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Última actualización: ${formatFecha(_libro['ultimaActualizacion'] as String?)}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(color: Colors.blue.shade200),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        final libros = await apiService.listarLibros();
                        final isbnsExistentes = libros.map((l) => l['isbn'] as String).where((isbn) => isbn != _libro['isbn']).toList();
                        await showDialog(
                          context: context,
                          builder: (context) => EditBookDialog(
                            libro: _libro,
                        onSave: (libroEditado) async {
                              try {
                                await apiService.actualizarLibro(_libro['isbn'], libroEditado);
                                final libroActualizado = await apiService.obtenerLibro(_libro['isbn']);
                                if (context.mounted) {
                                  setState(() => _libro = libroActualizado);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Libro actualizado correctamente')));
                                  Navigator.of(context).pop(true);
                                }
                                return true;
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar: $e')));
                                }
                                return false;
                              }
                            },
                            isbnsExistentes: isbnsExistentes,
                          ),
                        );
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al cargar datos: $e')));
                        }
                      }
                    },
                    icon: const Icon(Icons.edit, size: 20),
                    label: const Text('Editar libro'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 3,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirmar eliminación'),
                          content: const Text('¿Estás seguro de que deseas eliminar este libro?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        try {
                          await apiService.eliminarLibro(_libro['isbn']);
                          if (context.mounted) {
                            Navigator.of(context).pop(true); // Regresa a la lista principal
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Libro eliminado correctamente')));
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
                          }
                        }
                      }
                    },
                    icon: const Icon(Icons.delete, size: 20),
                    label: const Text('Eliminar libro'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 3,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
}

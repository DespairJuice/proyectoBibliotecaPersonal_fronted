import 'search_book_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import 'book_detail_page.dart';
import 'add_book_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> _librosFuture;
  int _refreshCounter = 0;

  @override
  void initState() {
    super.initState();
    _librosFuture = apiService.listarLibros();
  }

  void _refreshLibros() {
    setState(() {
      _refreshCounter++;
      _librosFuture = apiService.listarLibros();
    });
  }

  Color _getEstadoColor(String? estado) {
    switch (estado) {
      case 'Leyendo':
        return Colors.yellow;
      case 'Leído':
        return Colors.green.shade300;
      case 'Por leer':
        return Colors.orange.shade400;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00008B), // Strong dark blue
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/biblioteca_personal_logo.png',
                width: 32,
                height: 32,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'BIBLIOTECA PERSONAL',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Row(
                    children: [
                      Icon(Icons.exit_to_app, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Salir de la aplicación'),
                    ],
                  ),
                  content: const Text('¿Estás seguro de que deseas salir de la aplicación?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Cerrar diálogo
                        // Intentar cerrar la aplicación
                        SystemNavigator.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Salir'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            tooltip: 'Salir',
          ),
        ],
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
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.blue.shade900],
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final librosActuales = await _librosFuture;
                          final isbns = librosActuales.map((l) => l['isbn']?.toString() ?? '').toList();
                          await showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                            barrierColor: Colors.black54,
                            transitionDuration: const Duration(milliseconds: 300),
                            pageBuilder: (context, animation, secondaryAnimation) => Container(),
                            transitionBuilder: (context, animation, secondaryAnimation, child) {
                              return ScaleTransition(
                                scale: Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.elasticOut)),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: AddBookDialog(
                                    isbnsExistentes: isbns,
                                    onSave: (libro) async {
                                      try {
                                        await apiService.registrarLibro(libro);
                                        setState(() {
                                          _librosFuture = apiService.listarLibros();
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Libro guardado correctamente')));
                                        return true;
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
                                        return false;
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.add_circle, size: 28),
                        label: const Text('Agregar libro', style: TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 4, 126, 10),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final libroSeleccionado = await showGeneralDialog<Map<String, dynamic>>(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                            barrierColor: Colors.black54,
                            transitionDuration: const Duration(milliseconds: 300),
                            pageBuilder: (context, animation, secondaryAnimation) => Container(),
                            transitionBuilder: (context, animation, secondaryAnimation, child) {
                              return ScaleTransition(
                                scale: Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.elasticOut)),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: SearchBookDialog(
                                    onSearch: (filtros) async {
                                      try {
                                        final resultados = await apiService.buscarLibros(
                                          titulo: filtros['titulo'],
                                          autor: filtros['autor'],
                                          isbn: filtros['isbn'],
                                          estadoLectura: filtros['estadoLectura'],
                                          calificacion: filtros['calificacion'],
                                        );
                                        return resultados;
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                                        return [];
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                          if (libroSeleccionado != null) {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BookDetailPage(libro: libroSeleccionado),
                              ),
                            );
                            if (result == true) {
                              _refreshLibros();
                            }
                          }
                        },
                        icon: const Icon(Icons.search_rounded, size: 28),
                        label: const Text('Buscar Libro', style: TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 24, 44, 226),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _librosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: \\${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No hay libros disponibles.'));
                  } else {
                    final libros = snapshot.data!;
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: libros.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final libro = libros[index];
                        return Container(
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
                          child: ListTile(
                            leading: const Icon(Icons.book, color: Colors.white),
                            title: Text(
                              libro['nombre'] ?? 'Sin título',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Autor: ${libro['autor'] ?? 'Sin autor'}', style: TextStyle(color: Colors.blue.shade200)),
                                Text('ISBN: ${libro['isbn'] ?? ''}', style: TextStyle(color: Colors.blue.shade200)),
                                Row(
                                  children: [
                                    const Icon(Icons.star, size: 16, color: Colors.amber),
                                    Text(' ${libro['calificacion'] ?? 0}/5', style: TextStyle(color: Colors.blue.shade200)),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Chip(
                              label: Text(libro['estadoLectura'] ?? '', style: const TextStyle(color: Colors.white)),
                              backgroundColor: _getEstadoColor(libro['estadoLectura']).withOpacity(0.8),
                            ),
                            onTap: () async {
                              await Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => BookDetailPage(libro: libro),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOut;
                                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                    var offsetAnimation = animation.drive(tween);
                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                              setState(() {
                                _librosFuture = apiService.listarLibros();
                              });
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}

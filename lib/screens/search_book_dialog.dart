import 'package:flutter/material.dart';

class SearchBookDialog extends StatefulWidget {
  final Future<List<dynamic>> Function(Map<String, dynamic> filtros) onSearch;
  const SearchBookDialog({super.key, required this.onSearch});

  @override
  State<SearchBookDialog> createState() => _SearchBookDialogState();
}

class _SearchBookDialogState extends State<SearchBookDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  String? _estadoLectura;
  int? _calificacion;
  bool _buscando = false;
  List<dynamic>? _resultados;

  Color _getEstadoColor(String? estado) {
    switch (estado) {
      case 'Leyendo':
        return Colors.yellow;
      case 'Leído':
        return Colors.green.shade300;
      case 'Por leer':
        return Colors.orange.shade400;
      default:
        return Colors.grey.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue.shade900,
      title: const Row(
        children: [
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 8),
          Text('Buscar libro', style: TextStyle(color: Colors.white)),
        ],
      ),
      content: SizedBox(
        width: 400,
        height: 500,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _tituloController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.title, color: Colors.white70),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade800,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _autorController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Autor',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.person, color: Colors.white70),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade800,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _isbnController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'ISBN',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.qr_code, color: Colors.white70),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade800,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _estadoLectura,
                dropdownColor: Colors.blue.shade800,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Estado de lectura',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade800,
                ),
                items: const [
                  DropdownMenuItem(value: 'Leyendo', child: Text('Leyendo', style: TextStyle(color: Colors.white))),
                  DropdownMenuItem(value: 'Leído', child: Text('Leído', style: TextStyle(color: Colors.white))),
                  DropdownMenuItem(value: 'Por leer', child: Text('Por leer', style: TextStyle(color: Colors.white))),
                ],
                onChanged: (v) => setState(() => _estadoLectura = v),
                isExpanded: true,
                hint: Text('Selecciona estado', style: TextStyle(color: Colors.white70)),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Calificación:', style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 4),
                  Center(
                    child: Wrap(
                      spacing: 4,
                      alignment: WrapAlignment.center,
                      children: [
                        for (int i = 1; i <= 5; i++)
                          IconButton(
                            icon: Icon(
                              i <= (_calificacion ?? 0) ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                            ),
                            onPressed: () => setState(() => _calificacion = i),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_buscando) const Center(child: CircularProgressIndicator()),
              if (_resultados != null)
                Expanded(
                  child: _resultados!.isEmpty
                      ? const Center(child: Text('No se encontraron libros.'))
                      : ListView.separated(
                          itemCount: _resultados!.length,
                          separatorBuilder: (c, i) => const SizedBox(height: 8),
                          itemBuilder: (c, i) {
                            final libro = _resultados![i];
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
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop(libro);
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.book, color: Colors.white, size: 24),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              libro['nombre'] ?? 'Sin título',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.person, color: Colors.white, size: 18),
                                          const SizedBox(width: 4),
                                          Text('Autor: ${libro['autor'] ?? 'Sin autor'}', style: const TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.qr_code, color: Colors.white, size: 18),
                                          const SizedBox(width: 4),
                                          Text('ISBN: ${libro['isbn'] ?? ''}', style: const TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Text('Estado: ', style: TextStyle(color: Colors.white)),
                                          Chip(
                                            label: Text(libro['estadoLectura'] ?? ''),
                                            backgroundColor: _getEstadoColor(libro['estadoLectura']),
                                            labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              const Icon(Icons.star, size: 16, color: Colors.amber),
                                              Text('${libro['calificacion'] ?? 0}/5', style: const TextStyle(color: Colors.white)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, size: 20),
          label: const Text('Cerrar'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade600,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        ElevatedButton.icon(
          onPressed: _buscando
              ? null
              : () async {
                  setState(() => _buscando = true);
                  final filtros = <String, dynamic>{};
                  if (_tituloController.text.trim().isNotEmpty) filtros['titulo'] = _tituloController.text.trim();
                  if (_autorController.text.trim().isNotEmpty) filtros['autor'] = _autorController.text.trim();
                  if (_isbnController.text.trim().isNotEmpty) filtros['isbn'] = _isbnController.text.trim();
                  if (_estadoLectura != null) filtros['estadoLectura'] = _estadoLectura;
                  if (_calificacion != null) filtros['calificacion'] = _calificacion;
                  final resultados = await widget.onSearch(filtros);
                  setState(() {
                    _resultados = resultados;
                    _buscando = false;
                  });
                },
          icon: const Icon(Icons.search, size: 20),
          label: const Text('Buscar libros'),
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
      ],
    );
  }
}

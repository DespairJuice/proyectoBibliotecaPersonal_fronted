import 'package:flutter/material.dart';

class EditBookDialog extends StatefulWidget {
  final Map<String, dynamic> libro;
  final Future<bool> Function(Map<String, dynamic> libro) onSave;
  final List<String> isbnsExistentes;

  const EditBookDialog({super.key, required this.libro, required this.onSave, required this.isbnsExistentes});

  @override
  State<EditBookDialog> createState() => _EditBookDialogState();
}

class _EditBookDialogState extends State<EditBookDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloController;
  late final TextEditingController _autorController;
  late final TextEditingController _isbnController;
  late final TextEditingController _notasController;
  late String _estadoLectura;
  late int _calificacion;
  // String? _imagenPath; // Implementar carga de imagen si se requiere

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.libro['nombre'] ?? '');
    _autorController = TextEditingController(text: widget.libro['autor'] ?? '');
    _isbnController = TextEditingController(text: widget.libro['isbn'] ?? '');
    _notasController = TextEditingController(text: widget.libro['notasPersonales'] ?? '');
    _estadoLectura = widget.libro['estadoLectura'] ?? 'Leyendo';
    _calificacion = widget.libro['calificacion'] ?? 0;
  }

  String? _isbnValidator(String? value) {
    if (value == null || value.isEmpty) return 'El ISBN es obligatorio';
    final cleanIsbn = value.replaceAll(RegExp(r'[- ]'), '');
    if (!(cleanIsbn.length == 10 || cleanIsbn.length == 13)) return 'ISBN debe tener 10 o 13 dígitos';
    if (!RegExp(r'^[0-9Xx]+$').hasMatch(cleanIsbn)) return 'ISBN inválido';
    if (!isValidIsbn(cleanIsbn)) return 'ISBN inválido (dígito de control)';
    // No permitir cambiar el ISBN al editar
    if (cleanIsbn != widget.libro['isbn']) return 'No se puede cambiar el ISBN al editar el libro';
    return null;
  }

  bool isValidIsbn(String isbn) {
    if (isbn.length == 10) {
      int sum = 0;
      for (int i = 0; i < 9; i++) {
        sum += (int.tryParse(isbn[i]) ?? 0) * (10 - i);
      }
      var last = isbn[9].toUpperCase();
      sum += (last == 'X') ? 10 : int.tryParse(last) ?? 0;
      return sum % 11 == 0;
    } else if (isbn.length == 13) {
      int sum = 0;
      for (int i = 0; i < 12; i++) {
        int digit = int.tryParse(isbn[i]) ?? 0;
        sum += (i % 2 == 0) ? digit : digit * 3;
      }
      int checkDigit = (10 - (sum % 10)) % 10;
      return checkDigit == int.tryParse(isbn[12]);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue.shade900,
      title: const Row(
        children: [
          Icon(Icons.edit, color: Colors.white),
          SizedBox(width: 8),
          Text('Editar libro', style: TextStyle(color: Colors.white)),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _tituloController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Título *',
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
                validator: (v) => v == null || v.isEmpty ? 'El título es obligatorio' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _autorController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Autor *',
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
                validator: (v) => v == null || v.isEmpty ? 'El autor es obligatorio' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _isbnController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'ISBN *',
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
                validator: _isbnValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notasController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Notas personales',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.notes, color: Colors.white70),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade800,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _estadoLectura,
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
                onChanged: (v) => setState(() => _estadoLectura = v ?? 'Leyendo'),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Calificación:', style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: [
                      for (int i = 1; i <= 5; i++)
                        IconButton(
                          icon: Icon(
                            i <= _calificacion ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () => setState(() => _calificacion = i),
                        ),
                    ],
                  ),
                ],
              ),
              // TODO: Implementar carga de imagen si se requiere
            ],
          ),
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.cancel, size: 20),
          label: const Text('Cancelar'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade600,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final isbnLimpio = _isbnController.text.trim().replaceAll(RegExp(r'[- ]'), '');
              final libro = {
                'nombre': _tituloController.text.trim(),
                'autor': _autorController.text.trim(),
                'isbn': isbnLimpio,
                'notasPersonales': _notasController.text.trim(),
                'estadoLectura': _estadoLectura,
                'calificacion': _calificacion,
                'ultimaActualizacion': DateTime.now().toIso8601String(),
                // 'imagen': _imagenPath, // Implementar si se requiere
              };
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmar cambios'),
                  content: const Text('¿Estás seguro de que deseas guardar los cambios?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                final ok = await widget.onSave(libro);
                if (ok) Navigator.of(context).pop(true);
              }
            }
          },
          icon: const Icon(Icons.save, size: 20),
          label: const Text('Guardar cambios'),
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

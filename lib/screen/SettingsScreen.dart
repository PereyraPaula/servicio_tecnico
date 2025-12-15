import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _mediaFile;
  static const String _imagePathKey = 'footer_image_path';

  @override
  void initState() {
    super.initState();
    _loadSavedImage();
  }

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPath = prefs.getString(_imagePathKey);

    if (savedPath != null && await File(savedPath).exists()) {
      setState(() {
        _mediaFile = XFile(savedPath);
      });
      print('Loaded saved image: $savedPath');
    }
  }

  Future<void> _saveImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imagePathKey, path);
    print('Image path saved: $path');
  }

  Future<void> _deleteImage() async {
    if (_mediaFile != null) {
      try {
        final file = File(_mediaFile!.path);
        if (await file.exists()) {
          await file.delete();
          print('Image file deleted: ${_mediaFile!.path}');
        }
      } catch (e) {
        print('Error deleting file: $e');
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_imagePathKey);

    setState(() {
      _mediaFile = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Imagen eliminada correctamente'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _pickMedia(ImageSource source) async {
    XFile? file = await _picker.pickImage(source: source);
    if (file != null) {
      await _saveImagePath(file.path);

      setState(() => _mediaFile = file);
      print('Picked file: ${file.path}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Imagen guardada correctamente'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar imagen'),
          content: const Text(
              '¿Estás seguro de que quieres eliminar la imagen del pie de página?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteImage();
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF1F3F4),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Ajustes'),
          backgroundColor: const Color(0xFF2A3D53),
          foregroundColor: Colors.white,
        ),
        body: ListView(
          children: <Widget>[
            if (_mediaFile != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Vista Previa del Pie de Página:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: _showDeleteDialog,
                          tooltip: 'Eliminar imagen',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      children: [
                        Image.file(
                          File(_mediaFile!.path),
                          height: 100,
                          width: 200,
                          fit: BoxFit.contain,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Imagen cargada: ${_mediaFile!.path.split('/').last}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Imagen de Pie de Página en PDF'),
              subtitle: const Text('Selecciona un logo o imagen.'),
              trailing: const Icon(Icons.upload_file),
              onTap: () => _pickMedia(ImageSource.gallery),
            ),
            const Divider(),
            /* ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Tema'),
              onTap: () {/* ... */},
            ), */
          ],
        ),
      ),
    );
  }
}

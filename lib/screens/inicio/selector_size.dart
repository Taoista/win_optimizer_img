import 'package:flutter/material.dart';
import 'dart:io';

import 'package:win_optimizer_img/helpers/file_extencions.dart';
import 'package:file_picker/file_picker.dart';



class SelectorSize extends StatefulWidget {

  final Function(List<String>) addPathImage;
  final Function() cleanListImage;

  const SelectorSize({super.key, required, required this.addPathImage, required this.cleanListImage});

  @override
  State<SelectorSize> createState() => _SelectorSizeState();
}

class _SelectorSizeState extends State<SelectorSize> {

  List<String> _filePaths = [];

    void _pickFolder() async {
    // Open the folder picker dialog
    final result = await FilePicker.platform.getDirectoryPath();

    if (result != null) {
      // Get all files in the selected directory
      final directory = Directory(result);
      final List<FileSystemEntity> entities = directory.listSync();
      
      List<String> listaPrevia = entities.map((entity) => entity.path).toList();

      List<String> imageFiles = listaPrevia.where((file) {
        // Obtener la extensión del archivo
        String extension = file.split('.').last.toLowerCase();
        
        // Verificar si la extensión está en la lista de extensiones de imagen
        return imageExtensions.contains(extension);
      }).toList();
      _filePaths = imageFiles;
      widget.addPathImage(imageFiles);
    }
  }

  void _cleanListFilesSelected(){
    setState(() {
      _filePaths = [];
      widget.cleanListImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            const Text('Lista de Archivos:'),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: ListView(
                children: _filePaths
                    .map((file) => ListTile(title: Text(file)))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),

              ElevatedButton(
              onPressed: _pickFolder,
              child: const Text('Seleccionar Carpeta'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cleanListFilesSelected,
              child: const Text('Limpiar Lista'),
            ),
          ],
        ),
      );
  }
}
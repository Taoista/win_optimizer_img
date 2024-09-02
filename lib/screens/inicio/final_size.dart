import 'package:flutter/material.dart';
import 'package:win_optimizer_img/helpers/file_extencions.dart';
import 'package:file_selector/file_selector.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path; // Necesitarás importar este paquete

class FinalSize extends StatefulWidget {
  final List<String> listImages;
  const FinalSize({super.key, required this.listImages}) ;

  @override
  State<FinalSize> createState() => _FinalSizeState();
}

class _FinalSizeState extends State<FinalSize> {

  List<String> selectedFiles = [];
  String? selectedExtension;
  bool optimizeImage = false;
  double imageQuality = 1.0;
  String? sourceFile;

  String finalFOlder = "";


  void _pickExtension(String? extension) {
    setState(() {
      selectedExtension = extension.toString();
    });
  }

 

  // * seleccion de carpeta de destino
  void _selectDirectory() async {
    final String? directoryPath = await getDirectoryPath();
    if (directoryPath != null) {
        setState(() {
          finalFOlder = directoryPath;
        });
    } else {
      setState(() {
          finalFOlder = '';
        });
    }
  }


  void compressAndSaveImage(String urlStart,String urlFinish, String extencion, int quality) async {
      // Rutas de los archivos
      // Rutas de los archivos
    String start = urlStart;
    String finishDir  = urlFinish;

    // Leer la imagen original
    final imageFile = File(start);
    final imageBytes = await imageFile.readAsBytes();
    final originalImage = img.decodeImage(imageBytes);

    if (originalImage == null) {
      return;
    }

    // Obtener el nombre base del archivo y cambiar la extensión a .jpg
    String originalName = path.basenameWithoutExtension(start);
    String newName = '$originalName.$extencion';
    String finish = path.join(finishDir, newName);

    // No cambiamos el tamaño de la imagen. Simplemente la volvemos a codificar con calidad ajustada.
    // Convertir la imagen a formato webp
    final compressedImage = img.encodeJpg(originalImage, quality: quality); // Ajusta la calidad a un valor más bajo para mayor compresión

    // Guardar la imagen comprimida
    final outputFile = File(finish);
    await outputFile.writeAsBytes(compressedImage);
  }

  void processImages(List<String> imagesUrls, String urlFinish, String extencion, int quality) async {
    for(String url in imagesUrls) {
        compressAndSaveImage(url, urlFinish, extencion, quality);
        addingFilesOptimizated(url);
    }
  }


  void addingFilesOptimizated(String filePath){
    setState(() {
      selectedFiles.add(filePath);
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Archivos Optimizados:'),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: ListView(
                children: selectedFiles
                    .map((file) => ListTile(title: Text(file)))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _selectDirectory,
              child: const Text('Carpeta de destino'),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedExtension,
              hint: const Text('Archivos'),
              items: imageExtensions.map((extension) {
                return DropdownMenuItem(
                  value: extension,
                  child: Text(extension),
                );
              }).toList(),
              onChanged: _pickExtension,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Optimizar:'),
                Expanded(
                  child: Slider(
                    value: imageQuality,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    onChanged: (value) {
                      setState(() {
                        imageQuality = value;
                      });
                    },
                  ),
                ),
                Text('${(imageQuality * 100).toInt()}%'),
              ],
            ),
            const SizedBox(height: 16),
           
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: (){
             
                int imageOptimization = (100 - (imageQuality * 100).toInt());
                String extencion = selectedExtension.toString();
                processImages(widget.listImages,finalFOlder, extencion, imageOptimization);
              },
              child: const Text('Convertir'),
            ),
          ],
        ),
      );
  }
}
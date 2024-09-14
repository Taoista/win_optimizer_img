import 'package:flutter/material.dart';
import 'package:win_optimizer_img/helpers/file_extencions.dart';
import 'package:file_selector/file_selector.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:win_optimizer_img/widgets/button_loading.dart'; // Necesitarás importar este paquete

class FinalSize extends StatefulWidget {
  final List<String> listImages;

  final Function(List) modifyProgreesInicator;


  const FinalSize({super.key, required this.listImages, required this.modifyProgreesInicator});

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

  bool isLoading = false;

  int totalImageFinished = 0;

  bool _stateButton = false;

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


  Future<bool> compressAndSaveImage(String urlStart,String urlFinish, String extencion, int quality) async {
    // Rutas de los archivos
    String start = urlStart;
    String finishDir  = urlFinish;


    // Leer la imagen original
    final imageFile = File(start);
    final imageBytes = await imageFile.readAsBytes();
    final originalImage = img.decodeImage(imageBytes);

    if (originalImage == null) {
      return false;
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
    return true;
  }

  // * procesando imagen de seleccion
  Future<bool> processImages(List<String> imagesUrls, String urlFinish, String extencion, int quality) async {
    
    // ? control de seleccion de archivos de origen
    if(imagesUrls.isEmpty){
      _alertErrorNotImagesSelected(context);
      return false;
    }
    // ? control de destino
    if(urlFinish == ''){
      _alertErrorNotFinishUrl(context);
      return false;
    }
    // ? control de extencion
    if(selectedExtension == null){
      _alertErrorNotExtension(context);
      return false;
    }

    // ? control de destino
    setState(() {
      _stateButton = true;
    });
    List<bool> finishied = [];
    for(String url in imagesUrls) {
        bool result = await compressAndSaveImage(url, urlFinish, extencion, quality);
        addingFilesOptimizated(url);
        finishied.add(result);
        widget.modifyProgreesInicator(finishied);
        setState(() {
          totalImageFinished = finishied.length;
        });
    }
     setState(() {
      _stateButton = false;
    });
    _alertSuccess(context);
    return true;
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
            Text('Archivos Optimizados: $totalImageFinished'),
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
            isLoading ?
            const ElevatedButton(onPressed: null, child: null):
            _stateButton ? const ButtonLoading() :
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

  void _alertErrorNotExtension(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Debe seleccionar la extensión para continuar.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ok'),
            ),
          ],
        );
      },
    );
  }

  void _alertErrorNotImagesSelected(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Debe seleccionar imágenes para convertir.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ok'),
            ),
          ],
        );
      },
    );
  }
  void _alertErrorNotFinishUrl(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Debe seleccionar ruta final.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ok'),
            ),
          ],
        );
      },
    );
  }

  void _alertSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Termino'),
          content: const Text('Las imagenes terminar de convertir.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ok'),
            ),
          ],
        );
      },
    );
  }


}
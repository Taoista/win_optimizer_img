import 'package:flutter/material.dart';



class FinalSize extends StatefulWidget {
  const FinalSize({super.key});

  @override
  State<FinalSize> createState() => _FinalSizeState();
}

class _FinalSizeState extends State<FinalSize> {

  List<String> selectedFiles = [];
  String? selectedExtension;
  bool optimizeImage = false;
  double imageQuality = 1.0;
  String? sourceFile;

  void _pickExtension(String? extension) {
    setState(() {
      selectedExtension = extension;
    });
  }

  // * selecciona el rango de la opctimizacion
  void _toggleOptimizeImage(bool? value) {
    setState(() {
      optimizeImage = value ?? false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ElevatedButton(
              onPressed: null,
              child: Text('Carpeta de destino'),
            ),
            const SizedBox(height: 16),
            const Text('Selected Files:'),
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
            DropdownButton<String>(
              value: selectedExtension,
              hint: const Text('Select Extension'),
              items: ['jpg', 'png', 'gif'].map((extension) {
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
                const Text('Quality:'),
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
            Row(
              children: [
                const Text('Optimize Image'),
                Switch(
                  value: optimizeImage,
                  onChanged: _toggleOptimizeImage,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (sourceFile != null) Text('Source File: $sourceFile'),
          ],
        ),
      );
  }
}
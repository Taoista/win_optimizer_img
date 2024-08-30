import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  List<String> files = [];
  List<String> selectedFiles = [];
  String? sourceFile;
  String? selectedExtension;
  double imageQuality = 1.0;
  bool optimizeImage = false;

  void _pickSourceFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        sourceFile = result.files.single.path;
      });
    }
  }

  void _selectFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        files = result.paths.map((path) => path ?? '').toList();
      });
    }
  }

  void _pickExtension(String? extension) {
    setState(() {
      selectedExtension = extension;
    });
  }

  void _toggleOptimizeImage(bool? value) {
    setState(() {
      optimizeImage = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: null,
                  child: Text('Select Files'),
                ),
                ElevatedButton(
                  onPressed: null,
                  child: Text('Pick Source File'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('File List:'),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: ListView(
                          children: files
                              .map((file) => ListTile(title: Text(file)))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selected Files:'),
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
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedExtension,
                    hint: Text('Select Extension'),
                    items: ['jpg', 'png', 'gif'].map((extension) {
                      return DropdownMenuItem(
                        value: extension,
                        child: Text(extension),
                      );
                    }).toList(),
                    onChanged: _pickExtension,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Row(
                    children: [
                      Text('Quality:'),
                      Slider(
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
                      Text('${(imageQuality * 100).toInt()}%'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Optimize Image'),
                Switch(
                  value: optimizeImage,
                  onChanged: _toggleOptimizeImage,
                ),
              ],
            ),
            SizedBox(height: 16),
            if (sourceFile != null) Text('Source File: $sourceFile'),
          ],
        ),
      ),
    );
  }
}

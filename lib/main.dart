import 'package:flutter/material.dart';
import 'package:win_optimizer_img/screens/inicio/inicio_screen.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

void main() {
  runApp(const MyApp());

  doWhenWindowReady(() {
    const initialSize = Size(800, 600); 
    appWindow.size = initialSize;
    appWindow.minSize = initialSize; 
    appWindow.maxSize = initialSize; 
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Win Optimzer Image',
      home: InicioScreen(),
    );
  }
}

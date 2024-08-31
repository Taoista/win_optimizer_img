import 'package:flutter/material.dart';

import 'package:win_optimizer_img/screens/inicio/final_size.dart';
import 'package:win_optimizer_img/screens/inicio/selector_size.dart';


class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Win Optimizer Image'),
      ),
      body: const Padding(
        padding:  EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectorSize(),
             SizedBox(width: 16),
            FinalSize()
          ],
        ),
      )
    );
  }
}

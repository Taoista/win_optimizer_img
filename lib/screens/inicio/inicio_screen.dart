import 'package:flutter/material.dart';
import 'package:win_optimizer_img/screens/inicio/final_size.dart';
import 'package:win_optimizer_img/screens/inicio/selector_size.dart';


class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {

  List<String> _listImage = [];

  double _advance = 0.00;
  
  void addPathImage(List<String> listImage){
    setState(() {
      _listImage = listImage;
    });
  }

  void cleanListImage(){
    setState(() {
      _listImage = [];
      _advance = 0.00;
    });
  }

  // * modifica el progress indicator
  // ? bool es el resutlado true es ok false salio malo
  void modifyProgreesInicator(List finishied){
    int totalImages = _listImage.length;

    int pasados = finishied.length;

    double firsParse = (100 / (totalImages / pasados));

    int parseInt = roundToInteger(firsParse);

    double percentAdvance = (parseInt / 100);
    setState(() {
      _advance = percentAdvance;
    });
  }

  // * redondea
  double roundToNearest(double step, double value) {
    return (value / step).round() * step;
  }

  int roundToInteger(double value) {
  return value.round();
}

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Win Optimizer Image'),
      ),
      body:  Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectorSize(addPathImage: addPathImage,cleanListImage: cleanListImage),
                    const SizedBox(width: 16),
                    FinalSize(listImages: _listImage, modifyProgreesInicator:modifyProgreesInicator),
                  ],
                ),
              ),
            ),
            // Barra de progreso al final de la pantalla
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LinearProgressIndicator(
                value: _advance, // 70% del progreso
                backgroundColor: Colors.grey[300],
                color: Colors.blue,
                minHeight: 10, // Asigna una altura mínima para evitar problemas de renderizado
              ),
            ),
          ],
        )
    );
  }
}

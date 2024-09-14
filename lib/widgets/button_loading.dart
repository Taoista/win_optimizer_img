import 'package:flutter/material.dart';



class ButtonLoading extends StatelessWidget {
  const ButtonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
                  width: 170,  // Ajusta el ancho del botón
                  child: ElevatedButton(
                    onPressed: null,
                    child: SizedBox(
                      height: 20,  // Tamaño más pequeño para el spinner
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ),
                    ),
                  ),
                );
  }
}
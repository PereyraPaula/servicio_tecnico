import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          textAlign: TextAlign.center,
          'Pantalla de Configuración \n Proximamente',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

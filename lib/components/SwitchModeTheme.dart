import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicio_tecnico/provider/ThemeProvider.dart';

class SwitchModeTheme extends StatefulWidget {
  const SwitchModeTheme({super.key});

  @override
  State<SwitchModeTheme> createState() => _SwitchModeThemeState();
}

class _SwitchModeThemeState extends State<SwitchModeTheme> {
  @override
  Widget build(BuildContext context) {
    final ct = Provider.of<ThemeProvider>(context);
    return Switch(
        value: ct.isDarkTheme,
        onChanged: (value) {
          ct.setThemeDark = value;
        },
        );
  }
}

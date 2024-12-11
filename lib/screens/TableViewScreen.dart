import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicio_tecnico/components/CustomAppBar.dart';
import 'package:servicio_tecnico/components/DataTableList.dart';
import 'package:servicio_tecnico/main.dart';
import 'package:servicio_tecnico/provider/DataProvider.dart';
import 'package:servicio_tecnico/provider/ThemeProvider.dart';

class TableViewScreen extends StatefulWidget {
  const TableViewScreen({Key? key}) : super(key: key);

  @override
  _TableViewScreenState createState() => _TableViewScreenState();
}

class _TableViewScreenState extends State<TableViewScreen> {
  @override
  Widget build(BuildContext context) {
    final ctxTheme = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: CustomAppBar(
        title: titleApp,
        styleTitle: const TextStyle(color: Colors.white),
        colorBackground: ctxTheme.colorSelected,
        showSwitch: true, 
        showIcon: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            DataTableList(),
            const SizedBox(height: 20),
            if (context.read<DataProvider>().data.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  context.read<DataProvider>().clearData();
                },
                child: const Text('Borrar Todo'),
              ),
          ]),
      ),
    );
  }
}

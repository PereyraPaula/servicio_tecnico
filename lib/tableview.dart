import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicio_tecnico/components/DataTableList.dart';
import 'package:servicio_tecnico/provider/DataProvider.dart';

class Tableview extends StatefulWidget {
  const Tableview({Key? key}) : super(key: key);

  @override
  _TableviewState createState() => _TableviewState();
}

class _TableviewState extends State<Tableview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Servicio técnico",
          style: TextStyle(color: Colors.black),
        ),
        leading: const BackButton(color: Colors.black),
      ),
      body: Column(
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
    );
  }
}

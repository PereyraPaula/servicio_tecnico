import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicio_tecnico/provider/DataProvider.dart';

class DataTableList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, child) {
      final data = dataProvider.data;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text('Cantidad'),
            ),
            DataColumn(
              label: Text('Descripción'),
            ),
            DataColumn(
              label: Text('PU'),
            ),
            DataColumn(
              label: Text('Total'),
            ),
            DataColumn(
              label: Text('Acciones'),
            ),
          ],
          rows: data.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return DataRow(
              cells: <DataCell>[
                DataCell(Text(item['cantidad'].toString())),
                DataCell(Text(item['descripcion'])),
                DataCell(Text(item['pu'])),
                DataCell(Text('\$${item['total']}')),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<DataProvider>().removeItem(index);
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      );
    });
  }
}

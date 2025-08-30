import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servicio_tecnico/classes/Budget.dart';
import 'package:servicio_tecnico/classes/BudgetItem.dart';
import 'package:servicio_tecnico/providers/budget_provider.dart';

class BudgetFormScreen extends ConsumerStatefulWidget {
  const BudgetFormScreen({super.key});

  @override
  ConsumerState<BudgetFormScreen> createState() => _BudgetFormScreenState();
}

class _BudgetFormScreenState extends ConsumerState<BudgetFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _clientNameController = TextEditingController();
  final _contactNumberController = MaskedTextController(
      mask: "000-0000000000"); // Formato con 549... de argentina

  // Controllers para los campos del item
  final _nameItemController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _quantityController = TextEditingController(text: "1");

  Budget _currentBudget = Budget(
    clientName: '',
    contactNumber: '',
  );

  @override
  void initState() {
    super.initState();
    final budget = ref.read(budgetsProvider);
    _currentBudget = Budget(
      clientName: '',
      contactNumber: '',
    );
  }

  void getData() {
    if (_formKey.currentState!.validate()) {
      // Budget final con todos los datos
      final completedBudget = _currentBudget.copyWith(
        clientName: _clientNameController.text,
        contactNumber: _contactNumberController.text.replaceAll("-", ""),
      );

      // print("Presupuesto creado: ${completedBudget.toString()}");

      ref.read(budgetsProvider.notifier).addBudget(completedBudget);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Presupuesto guardado exitosamente')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F4),
      appBar: AppBar(
        title: const Text(
          'Añadir presupuesto',
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color(0xFF2A3D53),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildClientInfoSection(),
              const SizedBox(height: 24),
              _buildItemFormSection(),
              const SizedBox(height: 24),
              _buildItemsListSection(),
              const SizedBox(height: 24),
              _buildTotalSection(),
              const SizedBox(height: 32),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _addItemToList() {
    if (_nameItemController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre del item es requerido')),
      );
      return;
    }

    final unitPrice = double.tryParse(_unitPriceController.text) ?? 0.0;
    final quantity = int.tryParse(_quantityController.text) ?? 1;

    if (unitPrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El precio debe ser mayor a 0')),
      );
      return;
    }

    final newItem = BudgetItem(
      description: _nameItemController.text,
      unitPrice: unitPrice,
      quantity: quantity,
    );

    setState(() {
      _currentBudget = _currentBudget.addItem(newItem);
    });

    _nameItemController.clear();
    _unitPriceController.clear();
    _quantityController.text = "1";
  }

  void _removeItem(String itemId) {
    setState(() {
      _currentBudget = _currentBudget.removeItem(itemId);
    });
    ref
        .read(budgetsProvider.notifier)
        .removeItemFromBudget(_currentBudget.id, itemId);
  }

  Widget _buildClientInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Información del cliente',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _clientNameController,
          decoration: InputDecoration(
            hintText: 'Nombre del cliente',
            hintStyle: const TextStyle(
              color: Color(0xFF2A3D53),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(
              Icons.person,
              color: Color(0xFF2A3D53),
            ),
            fillColor: Colors.white,
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  const BorderSide(color: Color(0xFF2A3D53), width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _contactNumberController,
          decoration: InputDecoration(
              hintText: 'Teléfono del cliente',
              hintStyle: const TextStyle(
                color: Color(0xFF2A3D53),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(
                Icons.phone,
                color: Color(0xFF2A3D53),
              ),
              fillColor: Colors.white,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide:
                    const BorderSide(color: Color(0xFF2A3D53), width: 1.5),
              )),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 8),
        Text(
          "Formato: 549-XXXXXXXXXX. \nNo hay que escribir simbolos, solo números.",
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildItemFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Añadir Items',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameItemController,
          decoration: InputDecoration(
              hintText: 'Nombre del item',
              hintStyle: const TextStyle(
                color: Color(0xFF2A3D53),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none),
              fillColor: Colors.white,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide:
                    const BorderSide(color: Color(0xFF2A3D53), width: 1.5),
              )),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _unitPriceController,
                decoration: InputDecoration(
                    hintText: 'Precio unitario',
                    hintStyle: const TextStyle(
                      color: Color(0xFF2A3D53),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none),
                    fillColor: Colors.white,
                    filled: true,
                    prefixText: '\$ ',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                          color: Color(0xFF2A3D53), width: 1.5),
                    )),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  hintText: 'Cantidad',
                  hintStyle: const TextStyle(
                    color: Color(0xFF2A3D53),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none),
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xFF2A3D53), width: 1.5),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _addItemToList, // Cambiar a la nueva función
            icon: const Icon(Icons.add),
            label: const Text('AÑADIR FILA'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: const Color(0xFFC0CDEC),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemsListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lista',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: _currentBudget.items.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      'No hay items agregados todavía',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _currentBudget.items.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                  itemBuilder: (context, index) {
                    final item = _currentBudget.items[index];
                    return ListTile(
                      title: Text(item.description),
                      subtitle: Text(
                          'Precio: \$${item.unitPrice} \nCantidad: ${item.quantity}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\$${item.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeItem(item.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTotalSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text(
          'Total: ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Text(
          '\$${_currentBudget.total.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2A3D53),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _currentBudget.items.isEmpty
            ? null
            : () {
                getData();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2A3D53),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Text(
          'Guardar presupuesto',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

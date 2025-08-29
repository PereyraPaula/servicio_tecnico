import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servicio_tecnico/components/Card.dart';
import 'package:servicio_tecnico/providers/budget_provider.dart';
import 'package:servicio_tecnico/screen/BudgetFormScreen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _BudgetFormScreenState();
}

class _BudgetFormScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final budgets = ref.watch(budgetsProvider);
    print(budgets);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      color: const Color(0xFFF1F3F4),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A3D53),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.all(10.0)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BudgetFormScreen()),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add),
                        Text(
                          "Agregar nuevo",
                          style: TextStyle(fontSize: 18.0),
                        )
                      ],
                    ),
                  ),
                ),
                const Text(
                  "Ultimos presupuestos",
                  style: TextStyle(fontSize: 18.0),
                ),
                Column(
                  children: budgets.map((budget) {
                    return CardItem(
                      budget: budget,
                      onShare: () {},
                      onDelete: () {
                        // ref.read(budgetsProvider.notifier).remove(budget);
                      },
                    );
                  }).toList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

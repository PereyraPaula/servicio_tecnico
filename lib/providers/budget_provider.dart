import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servicio_tecnico/classes/Budget.dart';
import 'package:servicio_tecnico/classes/BudgetItem.dart';

final budgetsProvider =
    StateNotifierProvider<BudgetsNotifier, List<Budget>>((ref) {
  return BudgetsNotifier();
});

class BudgetsNotifier extends StateNotifier<List<Budget>> {
  BudgetsNotifier() : super([]);

  void addBudget(Budget budget) {
    state = [...state, budget];
  }

  void removeBudget(String budgetId) {
    state = state.where((budget) => budget.id != budgetId).toList();
  }

  void updateBudget(Budget updatedBudget) {
    state = state
        .map((budget) => budget.id == updatedBudget.id ? updatedBudget : budget)
        .toList();
  }

  void addItemToBudget(String budgetId, BudgetItem item) {
    state = state.map((budget) {
      if (budget.id == budgetId) {
        return budget.addItem(item);
      }
      return budget;
    }).toList();
  }

  void removeItemFromBudget(String budgetId, String itemId) {
    state = state.map((budget) {
      if (budget.id == budgetId) {
        return budget.removeItem(itemId);
      }
      return budget;
    }).toList();
  }
}

import 'package:intl/intl.dart';
import 'BudgetItem.dart';

class Budget {
  final String id;
  String clientName;
  String contactNumber;
  final String creationDate;
  final List<BudgetItem> items;

  Budget({
    String? id,
    required this.clientName,
    required this.contactNumber,
    String? creationDate,
    List<BudgetItem>? items,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        creationDate = creationDate ?? DateTime.now().toIso8601String(),
        items = items ?? [];

  double get total {
    return items.fold(0.0, (sum, item) => sum + item.total);
  }

  Map<String, dynamic> toJson() {
    final formatter = NumberFormat.currency(locale: 'es_ES', symbol: '€');

    return {
      'id': id,
      'clientName': clientName,
      'contactNumber': contactNumber,
      'creationDate': creationDate,
      'price': formatter.format(total),
      'contact': contactNumber,
      'date': DateFormat('dd/MM/yyyy').format(DateTime.parse(creationDate)),
      'number': 'N°: $id',
      'total': total,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id']?.toString(),
      clientName: json['clientName']?.toString() ?? '',
      contactNumber: json['contactNumber']?.toString() ?? '',
      creationDate: json['creationDate']?.toString(),
      items: List<BudgetItem>.from(
        (json['items'] as List<dynamic>?)?.map((x) => BudgetItem.fromJson(x)) ??
            [],
      ),
    );
  }

  Map<String, dynamic> toViewBudgetMap() {
    final formatter = NumberFormat.currency(locale: 'es_ES', symbol: '€');

    return {
      'price': formatter.format(total),
      'contact': contactNumber,
      'date': DateFormat('dd/MM/yyyy').format(DateTime.parse(creationDate)),
      'number': 'N°: $id',
    };
  }

  Budget addItem(BudgetItem item) {
    return copyWith(items: [...items, item]);
  }

  Budget removeItem(String itemId) {
    return copyWith(
      items: items.where((item) => item.id != itemId).toList(),
    );
  }

  Budget updateItem(BudgetItem updatedItem) {
    return copyWith(
      items: items
          .map((item) => item.id == updatedItem.id ? updatedItem : item)
          .toList(),
    );
  }

  Budget copyWith({
    String? id,
    String? clientName,
    String? contactNumber,
    String? creationDate,
    List<BudgetItem>? items,
  }) {
    return Budget(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      contactNumber: contactNumber ?? this.contactNumber,
      creationDate: creationDate ?? this.creationDate,
      items: items ?? this.items,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Budget && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    final itemsSummary = items.isEmpty
        ? 'No items'
        : '${items.length} items: ${items.map((i) => "${i.description} - Cantidad: ${i.quantity} - Precio: ${i.unitPrice}")}';

    return 'Budget(id: $id, client: $clientName, contact: $contactNumber, '
        'total: \$${total.toStringAsFixed(2)}, $itemsSummary)';
  }
}

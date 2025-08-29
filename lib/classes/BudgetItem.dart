class BudgetItem {
  final String id;
  int quantity;
  String description;
  double unitPrice;

  BudgetItem({
    String? id,
    required this.quantity,
    required this.description,
    required this.unitPrice,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  // Getter para calcular el total automáticamente
  double get total => quantity * unitPrice;

  // Método para convertir a Map (útil para persistencia)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantity': quantity,
      'description': description,
      'unitPrice': unitPrice,
    };
  }

  // Método para crear desde Map
  factory BudgetItem.fromMap(Map<String, dynamic> map) {
    return BudgetItem(
      id: map['id'],
      quantity: map['quantity'],
      description: map['description'],
      unitPrice: map['unitPrice'].toDouble(),
    );
  }

  // Copiar con cambios
  BudgetItem copyWith({
    int? quantity,
    String? description,
    double? unitPrice,
  }) {
    return BudgetItem(
      id: id,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BudgetItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'description': description,
      'unitPrice': unitPrice,
    };
  }

  factory BudgetItem.fromJson(Map<String, dynamic> json) {
    return BudgetItem(
      id: json['id']?.toString(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      description: json['description']?.toString() ?? '',
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

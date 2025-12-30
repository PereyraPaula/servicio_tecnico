import 'package:servicio_tecnico/classes/BudgetItem.dart';
import 'package:servicio_tecnico/classes/Budget.dart';

final List<BudgetItem> mockItems = [
  BudgetItem(
    quantity: 1,
    description: 'Pantalla completa iPhone 13',
    unitPrice: 189.90,
  ),
  BudgetItem(
    quantity: 1,
    description: 'Batería original Samsung S22',
    unitPrice: 79.50,
  ),
  BudgetItem(
    quantity: 1,
    description: 'Módulo de cámara trasera Xiaomi Redmi Note 11',
    unitPrice: 45.30,
  ),
  BudgetItem(
    quantity: 1,
    description: 'Conector de carga USB-C',
    unitPrice: 29.90,
  ),
  BudgetItem(
    quantity: 1,
    description: 'Vidrio templado protección',
    unitPrice: 12.50,
  ),
  BudgetItem(
    quantity: 1,
    description: 'Mano de obra desmontaje/ensamblaje',
    unitPrice: 35.00,
  ),
  BudgetItem(
    quantity: 1,
    description: 'Micrófono inferior Huawei P30',
    unitPrice: 18.75,
  ),
  BudgetItem(
    quantity: 1,
    description: 'Flex botón volumen/power',
    unitPrice: 22.40,
  ),
  BudgetItem(
    quantity: 1,
    description: 'Diagnóstico completo dispositivo',
    unitPrice: 15.00,
  ),
  BudgetItem(
    quantity: 2,
    description: 'Cinta adhesiva doble cara especial',
    unitPrice: 3.25,
  ),
];

final List<Budget> mockBudgets = [
  Budget(
    clientName: 'María González López',
    contactNumber: '+34 612 345 678',
    creationDate: '2024-01-15T10:30:00Z',
    items: [
      mockItems[0].copyWith(id: 'item_001'),
      mockItems[5].copyWith(id: 'item_002'),
      mockItems[9].copyWith(id: 'item_003', quantity: 3),
    ],
  ),
  Budget(
    clientName: 'Carlos Rodríguez Martín',
    contactNumber: '655 987 654',
    creationDate: '2024-01-10T14:15:00Z',
    items: [
      mockItems[1].copyWith(id: 'item_004'),
      mockItems[3].copyWith(id: 'item_005'),
      mockItems[5].copyWith(id: 'item_006'),
      mockItems[8].copyWith(id: 'item_007'),
    ],
  ),
  Budget(
    clientName: 'TechSolutions S.L.',
    contactNumber: '931 234 567',
    creationDate: '2024-01-05T09:00:00Z',
    items: [
      mockItems[2].copyWith(id: 'item_008'),
      mockItems[4].copyWith(id: 'item_009'),
      mockItems[5].copyWith(id: 'item_010'),
    ],
  ),
  Budget(
    clientName: 'Ana Fernández Ruiz',
    contactNumber: '+34 600 112 233',
    creationDate: '2024-01-20T16:45:00Z',
    items: [
      mockItems[6].copyWith(id: 'item_011'),
      mockItems[7].copyWith(id: 'item_012'),
      mockItems[5].copyWith(id: 'item_013'),
      mockItems[8].copyWith(id: 'item_014'),
      mockItems[9].copyWith(id: 'item_015'),
    ],
  ),
  Budget(
    clientName: 'Nuevo Cliente',
    contactNumber: '',
    items: [],
  ),
];

Budget getBudgetById(String id) {
  return mockBudgets.firstWhere((budget) => budget.id == id);
}

List<Map<String, dynamic>> getAllBudgetsAsJson() {
  return mockBudgets.map((budget) => budget.toJson()).toList();
}

Budget getBudgetWithManyItems() {
  return Budget(
    clientName: 'Reparación Completa Premium',
    contactNumber: '666 777 888',
    creationDate: '2024-01-25T11:20:00Z',
    items: [
      mockItems[0].copyWith(
          id: 'item_101',
          description: 'Pantalla OLED iPhone 14 Pro Max',
          unitPrice: 289.90),
      mockItems[1].copyWith(
          id: 'item_102',
          description: 'Batería máxima capacidad',
          unitPrice: 99.50),
      mockItems[2].copyWith(id: 'item_103'),
      mockItems[3].copyWith(id: 'item_104'),
      mockItems[4].copyWith(
          id: 'item_105',
          description: 'Vidrio templado premium',
          unitPrice: 19.90),
      mockItems[5].copyWith(
          id: 'item_106',
          description: 'Mano de obra especializada',
          unitPrice: 50.00),
      mockItems[6].copyWith(id: 'item_107'),
      mockItems[7].copyWith(id: 'item_108'),
      mockItems[8].copyWith(id: 'item_109'),
      mockItems[9].copyWith(
          id: 'item_110',
          description: 'Kit adhesivos premium',
          unitPrice: 8.50),
      BudgetItem(
        id: 'item_111',
        quantity: 1,
        description: 'Limpieza interna profunda',
        unitPrice: 25.00,
      ),
      BudgetItem(
        id: 'item_112',
        quantity: 1,
        description: 'Garantía extendida 6 meses',
        unitPrice: 35.00,
      ),
    ],
  );
}

List<Map<String, dynamic>> getBudgetListForScreenshots() {
  return [
    mockBudgets[0].toViewBudgetMap(),
    mockBudgets[1].toViewBudgetMap(),
    mockBudgets[2].toViewBudgetMap(),
    mockBudgets[3].toViewBudgetMap(),
  ];
}

Map<String, dynamic> getDetailedBudgetForScreenshot() {
  return mockBudgets[0].toJson();
}

Budget getBudgetForEditing() {
  return mockBudgets[1].copyWith();
}

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:servicio_tecnico/classes/Budget.dart';
import 'package:servicio_tecnico/utils/generics.dart';

class CardItem extends StatelessWidget {
  final Budget budget;
  final VoidCallback onShare;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const CardItem({
    super.key,
    required this.budget,
    required this.onShare,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.fromLTRB(4, 10, 4, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 212, 212, 212),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    budget.clientName,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.attach_money,
                        size: 24,
                        color: Color(0xFF414040),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        budget.total.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    formatDate(DateTime.parse(budget.creationDate)),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${budget.items.length} items',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(FontAwesome.whatsapp, color: Colors.green)),
                  onTap: () => openWhatsApp(budget.contactNumber),
                ),
                IconButton(
                  onPressed: onShare,
                  icon: const Icon(Icons.share),
                  color: Colors.grey[700],
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.close),
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

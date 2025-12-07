import 'package:flutter/material.dart';

class ViewBudget extends StatelessWidget {
  const ViewBudget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      color: const Color(0xFFF1F3F4),
      child: const SafeArea(
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Text(
                  "Presupuesto",
                  style: TextStyle(fontSize: 28),
                ),
              ))),
    );
  }
}

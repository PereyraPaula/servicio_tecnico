import 'package:flutter/material.dart';

class ModalShare extends StatelessWidget {
  const ModalShare({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(23, 18, 23, 18),
      child: SizedBox(
        height: 120,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Compartir",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Icon(
                  Icons.close,
                  color: Colors.black,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: null,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor:
                          const Color.fromARGB(255, 226, 226, 226)!,
                      child: const ClipOval(
                        child: Icon(
                          Icons.image,
                          color: Colors.black,
                          size: 23,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: null,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor:
                          const Color.fromARGB(255, 226, 226, 226)!,
                      child: const ClipOval(
                        child: Icon(
                          Icons.picture_as_pdf_outlined,
                          color: Colors.black,
                          size: 23,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

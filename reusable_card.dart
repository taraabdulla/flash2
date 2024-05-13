import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  const ReusableCard({super.key, this.text, this.child});
  final String? text;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 7,
        shadowColor: Colors.grey,
        child: child ??
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(text!,
                    style: const TextStyle(fontSize: 20, letterSpacing: 1.0),
                    textAlign: TextAlign.center),
              ),
            ),
      ),
    );
  }
}

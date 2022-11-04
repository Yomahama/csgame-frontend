import 'package:flutter/material.dart';

class CustomCursor extends StatefulWidget {
  const CustomCursor({super.key});

  @override
  State<CustomCursor> createState() => _CustomCursorState();
}

class _CustomCursorState extends State<CustomCursor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 24,
            width: 2,
            color: Colors.grey,
          ),
          Container(
            height: 2,
            width: 24,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

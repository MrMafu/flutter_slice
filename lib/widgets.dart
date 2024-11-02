import 'package:flutter/material.dart';

Widget topButton(IconData icon, VoidCallback navigate) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
        ),
      ],
    ),
    child: IconButton(
      icon: Icon(icon),
      onPressed: navigate,
    ),
  );
}
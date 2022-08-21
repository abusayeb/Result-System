import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final textInputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.blueAccent, width: 3),
    borderRadius: BorderRadius.circular(10),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.orange, width: 2),
    borderRadius: BorderRadius.circular(10),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.red, width: 2),
    borderRadius: BorderRadius.circular(10),
  ),
);

space(double height) {
  return SizedBox(
    height: height,
  );
}

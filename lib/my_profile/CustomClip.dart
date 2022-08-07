import 'package:flutter/material.dart';

class CustomClipPath extends CustomClipper<Path> {
  var radius=10.0;
@override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);

    path.quadraticBezierTo(size.width/5, size.height
 , size.width/2.25, size.height-50);

    path.quadraticBezierTo(size.width-(size.width/3.24), size.height-105,
 size.width, size.height-10);

    path.lineTo(size.width, 0);

    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
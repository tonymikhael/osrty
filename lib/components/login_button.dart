import 'package:flutter/material.dart';
import 'package:osrty/constants.dart';

class CustomizedButton extends StatelessWidget {
  final String hintText;
  final double? width;
  final Color? color;
  final void Function()? onPressed;
  const CustomizedButton({
    required this.hintText,
    required this.onPressed,
    this.width = 380,
    this.color = Colors.deepPurple,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.white,
        fixedSize: Size(width!, 54),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: color,
      ),
      onPressed: onPressed,
      child: Text("$hintText"),
    );
  }
}

import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final bool loading;
  final void Function() onPressed;

  const Button(
      {super.key,
      this.loading = false,
      required this.title,
      required this.onPressed,
      this.width = 210,
      this.height = 40});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Colors.white,
                  width: 0,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50) //こちらを適用
                    ),
                backgroundColor: Colors.white),
            onPressed: onPressed,
            child: loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Color(0xFFC39669),
                    ),
                  )
                : Text(title,
                    style: const TextStyle(
                        color: Color(0xFFC39669),
                        fontSize: 20,
                        fontWeight: FontWeight.bold))));
  }
}

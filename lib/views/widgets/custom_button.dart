import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CurvedElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double borderRadius;
  final double padding;

  const CurvedElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.borderRadius = 10.0,
    this.padding = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              text == 'Capture Face' ? Colors.white : Colors.indigo,
          // backgroundColor: color ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(color: Colors.indigo, width: 2),
          ),
          padding: EdgeInsets.symmetric(vertical: padding, horizontal: 24),
          elevation: 5,
        ),
        child: Text(text,
            style: text == 'Capture Face'
                ? GoogleFonts.metrophobic(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.indigo,
                    height: 1.56,
                    decoration: TextDecoration.none,
                  )
                : GoogleFonts.metrophobic(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    height: 1.56,
                    decoration: TextDecoration.none,
                  )),
      ),
    );
  }
}

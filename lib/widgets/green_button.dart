import 'package:flutter/material.dart';
import '../utils/color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

class GreenButton extends StatelessWidget {
  const GreenButton({
    this.text,
    this.onPressed,
    this.icon,
  });
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: ElevatedButton(
        onPressed: onPressed,
        style: _createCheckoutButtonStyle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: BODY3,
            ),
            if (text.isNotEmpty) const SizedBox(width: 10),
            if (text.isNotEmpty)
              Text(
                text,
                style: GoogleFonts.barlow(
                    color: BODY3, fontSize: 21, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _createCheckoutButtonStyle() => ElevatedButton.styleFrom(
        primary: SECOND1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
      );
}

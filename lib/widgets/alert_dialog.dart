import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertDialogWidget extends StatelessWidget {
  final String headingText;
  final String contentText;
  final VoidCallback confirmFunction;
  final VoidCallback declineFunction;

  const AlertDialogWidget({
    super.key,
    required this.headingText,
    required this.contentText,
    required this.confirmFunction,
    required this.declineFunction,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        headingText,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
            textStyle: Theme.of(context).textTheme.bodyLarge,
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
      content: Text(
        contentText,
        style: GoogleFonts.poppins(
          textStyle: Theme.of(context).textTheme.bodyMedium,
          fontSize: 15,
        ),
      ),
      actions: [
        TextButton(
          onPressed: declineFunction,
          child: Text(
            "No",
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.bodySmall,
              color: Colors.red.shade300,
              fontSize: 13,
            ),
          ),
        ),
        TextButton(
          onPressed: confirmFunction,
          child: Text(
            "Yes",
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.bodySmall,
              color: Colors.green.shade300,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

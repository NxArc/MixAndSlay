import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/saved_icon.png',
            height: 80,
            width: 80,
          ),
          const SizedBox(height: 12),
          const Text(
            'Saved Successfully!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back one page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF383737),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FailureDialog extends StatelessWidget {
  final String errorMessage;

  const FailureDialog({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/error_icon.png',
            height: 80,
            width: 80,
          ),
          const SizedBox(height: 12),
          const Text(
            'Failed to Save',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
Future<void> showSuccessDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => const SuccessDialog(),
  );
}

Future<void> showFailureDialog(BuildContext context, String errorMessage) {
  return showDialog(
    context: context,
    builder: (context) => FailureDialog(errorMessage: errorMessage),
  );
}
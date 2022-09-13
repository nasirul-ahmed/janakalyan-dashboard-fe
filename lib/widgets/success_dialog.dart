import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final String others;
  const SuccessDialog(
      {Key? key,
      required this.onPressed,
      required this.title,
      required this.others})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: AlertDialog(
        title: Text(title),
        content: Text(others),
        actions: [
          MaterialButton(
            onPressed: onPressed,
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
}

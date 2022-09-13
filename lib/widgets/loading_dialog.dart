import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: Dialog(
        child: Container(
            height: 100,
            width: 100,
            child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}

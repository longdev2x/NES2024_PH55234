import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast {
  static void showToast(String? msg, {Toast? length = Toast.LENGTH_SHORT, }) {
    Fluttertoast.showToast(
      msg: msg ?? "",
      toastLength: length,
      gravity: ToastGravity.TOP
    );
  }
}

class AppConfirm extends StatelessWidget {
  final String title;
  final Function()? onNoConfirm;
  final Function() onConfirm;
  const AppConfirm({super.key, required this.title,required this.onConfirm, this.onNoConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actions: [
        ElevatedButton(
            onPressed: onNoConfirm ?? () {
              Navigator.pop(context);
            },
            child: const Text("Huỷ")),
        ElevatedButton(onPressed: onConfirm, child: const Text("Okay"))
      ],
    );
  }
}
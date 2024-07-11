import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryHoriItem extends StatelessWidget {
  final String name;
  final bool isChose;
  final Function() onPressed;
  const CategoryHoriItem({
    super.key,
    required this.onPressed,
    required this.name,
    required this.isChose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            textStyle: isChose
                ? const MaterialStatePropertyAll(TextStyle(color: Colors.white))
                : const MaterialStatePropertyAll(
                    TextStyle(color: Colors.black),
                  ),
            backgroundColor:
                isChose ? const MaterialStatePropertyAll(Colors.black) : null,
            foregroundColor:
                isChose ? const MaterialStatePropertyAll(Colors.white) : null,
          ),
          child: Text(name),
        ),
        SizedBox(
          width: 10.w,
        )
      ],
    );
  }
}

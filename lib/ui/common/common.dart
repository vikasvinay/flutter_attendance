import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonWidget{
  Widget textField(
      {required TextEditingController controller,
      required IconData icon,
      required String hintText,
      required String validator,
      required String errorText,
      Key? key
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(icon),
        Container(
          width: 0.7.sw,
          // height: 0.1.sh,
          child: TextFormField(
            key: key,
            validator: (val) {
              return RegExp(validator).hasMatch(val!) ? null : errorText;
            },
            controller: controller,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.r)),
                ),
                hintText: hintText),
          ),
        ),
      ],
    );
  }
}
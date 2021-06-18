import 'dart:io';

import 'package:attendance_app/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class CommonWidget {
  File? _image;
  final picker = ImagePicker();
  AuthRepository _authRepository = AuthRepository();
  Widget textField(
      {required TextEditingController controller,
      required IconData icon,
      required String hintText,
      required String validator,
      required String errorText,
      Key? key}) {
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

  commonToast(String text, {Color? color}) async {
    return Fluttertoast.showToast(
        msg: text,
        backgroundColor: color ?? Colors.blue,
        fontSize: 18,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG);
  }

  Future imagePicker({required String uid}) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await _authRepository.sendImageToFirestore(
          uid: uid, imageFile: File(pickedFile.path));
      return _image;
    } else {
      print('No image selected.');
      return null;
    }
  }
}

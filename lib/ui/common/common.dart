import 'dart:io';

import 'package:attendance_app/repository/auth_repository.dart';
import 'package:attendance_app/routing/fluro_route.dart';
import 'package:attendance_app/routing/page_name.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import './global.dart' as global;

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
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.all(Radius.circular(20.r)),
                // ),
                hintText: hintText),
          ),
        ),
      ],
    );
  }

  commonToast(String text, {Color? color}) {
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

  Widget bottomNavBar(
      {required BuildContext context,
      required int pageIndex,
      int? totalAbsent,
      int? totalPresent,
      String? uid}) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      enableFeedback: true,
      currentIndex: pageIndex,
      selectedItemColor: Colors.amber[800],
      items: [
        BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.book,
            size: 50.r,
          ),
          icon: Icon(Icons.book),
          label: 'Attendance',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.home, size: 50.r),
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.person,
            size: 50.r,
          ),
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      onTap: (index) {
        if (index != pageIndex) {
          if (index == 0) {
            FluroRouting.fluroRouter.navigateTo(context, PageName.history,
                replace: true,
                clearStack: true,
                transition: TransitionType.fadeIn,
                routeSettings: RouteSettings(arguments: [
                  global.uid,
                  global.totalAbsent,
                  global.totalPresent
                ]));
          } else if (index == 2) {
            FluroRouting.fluroRouter.navigateTo(
              context,
              PageName.settings,
              transition: TransitionType.fadeIn,
              replace: true,
              clearStack: true,
            );
          } else {
            FluroRouting.fluroRouter.navigateTo(
              context,
              PageName.studentHome,
              transition: TransitionType.fadeIn,
              replace: true,
              clearStack: true,
            );
          }
        }
      },
    );
  }
}

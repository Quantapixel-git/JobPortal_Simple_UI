import 'package:flutter/material.dart';
import 'package:get/get.dart';

void mySnackBar() {
  Get.snackbar('this is snack', 'i like it',
      // titleText: Text(""),
      // messageText: Text(""),
      duration: Duration(seconds: 10),
      borderRadius: 40,
      icon: Icon(
        Icons.notifications,
        size: 30,
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      margin: EdgeInsets.all(10),
      dismissDirection: DismissDirection.horizontal,
      isDismissible: false,
      mainButton: TextButton(onPressed: () {}, child: Text("button")),
      animationDuration: Duration(milliseconds: 500),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black,
      colorText: Colors.white);
}

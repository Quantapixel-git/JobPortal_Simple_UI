import 'package:flutter/material.dart';
import 'package:get/get.dart';

void myDialogBox() {
  Get.defaultDialog(
    title: "hi",
    // middleText: "hello",
    content: Column(
      children: [Text("hi2"), Text("hi3"),Row(children: [Expanded(child: TextFormField())],)],
    ),
    radius: 0,
    titlePadding: EdgeInsets.all(20),
    contentPadding: EdgeInsets.all(20),
    actions: [
      OutlinedButton(
        onPressed: () {
          Get.back();
        },
        child: Text("cancle"),
      ),
      ElevatedButton(
          onPressed: () {
            print("ok");
            Get.back();
          },
          child: Text("ok"))
    ],
    backgroundColor: Colors.white,
    // onCancel: () {},
    // onConfirm: () {},
  );
}

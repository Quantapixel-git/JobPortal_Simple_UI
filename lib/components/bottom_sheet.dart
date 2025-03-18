import 'package:flutter/material.dart';
import 'package:get/get.dart';

void myBottomSheet() {
  Get.bottomSheet(Container(
    height: 200,
    width: double.infinity,
    padding: EdgeInsets.all(30),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10))),
    child: Column(
      children: [
        Container(
          width: 300,
          height: 10,
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        ),
        SizedBox(
          height: 10,
        ),
        Text("this is bottom sheet"),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("cancle")),
            ElevatedButton(onPressed: () {}, child: Text("ok"))
          ],
        )
      ],
    ),
  ));
}

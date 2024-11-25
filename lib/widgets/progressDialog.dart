import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProgressDialog extends StatelessWidget {
  String message;
  ProgressDialog({required this.message});
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.yellow,
        child: Container(
            margin: EdgeInsets.all(15.0),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(6.0)),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 6.0),
                  const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
                  SizedBox(width: 26.0),
                  Text(message,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 10.0))
                ],
              ),
            )));
  }
}

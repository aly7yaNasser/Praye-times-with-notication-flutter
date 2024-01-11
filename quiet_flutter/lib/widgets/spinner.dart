import 'package:flutter/material.dart';

class SpinnerWidget extends StatelessWidget{
  final String message;
   SpinnerWidget({required this.message});
  @override
  Widget build(BuildContext context) {

      return  Column(
          children:[
            SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(
                color: Colors.deepOrange,
                strokeWidth: 10,
                strokeCap: StrokeCap.square,
              ),
            ),
            Text(message)
          ],
      );
    }
  }
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils{
static focusChange(BuildContext context,FocusNode current,FocusNode next){
 current.unfocus();
 FocusScope.of(context).requestFocus(next);
}
static flushBarMessage(String message,BuildContext context){
 showFlushbar(
     context: context,
     flushbar: Flushbar(

      message: message,
      title: 'Message',
      backgroundColor: Colors.red,
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      duration: Duration(seconds: 3),
      icon: Icon(Icons.error,color: Colors.white,),
      borderRadius: BorderRadius.circular(20),
      flushbarPosition: FlushbarPosition.BOTTOM,
      forwardAnimationCurve: Curves.bounceIn,
      reverseAnimationCurve: Curves.bounceInOut,
      margin: EdgeInsets.symmetric(vertical: 10),

     )..show(context)
 );

}
}
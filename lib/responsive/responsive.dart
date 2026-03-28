import 'package:flutter/material.dart';

class Responsive {

  static bool isMObaile(BuildContext context){
    return MediaQuery.of(context).size.width <=600;

  }
  static double widthOfScreen(BuildContext context){
    return MediaQuery.of(context).size.width;
  }
   static double hieghtOfScreen(BuildContext context){
    return MediaQuery.of(context).size.height;
  }
}
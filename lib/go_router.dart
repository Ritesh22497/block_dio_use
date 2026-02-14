import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NavigationHelper{


  static void push(BuildContext context ,Widget screen){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>screen));
  }
   static void pushNamed(BuildContext context ,String routeName,{Object? argument}){
    Navigator.pushNamed(context,routeName,arguments: argument);
  }

    static void pushReplacement(BuildContext context ,Widget screen){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>screen));
  }
   static void pop(BuildContext context ,Widget screen){
    Navigator.pop(context, MaterialPageRoute(builder: (context)=>screen));
  }
   static void pushAndRemoveUntil(BuildContext context ,Widget screen){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>screen),(Route)=>false);
  }
}
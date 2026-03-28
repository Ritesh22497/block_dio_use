import 'package:block_dio_use/responsive/responsive.dart';
import 'package:block_dio_use/utils/colors.dart';
import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return  Wrap(children: [
          SizedBox(
            width: Responsive.isMObaile(context)?Responsive.widthOfScreen(context):Responsive.widthOfScreen(context)/2,
            height: Responsive.isMObaile(context)?Responsive.hieghtOfScreen(context)/3:Responsive.hieghtOfScreen (context)-70,
            child: Image.asset("assets/images/profile ritesh2.png",fit: BoxFit.fill,),
          ),SizedBox(
            width: Responsive.isMObaile(context)?Responsive.widthOfScreen(context):Responsive.widthOfScreen(context)/2,
            height: Responsive.isMObaile(context)?Responsive.hieghtOfScreen(context)/3:Responsive.hieghtOfScreen (context)-70,
            child: Center(child: SizedBox(width:Responsive.isMObaile(context)? Responsive.widthOfScreen(context)*.85:450 ,height: 240,
            child: DecoratedBox(decoration: BoxDecoration(boxShadow:[BoxShadow(blurRadius: 8)],borderRadius: BorderRadius.circular(8.0) ,color: whiteBGColor),child:Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("hello"),
                  Text("i am ritesh sharma \n a fluter developer & content Creator\n total expriencie 3 year  ")
                  ],),
            ) ,),
            ),)
          )
        ],);
  }
}
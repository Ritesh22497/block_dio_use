import 'package:block_dio_use/responsive/responsive.dart';
import 'package:block_dio_use/utils/colors.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final ScrollController scrollController;
  const TopBar({required this.scrollController, super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobaile=Responsive.isMObaile(context);
    return isMobaile?Column(children:topBarData(scrollController,context,ismobaile: true),):Row(children: topBarData(scrollController, context),);
  }
  List <Widget> topBarData(ScrollController scrollController ,BuildContext context,{bool ismobaile=false}){
    int scrollDuration=ismobaile?800:500;
return [
  Padding(
    padding:  EdgeInsets.symmetric(horizontal:10.0,vertical: ismobaile?20:0),
    child: TextButton(onPressed: (){}, child: Text("About",style: TextStyle(fontSize: 20,color:darkColor1,fontWeight: FontWeight.w900 ),)),
  ), Padding(
    padding:  EdgeInsets.symmetric(horizontal:10.0,vertical: ismobaile?20:0),
    child: TextButton(onPressed: (){}, child: Text("Skills",style: TextStyle(fontSize: 20,color:darkColor1,fontWeight: FontWeight.w900 ),)),
  ), Padding(
    padding:  EdgeInsets.symmetric(horizontal:10.0,vertical: ismobaile?20:0),
    child: TextButton(onPressed: (){}, child: Text("Project",style: TextStyle(fontSize: 20,color:darkColor1,fontWeight: FontWeight.w900 ),)),
  ),Padding(
    padding:  EdgeInsets.symmetric(horizontal:10.0,vertical: ismobaile?20:0),
    child: TextButton(onPressed: (){}, child: Text("Contact",style: TextStyle(fontSize: 20,color:darkColor1,fontWeight: FontWeight.w900 ),)),
  )
];


  }
}
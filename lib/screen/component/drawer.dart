import 'package:block_dio_use/screen/component/topbar.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
 final ScrollController scrollController; 
  const MyDrawer( {super.key,required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close)),),
      body: Center(child: TopBar(scrollController: scrollController),),);
  }
}
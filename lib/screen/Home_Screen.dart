import 'package:block_dio_use/responsive/responsive.dart';
import 'package:block_dio_use/screen/component/drawer.dart';
import 'package:block_dio_use/screen/component/profile_info.dart';
import 'package:block_dio_use/screen/component/topbar.dart';
import 'package:block_dio_use/utils/colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 final ScrollController _scrollController=ScrollController();
  final GlobalKey<ScaffoldState> _globalKey= GlobalKey<ScaffoldState>(  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text("Ritesh Sharma",style: TextStyle(fontSize: 24,color: darkColor,fontWeight: FontWeight.w900),),
      
      backgroundColor: whiteBGColor,
      elevation: 3,
      toolbarHeight: 70,
      actions: [
        Responsive.isMObaile(context)?
        
        
        
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(onPressed: (){_globalKey.currentState! .openEndDrawer();}, icon: Icon(Icons.menu)),
        ):TopBar(scrollController: _scrollController,)],
      ),
 endDrawer: Responsive.isMObaile(context)?MyDrawer( scrollController: _scrollController,):null,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(children: [
               ProfileInfo()
              ],),
            ),
          ],
        ),
      ),
     
      
    );
  }
}
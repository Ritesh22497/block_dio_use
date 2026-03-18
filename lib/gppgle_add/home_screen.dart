import 'package:block_dio_use/gppgle_add/helperadd.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeScreenAdd extends StatefulWidget {
  const HomeScreenAdd({super.key});

  @override
  State<HomeScreenAdd> createState() => _HomeScreenAddState();
}

class _HomeScreenAddState extends State<HomeScreenAdd> {
  BannerAd? _bannerAd;
@override
  void initState() {
   _loadBannerAd();
    super.initState();
  }
  void _loadBannerAd(){
    BannerAd(
      size: AdSize.banner,
      adUnitId: AdHleper.bannerAdUnitId,
      listener: BannerAdListener(
    onAdLoaded: (ad) {
      setState(() {
       _bannerAd=ad as BannerAd;
     });
    },
    onAdFailedToLoad: (ad, error) {
    print("feild to load ad${error.message}");
    ad.dispose();
    },
    ),request: AdRequest()
    ).load();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("add screen") ,),
      body: Center(child: Stack(children: [
        SizedBox(
width: _bannerAd!.size.width.toDouble(),
height: _bannerAd!.size.height.toDouble(),
child: AdWidget(ad: _bannerAd!),
        )
      ],),),
    );
  }
}
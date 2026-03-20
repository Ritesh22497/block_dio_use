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
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  
  // Best practice: track each ad's status separately
  bool _isBannerLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _loadinterstitialAd();
    _loadRewardedAd();
  }

  @override
  void dispose() {
    // ALWAYS dispose every ad you initialize
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAd,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null; // Reset to null after use
              _loadRewardedAd(); // Preload the next one
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _rewardedAd = null;
              _loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) => debugPrint("Rewarded failed: $error"),
      ),
    );
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _isBannerLoaded = true),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint("Banner failed: $error");
        },
      ),
    )..load();
  }

  void _loadinterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _loadinterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) => debugPrint("Interstitial failed: $error"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ad Screen")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isBannerLoaded && _bannerAd != null)
              SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () {
                // SAFETY CHECK: Only show if ad is not null
                if (_rewardedAd != null) {
                  _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
                    print("User earned: ${reward.amount} ${reward.type}");
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Ad still loading..."))
                  );
                }
              },
              child: const Text("Show Rewarded Ad"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // SAFETY CHECK
          if (_interstitialAd != null) {
            _interstitialAd!.show();
          } else {
            print("Interstitial not ready yet");
          }
        },
        child: const Icon(Icons.ads_click),
      ),
    );
  }
}

// // class _HomeScreenAddState extends State<HomeScreenAdd> {
//   BannerAd? _bannerAd;
//   InterstitialAd? _interstitialAd;
//   RewardedAd? _rewardedAd;
//   bool _isAdLoaded = false; // Track loading state explicitly

//   @override
//   void initState() {
//     super.initState();
//     _loadBannerAd();
//     _loadinterstitialAd();
// _loadRewardedAd();
//   }

//   @override
//   void dispose() {
//     _bannerAd?.dispose(); // Clean up memory
//     super.dispose();
//   }
// void _loadRewardedAd() {
//      RewardedAd.load(
     
//       adUnitId: AdHelper.rewardedAd, // Corrected class name
//       request: const AdRequest(),
//       rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
//           setState(() {
//             _isAdLoaded = true;
//           });
//                       _rewardedAd = ad;
//                       ad.fullScreenContentCallback=FullScreenContentCallback(
//                         onAdDismissedFullScreenContent: (ad){
//                           ad.dispose();
//                           _loadRewardedAd();
//                         },
//                         onAdFailedToShowFullScreenContent: (ad,error){
//                           ad.dispose();
//                           _loadRewardedAd();
//                         }
//                       );
//         },
//          onAdFailedToLoad: (LoadAdError error) {
//           debugPrint("Failed to load ad: ${error.message}");

//         },
        
//         ),
        
   
//     ); // Use cascade operator to call load()
//   }

//   void _loadBannerAd() {
//     _bannerAd = BannerAd(
//       size: AdSize.banner,
//       adUnitId: AdHelper.bannerAdUnitId, // Corrected class name
//       request: const AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           setState(() {
//             _isAdLoaded = true;
//           });
//         },
//         onAdFailedToLoad: (ad, error) {
//           print("Failed to load ad: ${error.message}");
//           ad.dispose();
//         },
//       ),
//     )..load(); // Use cascade operator to call load()
//   }


// void _loadinterstitialAd() {
//      InterstitialAd.load(
     
//       adUnitId: AdHelper.interstitialId, // Corrected class name
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
//           setState(() {
//             _isAdLoaded = true;
//           });
//                       _interstitialAd = ad;
//                       ad.fullScreenContentCallback=FullScreenContentCallback(
//                         onAdDismissedFullScreenContent: (ad){
//                           ad.dispose();
//                           _loadinterstitialAd();
//                         },
//                         onAdFailedToShowFullScreenContent: (ad,error){
//                           ad.dispose();
//                           _loadinterstitialAd();
//                         }
//                       );
//         },
//          onAdFailedToLoad: (LoadAdError error) {
//           debugPrint("Failed to load ad: ${error.message}");

//         },
        
//         ),
        
   
//     ); // Use cascade operator to call load()
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Ad Screen")),
//       body: Center(
//         child:Column(children: [
//                _isAdLoaded && _bannerAd != null
//             ? SizedBox(
//                 width: _bannerAd!.size.width.toDouble(),
//                 height: _bannerAd!.size.height.toDouble(),
//                 child: AdWidget(ad: _bannerAd!),
//               )
//             : const CircularProgressIndicator(),

//             ElevatedButton(onPressed: (){
//              _rewardedAd!.show(onUserEarnedReward: (ad,rewarde){
// print("user earned rewerd :${rewarde.amount}${rewarde.type} ");


//              });
//             }, child: Text("Rewarded Add button"))
//         ],)
        
        
//      // Show loader while waiting
//       ),
//       floatingActionButton: FloatingActionButton(onPressed: (){
//         _interstitialAd!.show();
//       },child: Icon(Icons.add),),
//     );
//   }
// }
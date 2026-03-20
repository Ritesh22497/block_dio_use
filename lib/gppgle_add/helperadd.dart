// import 'dart:io';

// // class AdHleper{
// //   static String get bannerAdUnitId{
// //     if(Platform.isAndroid)
// //     {return 'ca-app-pub-9718317153592810~4533723753';}
// //     else if  (Platform.isIOS){
// //       return "ca-app-pub-9718317153592810/9882253354";
// //     }else{
// //      throw UnsupportedError("Unsupport platform");
// //     }

// //   }
// // }


// class AdHelper { // Fixed typo from AdHleper
//   static String get bannerAdUnitId {
//     if (Platform.isAndroid) {
//       // IMPORTANT: This must be a Banner Unit ID, not an App ID
//       // Use this test ID for now to verify it works:
//       return 'ca-app-pub-3940256099942544/6300978111'; 
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-3940256099942544/2934735716'; // Test ID for iOS
//     } else {
//       throw UnsupportedError("Unsupported platform");
//     }
//   }
//     static String get interstitialId {
//     if (Platform.isAndroid) {
//       // IMPORTANT: This must be a Banner Unit ID, not an App ID
//       // Use this test ID for now to verify it works:
//       return 'ca-app-pub-9718317153592810/1620528066'; 
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-9718317153592810/1620528066'; // Test ID for iOS
//     } else {
//       throw UnsupportedError("Unsupported platform");
//     }
//   }
//       static String get rewardedAd {
//     if (Platform.isAndroid) {
//       // IMPORTANT: This must be a Banner Unit ID, not an App ID
//       // Use this test ID for now to verify it works:
//       return 'ca-app-pub-9718317153592810/5795443342'; 
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-9718317153592810/1620528066'; // Test ID for iOS
//     } else {
//       throw UnsupportedError("Unsupported platform");
//     }
//   }
// }
import 'dart:io';

class AdHelper {
  // Your App ID: ca-app-pub-9718317153592810~4533723753

  // 1. Banner Ad Unit ID
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      // Replace with your iOS Banner ID when ready
      return 'ca-app-pub-3940256099942544/2934735716'; 
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  // 2. Interstitial Ad Unit ID
  static String get interstitialId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9718317153592810/1620528066';
    } else if (Platform.isIOS) {
      // Replace with your iOS Interstitial ID when ready
      return 'ca-app-pub-3940256099942544/4411468910';
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  // 3. Rewarded Ad Unit ID
  static String get rewardedAd {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9718317153592810/5795443342';
    } else if (Platform.isIOS) {
      // Replace with your iOS Rewarded ID when ready
      return 'ca-app-pub-3940256099942544/1712485313';
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
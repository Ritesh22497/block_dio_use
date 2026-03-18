import 'dart:io';

class AdHleper{
  static String get bannerAdUnitId{
    if(Platform.isAndroid)
    {return "ca-app-pub-9718317153592810~4533723753";}
    else if  (Platform.isIOS){
      return "ca-app-pub-9718317153592810/9882253354";
    }else{
     throw UnsupportedError("Unsupport platform");
    }

  }
}
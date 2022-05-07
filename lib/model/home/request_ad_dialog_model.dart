import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class RewordRequestAdsModel extends ChangeNotifier{
    int? adCount;
    bool? adState;

    RewardedAd? _rewardedAd;

    void init() async {
      this.adCount = 0;
      adState = true;
      notifyListeners();
    }

    void changeState() async{
      adState = adState==true ? false : true;
      notifyListeners();
    }

    void loadRewardedAd() async {
      changeState();
      RewardedAd.load(
        adUnitId: Platform.isIOS ? "ca-app-pub-3940256099942544/1712485313" : "	ca-app-pub-3940256099942544/5224354917",
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            this._rewardedAd = ad;
            changeState();
            showRewardedAd();
            notifyListeners();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            this._rewardedAd = null;
            changeState();
            notifyListeners();
          }),
      );
    }

    void showRewardedAd() {
      if(_rewardedAd != null){
        _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent : (RewardedAd ad) {
            print("Ad onAdShowedFullScreenContent");
          },
          onAdDismissedFullScreenContent : (RewardedAd ad) {
            ad.dispose();
          },
          onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error){
            ad.dispose();
          },
        );
        
        _rewardedAd!.setImmersiveMode(true);
        _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print("${reward.amount} ${reward.type}");
          incrementRewordNum();
        });
      }
    }

    void disposeAds() async{
      _rewardedAd?.dispose();
      notifyListeners();
    }

    void incrementRewordNum() async{
      adCount = adCount! + 1;
      notifyListeners();
    }
}


import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:norm_request/model/home/home_model.dart';

class RewordVoteAdsModel extends ChangeNotifier{
  final bool _voteState;
  final int _voteNum;
  RewordVoteAdsModel(this._voteState, this._voteNum);

  bool? adState;
  bool? voteState;
  int? voteNum;
  RewardedAd? _rewardedAd;

  void init() async {
    adState = true;
    voteState = _voteState;
    voteNum = _voteNum;
    notifyListeners();
  }

  void incrementVoteNum(_voteState) async{
    voteNum = _voteState ? voteNum!+1 : voteNum!-1;
    notifyListeners();
  }

  void changeVoteState() async{
    voteState = voteState==true ? false : true;
    notifyListeners();
  }

  void changeAdState() async{
    adState = adState==true ? false : true;
    notifyListeners();
  }

  void loadRewardedAd(String requestId) async {
    changeAdState();
    RewardedAd.load(
      adUnitId: Platform.isIOS ? "ca-app-pub-3940256099942544/1712485313" : "	ca-app-pub-3940256099942544/5224354917",
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            this._rewardedAd = ad;
            changeAdState();
            showRewardedAd(requestId);
            notifyListeners();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            this._rewardedAd = null;
            changeAdState();
            notifyListeners();
          }),
    );
  }

  void showRewardedAd(_requestId) {
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

        // ここに報酬後の内容を記入
        changeVoteState();
        RequestListModel().pushLikeIcon(_requestId, voteState, voteNum);
        incrementVoteNum(voteState);

      });
    }
  }

  void disposeAds() async{
    _rewardedAd?.dispose();
    notifyListeners();
  }

}
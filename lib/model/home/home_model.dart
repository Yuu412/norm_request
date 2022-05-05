import 'dart:ffi';

import'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class Request {
  Request(this.id, this.content, this.good, this.order, this.goodState);
  String id;
  String content;
  int good;
  int order;
  bool goodState;
}

class RequestListModel extends ChangeNotifier{
  List<Request>? requests;
  bool? goodState;

  void init() async {
    // ログインユーザーがいいねしたrequestのrequestIdのリスト作成
    final User? user = FirebaseAuth.instance.currentUser;
    final QuerySnapshot requestGoodsSnapshot =
    await FirebaseFirestore.instance.collection('requestGoods').where('userId', isEqualTo: user!.uid).get();

    //snapshot to List
    final List pushedList = requestGoodsSnapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      return data['requestId'];
    }).toList();

    // request一覧を作成
    final QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('requests').get();

    final List<Request> _requests = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String requestId = document.id;
      final String content = data['companyName'];
      final int good = data['good'];
      final bool goodState = pushedList.contains(requestId) ? true : false;
      return Request(requestId, content, good, 0, goodState);
    }).toList();

    _requests.sort((a,b) => -a.good.compareTo(b.good));

    int order = 0;
    _requests.forEach((e) {
      order++;
      e.order = order;
    });
    requests = _requests;

    notifyListeners();
  }

  void pushLikeIcon(requestId, _goodState, goodNum) async {
    // ログイン情報を取得
    final User? user = FirebaseAuth.instance.currentUser;

    // _goodStateがtrueのとき
    if(_goodState){
      await FirebaseFirestore.instance.collection("requestGoods").add({
        "requestId": requestId,
        "userId": user!.uid,
      });

      await FirebaseFirestore.instance.collection('requests').doc(requestId).update({
        'good': ++goodNum
      });
    } else {
      await FirebaseFirestore.instance.collection('requestGoods').where('userId', isEqualTo: user!.uid).where('requestId', isEqualTo: requestId)
          .get().then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          FirebaseFirestore.instance.collection('requestGoods').doc(doc.id).delete();
        });
      });

      await FirebaseFirestore.instance.collection('requests').doc(requestId).update({
        'good': --goodNum
      });
    }
    notifyListeners();
  }
}

class GoodStateModel extends ChangeNotifier{
  final bool _goodState;
  GoodStateModel(this._goodState);

  bool? goodState;
  void init() async {
    this.goodState = _goodState;
    notifyListeners();
  }

  void changeState(_state) async{
    goodState = !_state;
    notifyListeners();
  }
}

class RewordVoteAdsModel extends ChangeNotifier{
  final bool _goodState;
  final int _goodNum;
  RewordVoteAdsModel(this._goodState, this._goodNum);

  bool? adState;
  RewardedAd? _rewardedAd;

  //GoodStateModel
  bool? voteState;
  int? goodNum;

  void init() async {
    adState = true;
    voteState = _goodState;
    this.goodNum = _goodNum;
    notifyListeners();
  }

  void incrementGoodNum(_goodState) async{
    goodNum = _goodState ? goodNum!+1 : goodNum!-1;
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
    print('model   right now');
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
        RequestListModel().pushLikeIcon(_requestId, voteState, goodNum);
        incrementGoodNum(voteState);

      });
    }
  }

  void disposeAds() async{
    _rewardedAd?.dispose();
    notifyListeners();
  }

}


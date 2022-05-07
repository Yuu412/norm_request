import'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  void pushLikeIcon(requestId, _goodState, voteNum) async {
    // ログイン情報を取得
    final User? user = FirebaseAuth.instance.currentUser;

    // _goodStateがtrueのとき
    if(_goodState){
      await FirebaseFirestore.instance.collection("requestGoods").add({
        "requestId": requestId,
        "userId": user!.uid,
      });

      await FirebaseFirestore.instance.collection('requests').doc(requestId).update({
        'good': ++voteNum
      });
    } else {
      await FirebaseFirestore.instance.collection('requestGoods').where('userId', isEqualTo: user!.uid).where('requestId', isEqualTo: requestId)
          .get().then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          FirebaseFirestore.instance.collection('requestGoods').doc(doc.id).delete();
        });
      });

      await FirebaseFirestore.instance.collection('requests').doc(requestId).update({
        'good': --voteNum
      });
    }
    notifyListeners();
  }
}

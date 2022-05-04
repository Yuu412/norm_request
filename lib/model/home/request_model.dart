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

class GoodCountModel extends ChangeNotifier{
  final int _goodNum;
  GoodCountModel(this._goodNum);
  int? goodNum;

  void init() async {
    this.goodNum = _goodNum;
    notifyListeners();
  }

  void incrementGoodNum(_goodState) async{
    goodNum = _goodState ? goodNum!+1 : goodNum!-1;
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

class AddRequest extends ChangeNotifier{
  List<Request>? requests;
  bool? goodState;

  void register(_requestContent) async {
    // ログイン情報を取得
    final User? user = FirebaseAuth.instance.currentUser;

    if(_requestContent != ''){
      await FirebaseFirestore.instance.collection("requests").add({
        "companyName": _requestContent,
        "userId": user!.uid,
        'good': 0,
      });
    }
    notifyListeners();
  }
}

class Company {
  Company(this.companyId, this.name, this.industry);
  String companyId;
  String name;
  String industry;
}

class SearchCompanyModel extends ChangeNotifier {
  List<Company>? companies;

  void init() async {
    final QuerySnapshot companiesSnapshot =
    await FirebaseFirestore.instance.collection('companies').limit(20).get();

    final List<Company> _companies = companiesSnapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String companyId = document.id;
      final String name = data['name'];
      final String industry = data['industry'];
      return Company(companyId, name, industry);
    }).toList();

    companies = _companies;

    notifyListeners();
  }

  void changeState(String keyword) async {
    final QuerySnapshot companiesSnapshot =
    await FirebaseFirestore.instance.collection('companies').orderBy("name")
        .startAt([keyword]).endAt([keyword + '\uf8ff']).limit(20).get();


    final List<Company> _companies = companiesSnapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String companyId = document.id;
      final String name = data['name'];
      final String industry = data['industry'];
      return Company(companyId, name, industry);
    }).toList();

    companies = _companies;

    notifyListeners();
  }
}

class RewordAdsModel extends ChangeNotifier{

    int? adState;

    void init() async {
      this.adState = 0;
      notifyListeners();
    }

    void incrementGoodNum(_adState) async{
      adState = (_adState == 3) ? adState!+1 : -1;
      notifyListeners();
    }
}
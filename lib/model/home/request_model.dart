import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:norm_request/model/home/home_model.dart';

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
    await FirebaseFirestore.instance.collection('companies').limit(10).get();

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

    final QuerySnapshot companiesHiraganaSnapshot =
    await FirebaseFirestore.instance.collection('companies').orderBy("hiragana")
        .startAt([keyword]).endAt([keyword + '\uf8ff']).limit(20).get();

    final QuerySnapshot companiesHepburnSnapshot =
    await FirebaseFirestore.instance.collection('companies').orderBy("hepburn")
        .startAt([keyword]).endAt([keyword + '\uf8ff']).limit(20).get();


    final List<Company> companyList = companiesSnapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String companyId = document.id;
      final String name = data['name'];
      final String industry = data['industry'];
      return Company(companyId, name, industry);
    }).toList();

    final List<Company> _companiesHiragana = companiesHiraganaSnapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String companyId = document.id;
      final String name = data['name'];
      final String industry = data['industry'];
      return Company(companyId, name, industry);
    }).toList();
    companyList.addAll(_companiesHiragana);

    final List<Company> _companiesHepburn = companiesHepburnSnapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String companyId = document.id;
      final String name = data['name'];
      final String industry = data['industry'];
      return Company(companyId, name, industry);
    }).toList();
    companyList.addAll(_companiesHepburn);

    final List<String> _duplicateCompnies = [];
    final List<Company> _removeCompnies = [];
    companyList.asMap().forEach((int index, Company element) {
      if(_duplicateCompnies.contains(element.companyId)){
        _removeCompnies.add(element);
      }
      _duplicateCompnies.add(element.companyId);
    });
    // 重複した企業を削除
    companyList.removeWhere((element) => _removeCompnies.contains(element));



    companies = companyList;

    notifyListeners();
  }


}

class SelectCompanyModel extends ChangeNotifier {
  String? selectedCompanyName;
  String? selectedCompanyIndustry;

  void init() async {
    selectedCompanyName = "企業名を選択してください";
    selectedCompanyIndustry = "企業名を選択してください";

    notifyListeners();
  }

  void selectCompnay(String name, String industry) async {
    selectedCompanyName = name;
    selectedCompanyIndustry = industry;
    notifyListeners();
  }
}

class RegisterRequest extends ChangeNotifier{
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
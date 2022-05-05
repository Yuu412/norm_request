import 'dart:math';

import 'package:flutter/material.dart';
import 'package:norm_request/const/color_config.dart';
import 'package:norm_request/const/size_config.dart';
import 'package:norm_request/model/home/request_model.dart';
import 'package:provider/provider.dart';

class ShowRequestDialogProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchCompanyModel>(
      create: (_) => SearchCompanyModel()..init(),
      child: Consumer<SearchCompanyModel>(builder: (context, model, child) {
        final List<Company>? companies = model.companies;

        if(companies == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<Widget> widgets = companies.map(
              (company) => ShowChoicesCompany(
            company.companyId,
            company.name,
            company.industry,
          ),
        ).toList();

        return ShowRequestDialog(widgets);
      }),
    );
  }
}

class ShowChoicesCompany extends StatelessWidget{
  final String companyId, name, industry;
  ShowChoicesCompany(this.companyId, this.name, this.industry);

  @override
  Widget build(BuildContext context) {
    final SelectCompanyModel selectCompanyModel = context.watch<SelectCompanyModel>();

    return GestureDetector(
      onTap: () {
        selectCompanyModel.selectCompnay(name, industry);
      },
      child: Row(
        children: [
          Icon(
            Icons.schedule_outlined,
            color: Color(RetIconColor().lightGray()),
            size: 18,
          ),
          SizedBox(width: BlockSize().width(context) * 3),
          Flexible(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(RetTextColor().gray()),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class ShowRequestDialog extends StatelessWidget {
  final List<Widget> widgets;
  ShowRequestDialog(this.widgets);

  @override
  Widget build(BuildContext context) {
    final SearchCompanyModel searchStateModel = context.watch<SearchCompanyModel>();

    return ChangeNotifierProvider<SelectCompanyModel>(
      create: (_) => SelectCompanyModel()..init(),
      child: Consumer<SelectCompanyModel>(builder: (context, model, child) {
        return AlertDialog(
          title: Text(
            "企業名を入力してください",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(RetTextColor().blue()),
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "例：ソフトバンク",
                  prefixIcon: Icon(
                    Icons.search,
                    size: 22,
                  ),
                ),
                onChanged: (text) {
                  final String keyword = text;
                  searchStateModel.changeState(keyword);
                },
              ),
              Container(
                width: double.maxFinite,
                height: BlockSize().height(context) * 20,
                child: GridView.count(
                  padding: EdgeInsets.all(BlockSize().width(context) * 2),
                  crossAxisCount: 1,
                  crossAxisSpacing: BlockSize().width(context) * 0,
                  mainAxisSpacing: BlockSize().height(context) * 0,
                  childAspectRatio: (8 / 1),  //カードの比（横/縦）
                  children: widgets,
                ),
              ),
              SizedBox(height: BlockSize().height(context) * 3),
              Center(
                child: Icon(
                  Icons.expand_circle_down,
                  color: Color(RetIconColor().blue()),
                  size: 60,
                ),
              ),
              ShowSelectedCompanyInfo(),
            ],
          ),

          actions: <Widget>[
            FlatButton(
              color: Colors.transparent,
              textColor: Color(RetTextColor().gray()),
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            RequestSendButton(),

          ],
        );
      }),
    );
  }
}

class ShowSelectedCompanyInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SelectCompanyModel selectCompanyModel = context.watch<SelectCompanyModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: BlockSize().height(context) * 3),
        Row(
          children: [
            Container(
              height: 25,
              width: 5,
              child: VerticalDivider(),
              color: Color(RetLineColor().gray()),
            ),
            SizedBox(width: BlockSize().width(context) * 3),
            Text(
              "企業名",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(RetTextColor().gray()),
              ),
            ),

          ],
        ),
        SizedBox(height: BlockSize().height(context) * 1),
        Text(
          selectCompanyModel.selectedCompanyName!,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(RetTextColor().blue()),
          ),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: BlockSize().height(context) * 3),
        Row(
          children: [
            Container(
              height: 25,
              width: 5,
              child: VerticalDivider(),
              color: Color(RetLineColor().gray()),
            ),
            SizedBox(width: BlockSize().width(context) * 3),
            Text(
              "業界",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(RetTextColor().gray()),
              ),
            ),

          ],
        ),
        SizedBox(height: BlockSize().height(context) * 1),
        Text(
          selectCompanyModel.selectedCompanyIndustry!,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(RetTextColor().blue()),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class RequestSendButton extends StatelessWidget {
  final snackBar = SnackBar(
    backgroundColor: Color(RetBackgroundColor().defaultWhite()),
    duration: const Duration(seconds: 2),
    content: Row(
      children: [
        Icon(Icons.info, color: Color(RetIconColor().lightGray())),
        SizedBox(width: 20),
        Expanded(
          child: Text(
            '反映まで少し時間がかかります。',
            style: TextStyle(
              color: Color(RetTextColor().gray()),
            ),
          ),
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final SelectCompanyModel selectCompanyModel = context.watch<SelectCompanyModel>();
    return FlatButton(
      color: Colors.white,
      textColor: Color(RetTextColor().blue()),
      child: Text('リクエスト送信'),
      onPressed: (){
        RegisterRequest().register(selectCompanyModel.selectedCompanyName);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
  }
}
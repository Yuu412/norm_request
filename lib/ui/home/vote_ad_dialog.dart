import 'package:flutter/material.dart';
import 'package:norm_request/const/color_config.dart';
import 'package:norm_request/const/size_config.dart';
import 'package:norm_request/model/home/home_model.dart';
import 'package:norm_request/model/home/request_ad_dialog_model.dart';
import 'package:norm_request/ui/home/request_dialog.dart';
import 'package:provider/provider.dart';



class ShowVoteAdDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RewordAdsModel adManager = context.watch<RewordAdsModel>();

    return Consumer<RewordAdsModel>(builder: (context, model, child) {
      if(adManager.adCount! >= 3){
        return ShowRequestDialogProvider();
      } else {
        return SimpleDialog(
          title: Text('広告を３つ見ると応募可能！'),
          children: <Widget>[
            ShowVoteRewardAd(1),
            ShowVoteRewardAd(2),
            ShowVoteRewardAd(3),
            FlatButton(
              color: Colors.white,
              textColor: Colors.blue,
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    });
  }
}

class ShowVoteRewardAd extends StatelessWidget {
  final int adNum;
  ShowVoteRewardAd(this.adNum);

  @override
  Widget build(BuildContext context) {
    final RewordAdsModel adManager = context.watch<RewordAdsModel>();

    return Consumer<RewordAdsModel>(builder: (context, model, child) {
      return Container(
        margin: EdgeInsets.only(
          top : BlockSize().height(context) * 1.5,
          left : BlockSize().width(context) * 15,
          right : BlockSize().width(context) * 15,
          bottom : BlockSize().height(context) * 1.5,
        ),
        child: OutlinedButton(
          child: Text(
            adNum.toString() + '番目',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: OutlinedButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Color(RetButtonColor().gradientPurple()),
            shape: const StadiumBorder(),
          ),
          onPressed: (adManager.adCount! != adNum-1)? null : () {
            adManager.loadRewardedAd();
          },
        ),
      );
    });
  }
}



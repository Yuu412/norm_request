import 'package:flutter/material.dart';
import 'package:norm_request/const/color_config.dart';
import 'package:norm_request/const/size_config.dart';
import 'package:norm_request/model/home/request_ad_dialog_model.dart';
import 'package:norm_request/ui/home/request_dialog.dart';
import 'package:provider/provider.dart';

class ShowRequestAdDialogProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RewordAdsModel>(
      create: (_) => RewordAdsModel()..init(),
      child: Consumer<RewordAdsModel>(builder: (context, model, child) {

        return ShowRequestAdDialog();
      }),
    );
  }
}

class ShowRequestAdDialog extends StatelessWidget {
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
            ShowRequestRewardAd(1),
            ShowRequestRewardAd(2),
            ShowRequestRewardAd(3),
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

class ShowRequestRewardAd extends StatelessWidget {
  final int adNum;
  ShowRequestRewardAd(this.adNum);

  @override
  Widget build(BuildContext context) {
    final RewordAdsModel adManager = context.watch<RewordAdsModel>();

    return Consumer<RewordAdsModel>(builder: (context, model, child) {
      if((adManager.adState == false) & (adManager.adCount! == adNum-1)) {
        return Center(
          child: Container(
            margin: EdgeInsets.only(
              top : BlockSize().height(context) * 1.8,
              bottom: BlockSize().height(context) * 1.8,
            ),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if(adManager.adCount! >= adNum) {
        return Center(
          child: Container(
            margin: EdgeInsets.only(
              top : BlockSize().height(context) * 2,
              bottom: BlockSize().height(context) * 2,
            ),
            child: Text(
                    "Done!!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(RetTextColor().gray()),
                    ),
                  ),
          ),
        );
      }

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



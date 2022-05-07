import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:norm_request/const/color_config.dart';
import 'package:norm_request/const/size_config.dart';
import 'package:norm_request/model/home/request_ad_dialog_model.dart';
import 'package:norm_request/ui/home/request_dialog.dart';
import 'package:provider/provider.dart';

class ShowRequestAdDialogProvider extends StatelessWidget {
  const ShowRequestAdDialogProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RewordRequestAdsModel>(
      create: (_) => RewordRequestAdsModel()..init(),
      child: Consumer<RewordRequestAdsModel>(builder: (context, model, child) {

        return ShowRequestAdDialog();
      }),
    );
  }
}

class ShowRequestAdDialog extends StatelessWidget {
  const ShowRequestAdDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RewordRequestAdsModel adManager = context.watch<RewordRequestAdsModel>();

    return Consumer<RewordRequestAdsModel>(builder: (context, model, child) {
      if(adManager.adCount! >= 3){
        return ShowRequestDialogProvider();
      } else {
        return SimpleDialog(
          title: Text('広告を視聴すると応募可能！'),
          children: <Widget>[
            VotePieChartArea(),
            ShowRequestRewardAdButton(adManager.adCount!),
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

class VotePieChartArea extends StatelessWidget{
  const VotePieChartArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: BlockSize().width(context) * 50,
      height: BlockSize().height(context) * 25,
      child: Stack(
        children: [
          VotePieChart(),
          ChartCenterTitle(),
        ],
      ),
    );
  }
}

class VotePieChart extends StatelessWidget{
  const VotePieChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RewordRequestAdsModel goodCountData = context.watch<RewordRequestAdsModel>();
    final adCount = goodCountData.adCount!;
    final ratio = ((adCount < 11) ? adCount : 10).toDouble();
    final pie = ((adCount < 1) ? 0.001 : adCount).toDouble();

    return PieChart(
      PieChartData(
        startDegreeOffset: 270,
        centerSpaceRadius: BlockSize().width(context) * 20,
        sectionsSpace: 0,
        sections: [
          PieChartSectionData(
              value: pie,
              title: '',
              radius: 5,
              color: Color(RetGraphColor().blue()).withOpacity(ratio * 0.5)
          ),
          PieChartSectionData(
            value: 3.0 - ratio,
            title: '',
            radius: 5,
            color: Color(RetGraphColor().superLightGray()),
          ),
        ],
      ),
      swapAnimationDuration: const Duration(milliseconds: 3000), // Optional
      swapAnimationCurve: Curves.linearToEaseOut, // Optional
    );
  }
}

class ChartCenterTitle extends StatelessWidget{
  const ChartCenterTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RewordRequestAdsModel goodCountData = context.watch<RewordRequestAdsModel>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            (goodCountData.adCount! * 34).toInt().toString(),
            style: TextStyle(
              color: Color(RetTextColor().blue()),
              fontWeight: FontWeight.w500,
              fontSize: 48,
            ),
          ),
          Text(
            'percent',
            style: TextStyle(
              color: Color(RetTextColor().lightGray()),
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  }
}

class ShowRequestRewardAdButton extends StatelessWidget {
  final int adNum;
  ShowRequestRewardAdButton(this.adNum);

  @override
  Widget build(BuildContext context) {
    final RewordRequestAdsModel adManager = context.watch<RewordRequestAdsModel>();

    return Consumer<RewordRequestAdsModel>(builder: (context, model, child) {
      if((adManager.adState == false)) {
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

      return Container(
        margin: EdgeInsets.only(
          top : BlockSize().height(context) * 1.5,
          left : BlockSize().width(context) * 15,
          right : BlockSize().width(context) * 15,
          bottom : BlockSize().height(context) * 1.5,
        ),
        child: SizedBox(
          width: BlockSize().width(context) * 40,
          height: BlockSize().height(context) * 5,
          child: OutlinedButton(
            child: const Text(
              '広告を視聴',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Color(RetButtonColor().gradientPurple()),
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              adManager.loadRewardedAd();
            },
          ),
        ),
      );
    });


  }
}
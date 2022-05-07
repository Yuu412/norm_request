import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:norm_request/const/color_config.dart';
import 'package:norm_request/const/size_config.dart';
import 'package:norm_request/model/home/home_model.dart';
import 'package:norm_request/model/home/vote_ad_dialog_model.dart';
import 'package:norm_request/ui/common/icon_widget/info_widget.dart';
import 'package:norm_request/ui/home/vote_ad_dialog.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(BlockSize().width(context) * 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          PageTitleArea(),
          ShowRequestList(),
          ShowDialogButton(),
        ],
      ),
    );
  }
}

class PageTitleArea extends StatelessWidget {
  const PageTitleArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: BlockSize().height(context)*2,
        bottom: BlockSize().height(context)*2,
      ),
      child: ShowPageTitle(),
    );
  }
}

class ShowPageTitle extends StatelessWidget {
  final String title = '企業分析リクエスト一覧';
  final String subtitle = '分析してほしいリクエストに投票してください。';
  final String description = '分析してほしい企業に投票してください。\n投票数が多い企業から優先的に分析します。\n\nまた、分析リクエストは画面下の「＋」ボタンから行ってください。';

  const ShowPageTitle({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(RetTextColor().gray()),
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: Color(RetTextColor().gray()),
              ),
            ),
          ],
        ),
        InfoIcon(description),
      ],
    );
  }
}

class ShowRequestList extends StatelessWidget {
  const ShowRequestList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ChangeNotifierProvider<RequestListModel>(
        create: (_) => RequestListModel()..init(),
        child: Consumer<RequestListModel>(builder: (context, model, child) {
          final List<Request>? requests = model.requests;
          if(requests == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<Widget> widgets = requests.map(
                (request) => RequestCard(
              request.id,
              request.content,
              request.good,
              request.order,
              request.goodState,
            ),
          ).toList();

          return GridView.count(
            padding: EdgeInsets.all(BlockSize().width(context) * 2),
            crossAxisCount: 1,
            crossAxisSpacing: BlockSize().width(context) * 5,
            mainAxisSpacing: BlockSize().height(context) * 3,
            childAspectRatio: (4 / 1),  //カードの比（横/縦）
            children: widgets,
          );
        }),
      ),
    );
  }
}

class RequestCard extends StatelessWidget{
  final String requestId, content;
  final int goodNum, order;
  final bool goodState;
  RequestCard(this.requestId, this.content, this.goodNum, this.order, this.goodState);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RewordVoteAdsModel>(
      create: (_) => RewordVoteAdsModel(goodState, goodNum)..init(),
      child: Consumer<RewordVoteAdsModel>(builder: (context, model, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RequestOrder(order),
            VotePieChartArea(),
            RequestCompanyInfo(content),
            LikeIconArea(requestId, goodState),
          ],
        );
      }),
    );
  }
}

class RequestOrder extends StatelessWidget{
  final int order;
  RequestOrder(this.order);

  @override
  Widget build(BuildContext context) {
    return Text(
      order.toString(),
      style: TextStyle(
        color: Color(RetTextColor().lightGray()),
        fontSize: 18,
      ),
    );
  }
}

class VotePieChartArea extends StatelessWidget{
  const VotePieChartArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: BlockSize().width(context) * 18,
      height: BlockSize().height(context) * 9,
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
    final RewordVoteAdsModel goodCountData = context.watch<RewordVoteAdsModel>();
    final goodNum = goodCountData.voteNum!;
    final ratio = ((goodNum < 11) ? goodNum : 10).toDouble();
    final pie = ((goodNum < 1) ? 1 : goodNum).toDouble();

    return PieChart(
      PieChartData(
        startDegreeOffset: 270,
        centerSpaceRadius: BlockSize().width(context) * 7.5,
        sectionsSpace: 0,
        sections: [
          PieChartSectionData(
              value: pie,
              title: '',
              radius: 5,
              color: Color(RetGraphColor().blue()).withOpacity(ratio * 0.1)
          ),
          PieChartSectionData(
            value: 10.0 - ratio,
            title: '',
            radius: 5,
            color: Color(RetGraphColor().superLightGray()),
          ),
        ],
      ),
      swapAnimationDuration: const Duration(milliseconds: 2000), // Optional
      swapAnimationCurve: Curves.linearToEaseOut, // Optional
    );
  }
}

class ChartCenterTitle extends StatelessWidget{
  const ChartCenterTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RewordVoteAdsModel goodCountData = context.watch<RewordVoteAdsModel>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            goodCountData.voteNum!.toInt().toString(),
            style: TextStyle(
              color: Color(RetTextColor().gray()),
              fontWeight: FontWeight.w500,
              fontSize: 24,
            ),
          ),
          Text(
            'vote',
            style: TextStyle(
              color: Color(RetTextColor().lightGray()),
            ),
          )
        ],
      ),
    );
  }
}

class RequestCompanyInfo extends StatelessWidget{
  final String content;
  RequestCompanyInfo(this.content);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: BlockSize().width(context) * 45,
      child: Text(
        content,
        style: TextStyle(
          fontSize: 14,
          color: Color(RetTextColor().gray())
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}









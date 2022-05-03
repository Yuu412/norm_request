import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:norm_request/const/color_config.dart';
import 'package:norm_request/const/size_config.dart';
import 'package:norm_request/model/home/request_model.dart';
import 'package:norm_request/ui/common/icon_widget/info_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(BlockSize().width(context) * 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          PageTitleArea(),
          RequestArea(),
          AddRequestButton(),
        ],
      ),
    );
  }
}

class PageTitleArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: BlockSize().height(context)*2,
        bottom: BlockSize().height(context)*2,
      ),
      child: PageTitle(),
    );
  }
}

class PageTitle extends StatelessWidget {
  final String title = '企業分析リクエスト一覧';
  final String subtitle = '分析してほしいリクエストに投票してください。';
  final String description = 'normに分析してほしい企業を教えてください。good数が上位のものから優先的に分析します。';
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
                fontSize: 12,
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

class RequestArea extends StatelessWidget {
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
                (opinion) => RequestCard(
              opinion.id,
              opinion.content,
              opinion.good,
              opinion.order,
              opinion.goodState,
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
  final String opinionId, content;
  final int goodNum, order;
  final bool goodState;
  RequestCard(this.opinionId, this.content, this.goodNum, this.order, this.goodState);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GoodCountModel>(
      create: (_) => GoodCountModel(goodNum)..init(),
      child: Consumer<GoodCountModel>(builder: (context, model, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RequestCounter(order),
            GoodPieChartArea(),
            RequestContent(content),
            LikeIconArea(opinionId, goodState),
          ],
        );
      }),
    );
  }
}

class RequestCounter extends StatelessWidget{
  final int order;
  RequestCounter(this.order);

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

class GoodPieChartArea extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: BlockSize().width(context) * 18,
      height: BlockSize().height(context) * 9,
      child: Stack(
        children: [
          GoodPieChart(),
          ChartCenterTitle(),
        ],
      ),
    );
  }
}

class GoodPieChart extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final GoodCountModel goodCountData = context.watch<GoodCountModel>();
    final goodNum = goodCountData.goodNum!;
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
      swapAnimationDuration: const Duration(milliseconds: 300), // Optional
      swapAnimationCurve: Curves.linear, // Optional
    );
  }
}

class ChartCenterTitle extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final GoodCountModel goodCountData = context.watch<GoodCountModel>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            goodCountData.goodNum!.toInt().toString(),
            style: TextStyle(
              color: Color(RetTextColor().gray()),
              fontWeight: FontWeight.w500,
              fontSize: 24,
            ),
          ),
          Text(
            'good',
            style: TextStyle(
              color: Color(RetTextColor().lightGray()),
            ),
          )
        ],
      ),
    );
  }
}

class RequestContent extends StatelessWidget{
  final String content;
  RequestContent(this.content);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: BlockSize().width(context) * 45,
      child: Text(
        content,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}

class LikeIconArea extends StatelessWidget{
  final String opinionId;
  final bool goodState;
  LikeIconArea(this.opinionId, this.goodState);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: BlockSize().height(context) * 22,
      child: ChangeNotifierProvider<GoodStateModel>(
        create: (_) => GoodStateModel(goodState)..init(),
        child: Consumer<GoodStateModel>(builder: (context, model, child) {
          return LikeIcon(opinionId);
        }),
      ),
    );
  }
}

class LikeIcon extends StatelessWidget{
  final String opinionId;
  LikeIcon(this.opinionId);

  @override
  Widget build(BuildContext context) {
    final GoodStateModel goodStateModel = context.watch<GoodStateModel>();
    final GoodCountModel goodCountModel = context.watch<GoodCountModel>();
    final RequestListModel opinionListModel = context.watch<RequestListModel>();

    return SizedBox(
      width: BlockSize().width(context) * 10,
      child: GestureDetector(
        onTap: () {
          goodStateModel.changeState(goodStateModel.goodState);
          opinionListModel.pushLikeIcon(opinionId, goodStateModel.goodState, goodCountModel.goodNum);
          goodCountModel.incrementGoodNum(goodStateModel.goodState);
        },
        child: Container(
          width: BlockSize().width(context) * 8,
          height: BlockSize().height(context) * 4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(RetBackgroundColor().white()),
            boxShadow: [
              BoxShadow(
                color: Color(ShadowColor().shadowColor()), //色
                offset: Offset(3, 3),
                blurRadius: 10.0,
                spreadRadius: 1,
              ),
            ],
          ),
          child: switchIcon(goodStateModel.goodState),
        ),
      ),
    );
  }

  Widget switchIcon(state) {
    switch (state) {
      case true:
        return Icon(
          Icons.favorite,
          color: Color(RetIconColor().pink()),
          size: 22,
        );
      default:
        return Icon(
          Icons.favorite_border,
          color: Color(RetIconColor().pink()),
          size: 22,
        );
    }
  }
}

class AddRequestButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: (){
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return AddRequestDialog();
            },
          );
        },
        child: Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(28),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class AddRequestDialog extends StatelessWidget {
  var _opinionContent = TextEditingController();

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
    return AlertDialog(
      title: Text("分析希望の企業名"),
      content: TextField(
        controller: _opinionContent,
        decoration: InputDecoration(hintText: "例：norm株式会社"),
      ),
      actions: <Widget>[
        FlatButton(
          color: Colors.white,
          textColor: Colors.blue,
          child: Text('キャンセル'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          color: Colors.white,
          textColor: Colors.blue,
          child: Text('OK'),
          onPressed: (){
            AddRequest().register(_opinionContent.text);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:norm_request/const/color_config.dart';
import 'package:norm_request/const/size_config.dart';
import 'package:norm_request/model/home/home_model.dart';
import 'package:norm_request/model/home/vote_ad_dialog_model.dart';
import 'package:norm_request/ui/home/request_ad_dialog.dart';
import 'package:provider/provider.dart';

class LikeIconArea extends StatelessWidget{
  final String requestId;
  final bool goodState;
  LikeIconArea(this.requestId, this.goodState);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: BlockSize().height(context) * 22,
      child: Consumer<RewordVoteAdsModel>(builder: (context, model, child) {
        return LikeIcon(requestId);
      }),
    );
  }
}

class LikeIcon extends StatelessWidget{
  final String requestId;
  LikeIcon(this.requestId);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: BlockSize().width(context) * 10,
      child: TriggerVoteAd(requestId),
    );
  }
}

class TriggerVoteAd extends StatelessWidget{
  final String requestId;
  TriggerVoteAd(this.requestId);

  @override
  Widget build(BuildContext context) {
    final RewordVoteAdsModel rewordVoteAdsModel = context.watch<RewordVoteAdsModel>();

    return Consumer<RewordVoteAdsModel>(builder: (context, model, child) {
      if(rewordVoteAdsModel.adState == false){
        return Center(child: CircularProgressIndicator());
      }
      return TriggerVoteAdButton(context);
    });
  }

  Widget TriggerVoteAdButton(BuildContext context) {
    final RewordVoteAdsModel rewordVoteAdsModel = context.watch<RewordVoteAdsModel>();
    final RequestListModel requestListModel = context.watch<RequestListModel>();
    return GestureDetector(
      onTap: () {
        if(rewordVoteAdsModel.voteState == false){
          rewordVoteAdsModel.loadRewardedAd(requestId);
        } else{
          rewordVoteAdsModel.changeVoteState();
          requestListModel.pushLikeIcon(requestId, rewordVoteAdsModel.voteState, rewordVoteAdsModel.voteNum);
          rewordVoteAdsModel.incrementVoteNum(rewordVoteAdsModel.voteState);
        }
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
        child: switchIcon(rewordVoteAdsModel.voteState),
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

class ShowDialogButton extends StatelessWidget {
  const ShowDialogButton({Key? key}) : super(key: key);

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
              return ShowRequestAdDialogProvider();
              //return ShowRequestDialogProvider();
            },
          );
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Color(RetIconColor().blue()),
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
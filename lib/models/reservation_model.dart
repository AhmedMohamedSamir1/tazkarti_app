
import 'package:tazkarti_system/models/match_model.dart';

class ReservationModel{
  late String userId;
  late String matchId;
  late int numOfTickets;
  late double totalPrice;
  MatchModel? matchModel;

  ReservationModel({
    required this.userId,
    required this.matchId,
    required this.numOfTickets,
    required this.totalPrice,
    this.matchModel,
  });

  ReservationModel.fromJson(Map<String, dynamic> json){
    matchId = json['matchId'];
    numOfTickets = json['numOfTickets'];
    totalPrice = json['totalPrice'];
  }

  Map<String, dynamic> toMap(){
    return {
      'userId':userId,
      'matchId':matchId,
      'numOfTickets':numOfTickets,
      'totalPrice':totalPrice,
    };
  }

}


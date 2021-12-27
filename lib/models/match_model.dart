class MatchModel{

  late String matchId;
  late String matchDate;
  late String matchTime;
  late String firstTeam;
  late String firstTeamLogo;
  late String secondTeam;
  late String secondTeamLogo;
  late String stadiumName;
  late String stadiumUrl;
  late String matchTickets;
  late String ticketPrice;
  late bool ticketsPublished;
  late int numOfReservedTickets;
  DateTime? date;



  MatchModel({
    required this.matchId,
    required this.matchDate,
    required this.matchTime,
    required this.firstTeam,
    required this.firstTeamLogo,
    required this.secondTeam,
    required this.secondTeamLogo,
    required this.stadiumName,
    required this.stadiumUrl,
    required this.matchTickets,
    required this.ticketPrice,
    required this.ticketsPublished,
    required this.numOfReservedTickets,
    this.date,

  });

  MatchModel.fromJson(Map<String, dynamic>json)
  {
    matchId = json['matchId'];
    matchDate = json['matchDate'];
    matchTime = json['matchTime'];
    firstTeam = json['firstTeam'];
    secondTeam = json['secondTeam'];
    firstTeamLogo = json['firstTeamLogo'];
    secondTeamLogo = json['secondTeamLogo'];

    stadiumName = json['stadiumName'];
    stadiumUrl = json['stadiumUrl'];
    matchTickets = json['matchTickets'];
    ticketPrice = json['ticketPrice'];
    ticketsPublished = json['ticketsPublished'];
    numOfReservedTickets = json['numOfReservedTickets'];

  }

  Map<String, dynamic> toMap()
  {
    return {
      'matchId': matchId,
      'matchDate': matchDate,
      'matchTime': matchTime,
      'firstTeam': firstTeam,
      'secondTeam': secondTeam,
      'firstTeamLogo': firstTeamLogo,
      'secondTeamLogo': secondTeamLogo,

      'stadiumName':stadiumName,
      'stadiumUrl':stadiumUrl,
      'matchTickets':matchTickets,
      'ticketPrice':ticketPrice,
      'ticketsPublished':ticketsPublished,
      'numOfReservedTickets':numOfReservedTickets,

      'date': date,
    };
  }
}
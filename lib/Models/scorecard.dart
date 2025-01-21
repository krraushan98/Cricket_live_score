import 'dart:convert';

class MatchData {
  final String msg;
  final bool status;
  final MatchDetails data;
  final int? isHundred;

  MatchData({
    required this.msg,
    required this.status,
    required this.data,
    required this.isHundred,
  });

  factory MatchData.fromJson(Map<String, dynamic> json) {
    return MatchData(
      msg: json['msg'],
      status: json['status'],
      data: MatchDetails.fromJson(json['data']),
      isHundred: json['is_hundred'] ?? 0,
    );
  }
}

class MatchDetails {
  final String result;
  final Map<String, TeamScorecard> scorecard;

  MatchDetails({
    required this.result,
    required this.scorecard,
  });

  factory MatchDetails.fromJson(Map<String, dynamic> json) {
    return MatchDetails(
      result: json['result'],
      scorecard: (json['scorecard'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, TeamScorecard.fromJson(value)),
      ),
    );
  }
}

class TeamScorecard {
  final List<Bowler> bowlers;
  final List<FallWicket> fallWickets;
  final List<Partnership> partnerships;
  final List<Batsman> batsmen;
  final Team team;

  TeamScorecard({
    required this.bowlers,
    required this.fallWickets,
    required this.partnerships,
    required this.batsmen,
    required this.team,
  });

  factory TeamScorecard.fromJson(Map<String, dynamic> json) {
    return TeamScorecard(
      bowlers: (json['bolwer'] != null)
          ? List<Bowler>.from(json['bolwer'].map((x) => Bowler.fromJson(x)))
          : [], // Return empty list if null

      fallWickets: (json['fallwicket'] != null)
          ? List<FallWicket>.from(json['fallwicket'].map((x) => FallWicket.fromJson(x)))
          : [],

      partnerships: (json['partnership'] != null)
          ? List<Partnership>.from(json['partnership'].map((x) => Partnership.fromJson(x)))
          : [],

      batsmen: (json['batsman'] != null)
          ? List<Batsman>.from(json['batsman'].map((x) => Batsman.fromJson(x)))
          : [],

      team: Team.fromJson(json['team']), // Assuming 'team' is never null
    );
  }
}


class Bowler {
  final String name;
  final String over;
  final int maiden;
  final int run;
  final int wicket;
  final int dotBall;
  final String economy;
  final int playerId;

  Bowler({
    required this.name,
    required this.over,
    required this.maiden,
    required this.run,
    required this.wicket,
    required this.dotBall,
    required this.economy,
    required this.playerId,
  });

  factory Bowler.fromJson(Map<String, dynamic> json) {
    return Bowler(
      name: json['name'],
      over: (json['over'].toString()),
      maiden: json['maiden'],
      run: json['run'],
      wicket: json['wicket'],
      dotBall: json['dot_ball'],
      economy: json['economy'],
      playerId: json['player_id'],
    );
  }
}

class FallWicket {
  final String player;
  final int score;
  final String over;
  final int wicket;

  FallWicket({
    required this.player,
    required this.score,
    required this.over,
    required this.wicket,
  });

  factory FallWicket.fromJson(Map<String, dynamic> json) {
    return FallWicket(
      player: json['player'],
      score: json['score'],
      over: json['over'],
      wicket: int.parse(json['wicket']),
    );
  }
}

class Partnership {
  final int run;
  final int playerAId;
  final int playerBId;
  final String playersName;
  final int ball;

  Partnership({
    required this.run,
    required this.playerAId,
    required this.playerBId,
    required this.playersName,
    required this.ball,
  });

  factory Partnership.fromJson(Map<String, dynamic> json) {
    return Partnership(
      run: json['run'],
      playerAId: json['player_a_id'],
      playerBId: json['player_b_id'],
      playersName: json['players_name'],
      ball: json['ball'],
    );
  }
}

class Batsman {
  final String name;
  final int ball;
  final int run;
  final String strikeRate;
  final int fours;
  final int sixes;
  final String outBy;
  final int playerId;

  Batsman({
    required this.name,
    required this.ball,
    required this.run,
    required this.strikeRate,
    required this.fours,
    required this.sixes,
    required this.outBy,
    required this.playerId,
  });

  factory Batsman.fromJson(Map<String, dynamic> json) {
    return Batsman(
      name: json['name'],
      ball: json['ball'],
      run: json['run'],
      strikeRate: json['strike_rate'],
      fours: json['fours'],
      sixes: json['sixes'],
      outBy: json['out_by'],
      playerId: json['player_id'],
    );
  }
}

class Team {
  final String name;
  final String shortName;
  final String flag;
  final int score;
  final int wicket;
  final String over;
  final String extras;

  Team({
    required this.name,
    required this.shortName,
    required this.flag,
    required this.score,
    required this.wicket,
    required this.over,
    required this.extras,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      name: json['name'],
      shortName: json['short_name'],
      flag: json['flag'],
      score: json['score'],
      wicket: json['wicket'],
      over: json['over'],
      extras: json['extras'],
    );
  }
}

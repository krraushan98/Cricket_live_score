import 'dart:convert';

class CricketMatchResponse {
  final String msg;
  final bool status;
  final List<MatchData> data;

  CricketMatchResponse({
    required this.msg,
    required this.status,
    required this.data,
  });

  factory CricketMatchResponse.fromJson(String str) =>
      CricketMatchResponse.fromMap(json.decode(str));

  factory CricketMatchResponse.fromMap(Map<String, dynamic> json) {
  return CricketMatchResponse(
    msg: json["msg"],
    status: json["status"],
    data: (json["data"] is List) // Ensure "data" is a List before mapping
        ? List<MatchData>.from(json["data"].map((x) => MatchData.fromMap(x)))
        : [], // Return an empty list if it's not a valid list
  );
}

}

class MatchData {
  final String maxRate;
  final String venue;
  final String matchStatus;
  final String series;
  final String toss;
  final String matchTime;
  final String matchType;
  final Team teamA;
  final Team teamB;
  final String matchDate;
  final String matchNumber;
  final String seriesType;
  final String result;
  final String? needRunBall;
  final String? dayStumps;
  final int matchId;

  MatchData({
    required this.maxRate,
    required this.venue,
    required this.matchStatus,
    required this.series,
    required this.toss,
    required this.matchTime,
    required this.matchType,
    required this.teamA,
    required this.teamB,
    required this.matchDate,
    required this.matchNumber,
    required this.seriesType,
    required this.result,
    this.needRunBall,
    this.dayStumps,
    required this.matchId,
  });

  factory MatchData.fromMap(Map<String, dynamic> json) => MatchData(
        maxRate: json["max_rate"].toString(),
        venue: json["venue"],
        matchStatus: json["match_status"],
        series: json["series"],
        toss: json["toss"],
        matchTime: json["match_time"],
        matchType: json["match_type"],
        teamA: Team.fromMap(json, true),
        teamB: Team.fromMap(json, false),
        matchDate: json["match_date"],
        matchNumber: json["matchs"],
        seriesType: json["series_type"],
        result: json["result"],
        needRunBall: json["need_run_ball"],
        dayStumps: json["day_stumps"],
        matchId: json["match_id"],
      );
}

class Team {
  final String name;
  final String shortName;
  final String imgUrl;
  final int teamId;
  final Score? score;

  Team({
    required this.name,
    required this.shortName,
    required this.imgUrl,
    required this.teamId,
    this.score,
  });

  factory Team.fromMap(Map<String, dynamic> json, bool isTeamA) {
    final String prefix = isTeamA ? "team_a" : "team_b";
    return Team(
      name: json[prefix],
      shortName: json["${prefix}_short"],
      imgUrl: json["${prefix}_img"],
      teamId: json["${prefix}_id"],
      score: json["${prefix}_score"] != "" && json["${prefix}_score"] != null
          ? Score.fromMap(json["${prefix}_score"]) 
          : null,
    );
  }
}

class Score {
  final int ball;
  final String wicket;
  final String over;
  final String totalScore;

  Score({
    required this.ball,
    required this.wicket,
    required this.over,
    required this.totalScore,
  });

  factory Score.fromMap(Map<String, dynamic> json) {
    final Map<String, dynamic>? innings = json["1"] ?? json["2"];
    if (innings == null) {
      return Score(ball: 0,  over: "",wicket: "", totalScore: "");
    }
    return Score(
      ball: innings["ball"],
      wicket: innings["wicket"].toString(),
      over: innings["over"].toString(),
      totalScore: innings["score"].toString(),
    );
  }
}

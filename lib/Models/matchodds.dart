import 'dart:convert';

class MatchData {
  final Map<String, List<MatchDetails>> data;
  final String msg;
  final bool status;
  final int isHundred;

  MatchData({
    required this.data,
    required this.msg,
    required this.status,
    required this.isHundred,
  });

  factory MatchData.fromJson(Map<String, dynamic> json) {
    return MatchData(
      data: (json['data'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as List).map((e) => MatchDetails.fromJson(e)).toList(),
        ),
      ),
      msg: json['msg'],
      status: json['status'],
      isHundred: json['is_hundred'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((key, value) => MapEntry(key, value.map((e) => e.toJson()).toList())),
      'msg': msg,
      'status': status,
      'is_hundred': isHundred,
    };
  }
}

class MatchDetails {
  final List<OverData> overs;
  final TeamData team;

  MatchDetails({required this.overs, required this.team});

  factory MatchDetails.fromJson(Map<String, dynamic> json) {
    return MatchDetails(
      overs: (json['overs'] as List).map((e) => OverData.fromJson(e)).toList(),
      team: TeamData.fromJson(json['team']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overs': overs.map((e) => e.toJson()).toList(),
      'team': team.toJson(),
    };
  }
}

class OverData {
  final int matchOddId;
  final int lMin;
  final String lOvr;
  final String time;
  final int inning;
  final double minRate;
  final double overs;
  final String dateTime;
  final int type;
  final int sOvr;
  final int sMin;
  final int lMax;
  final double maxRate;
  final String favTeam;
  final int sMax;
  final String score;
  final String runs;
  final String team;

  OverData({
    required this.matchOddId,
    required this.lMin,
    required this.lOvr,
    required this.time,
    required this.inning,
    required this.minRate,
    required this.overs,
    required this.dateTime,
    required this.type,
    required this.sOvr,
    required this.sMin,
    required this.lMax,
    required this.maxRate,
    required this.favTeam,
    required this.sMax,
    required this.score,
    required this.runs,
    required this.team,
  });

  factory OverData.fromJson(Map<String, dynamic> json) {
    return OverData(
      matchOddId: json['match_odd_id'],
      lMin: json['l_min'],
      lOvr: json['l_ovr'],
      time: json['time'],
      inning: json['inning'],
      minRate: (json['min_rate'] as num).toDouble(),
      overs: (json['overs'] as num).toDouble(),
      dateTime: json['date_time'],
      type: json['type'],
      sOvr: json['s_ovr'],
      sMin: json['s_min'],
      lMax: json['l_max'],
      maxRate: (json['max_rate'] as num).toDouble(),
      favTeam: json['fav_team'],
      sMax: json['s_max'],
      score: json['score'],
      runs: json['runs'],
      team: json['team'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'match_odd_id': matchOddId,
      'l_min': lMin,
      'l_ovr': lOvr,
      'time': time,
      'inning': inning,
      'min_rate': minRate,
      'overs': overs,
      'date_time': dateTime,
      'type': type,
      's_ovr': sOvr,
      's_min': sMin,
      'l_max': lMax,
      'max_rate': maxRate,
      'fav_team': favTeam,
      's_max': sMax,
      'score': score,
      'runs': runs,
      'team': team,
    };
  }
}

class TeamData {
  final String score;
  final int over;
  final String team;
  final int runs;

  TeamData({required this.score, required this.over, required this.team, required this.runs});

  factory TeamData.fromJson(Map<String, dynamic> json) {
    return TeamData(
      score: json['score'],
      over: json['over'],
      team: json['team'],
      runs: json['runs'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'over': over,
      'team': team,
      'runs': runs,
    };
  }
}

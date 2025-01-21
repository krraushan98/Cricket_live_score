import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:goto_assignment/Models/match_commentry';
import 'package:goto_assignment/Models/match_list.dart';
import 'package:goto_assignment/Models/matchodds.dart' as MatchOddsModel;
import 'package:goto_assignment/Models/scorecard.dart' as Scorecard;

class ApiService extends GetxController {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://cricket-live-line1.p.rapidapi.com',
      headers: {
        'x-rapidapi-key': 'eedbad2a05mshfc6c3133d4ba150p1504a2jsn7fa90bfb69d3',
        'Content-Type': 'application/json',
      },
    ),
  );

  var isLoadingMatchList = false.obs;
  var matchList = <MatchData>[].obs;
  var matchDetails = <Scorecard.MatchDetails>[].obs;
  var matchOdds = <MatchOddsModel.MatchDetails>[].obs;
  var commentory = <Commentary>[].obs;

  Future<void> fetchMatches() async {
    try {
      isLoadingMatchList(true);
      dio.Response response = await _dio.get('/liveMatches');
      if (response.statusCode == 200 && response.data != null) {
        CricketMatchResponse matchResponse =
            CricketMatchResponse.fromMap(response.data);
        matchList.assignAll(matchResponse.data);
      } else {
        throw Exception("Failed to load match list: ${response.statusCode}");
      }
    } catch (e) {
      //Get.snackbar("Error", "Failed to load match list: $e");
      print(e);
    } finally {
      isLoadingMatchList(false);
    }
  }

  Future<void> fetchScorecard(String matchId) async {
    // print("Fetching scorecard for match ID: $matchId");
    try {
      dio.Response response = await _dio.get('/match/$matchId/scorecard');
      print("API Response: ${response.data}");
      if (response.statusCode == 200) {

        Scorecard.MatchData matchData =
            Scorecard.MatchData.fromJson(response.data);
        matchDetails.assign(matchData.data);
      } else {
        throw Exception("Failed to load scorecard: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching scorecard: $e");
      throw Exception('Failed to load scorecard: $e');
    }
  }

  Future<void> fetchMatchOdds(String matchId) async {
    try {
      dio.Response response = await _dio.get('/match/$matchId/odds');
      if (response.statusCode == 200) {
        MatchOddsModel.MatchData matchOddsData =
            MatchOddsModel.MatchData.fromJson(response.data);
        matchOdds.assignAll(matchOddsData.data.values.expand((list) => list));
      } else {
        throw Exception("Failed to load match odds: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception('Failed to load match odds: $e');
    }
  }

  Future<void> fetchCommentary(String matchId) async {
    try {
      dio.Response response = await _dio.get('/match/$matchId/commentary');
      MatchCommentary commentary = MatchCommentary.fromJson(response.data);
      List<Commentary> allCommentaries = [];
      commentary.data.forEach((inningKey, inningData) {
        inningData.overs.forEach((overKey, overCommentaryList) {
          allCommentaries.addAll(overCommentaryList);
        });
      });
      commentory.assignAll(allCommentaries);

      // print("Total Commentaries Loaded: ${commentory.length}");
    } catch (e) {
      throw Exception('Failed to load commentary: $e');
    }
  }
}

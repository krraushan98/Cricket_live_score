import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goto_assignment/Api/api_service.dart';
import 'package:goto_assignment/Models/scorecard.dart';

class MatchDetailPage extends StatefulWidget {
  @override
  State<MatchDetailPage> createState() => _MatchDetailPageState();
}

class _MatchDetailPageState extends State<MatchDetailPage> {
  final data = Get.arguments;
  late String matchId;
  late String matchSeries;
  Timer? timer;
  final ApiService apiService = Get.put(ApiService());

  void autoCall() {
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      initalClass();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    matchId = data['id'].toString();
    print("Match ID: $matchId");
    matchSeries = data['series'];
    super.initState();
    initalClass();
    autoCall();
  }

  void initalClass() async {
    await apiService.fetchScorecard(matchId);
    await apiService.fetchMatchOdds(matchId);
    await apiService.fetchCommentary(matchId);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // ✅ Define tab count
      child: SafeArea(
        child: Scaffold(
          // appBar: AppBar(title: Text('Match Details')),
          body: Obx(() {
            if (apiService.matchDetails.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final matchDetails = apiService.matchDetails.first;

            return Column(
              children: [
                ///
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.orange.shade100],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Match Series Title
                              Text(
                                matchSeries,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),

                              // Match Status & Date
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  if (matchDetails.result != null &&
                                      matchDetails.result != "") ...[
                                    Text(
                                      matchDetails.result,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ] else ...[
                                    const Text(
                                      "Live",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Teams Row
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildTeamColumn(matchDetails
                                        .scorecard.values.first.team),
                                    const SizedBox(width: 15),
                                    const Text(
                                      "VS",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    _buildTeamColumn(matchDetails
                                        .scorecard.values.last.team),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        )),
                  ),
                ),

                /// ✅ TabBar just below the Container
                const TabBar(
                  labelColor: Colors.orange,
                  tabs: [
                    Tab(text: 'Scorecard'),
                    Tab(text: 'Match Odds'),
                    Tab(text: 'Commentary'),
                  ],
                ),

                /// ✅ Expanded TabBarView to prevent overflow
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildScorecard(matchDetails),
                      _buildMatchOdds(matchDetails),
                      _buildCommentary(matchDetails),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTeamColumn(Team team) {
    return Column(
      children: [
        Text(
          team.name.toUpperCase(),
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
        ),
        const SizedBox(height: 5),
        if (team.score != null && team.score != "")
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.orange.shade100,
                child: Image(
                    image: NetworkImage(team.flag), width: 40, height: 40),
              ),
              const SizedBox(width: 10),
              Text(
                "${team.score}/${team.wicket}",
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          )
        else
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.orange.shade100,
                child: Image(
                    image: NetworkImage(team.flag), width: 40, height: 40),
              ),
              const SizedBox(width: 10),
              const Text(
                "N/A",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        if (team.over != null && team.over != "")
          Text(
            "${team.over} overs",
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          )
        else
          const Text(""),
      ],
    );
  }

  //Scorecard Widget
  Widget _buildScorecard(MatchDetails matchDetails) {
    if (matchDetails.scorecard.isEmpty) {
      return const Center(child: Text("No Scorecard Data Available"));
    }

    final scorecardList =
        matchDetails.scorecard.values.toList(); 

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(labelColor: Colors.orange, tabs: [
            Tab(text: scorecardList.first.team.name),
            Tab(text: scorecardList.last.team.name),
          ]),
          Expanded(
            child: TabBarView(
              children: [
                _buildTeamScorecard(scorecardList.first),
                _buildTeamScorecard(scorecardList.last),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamScorecard(TeamScorecard teamScorecard) {
    List<String> headers = ["Name", "Run(Balls)", "SR", "Out By"];
    List<String> gridData = [
      ...headers,
      for (var batsman in teamScorecard.batsmen) ...[
        batsman.name,
        "${batsman.run}(${batsman.ball})",
        batsman.strikeRate.toString(),
        batsman.outBy,
      ]
    ];
    List<String> headersBowler = ["Name", "Run(Over)", "W", "M"];
    List<String> gridDataBowler = [
      ...headersBowler,
      for (var bowler in teamScorecard.bowlers) ...[
        bowler.name,
        "${bowler.run}(${bowler.over})",
        bowler.wicket.toString(),
        bowler.maiden.toString(),
      ]
    ];
    return ListView(padding: const EdgeInsets.all(8), children: [
      //  Batsmen Section
      const Text("Batsmen",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // 4 Columns (Name, Runs, SR, Out By)
          //mainAxisExtent: 50,
          childAspectRatio: 1.5, // Adjust row height
        ),
        itemCount: gridData.length,
        itemBuilder: (context, index) {
          bool isHeader = index < headers.length;
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isHeader ? Colors.grey[200] : Colors.white,
              //border: Border.all(color: Colors.black),
            ),
            child: Text(
              gridData[index],
              style: TextStyle(
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
              overflow: TextOverflow.visible,
              maxLines: null,
            ),
          );
        },
      ),
      const SizedBox(height: 12),

      // Bowlers Section
      const Text("Bowlers",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, 
          childAspectRatio: 2, 
        ),
        itemCount: gridDataBowler.length,
        itemBuilder: (context, index) {
          bool isHeader = index < headersBowler.length;
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isHeader ? Colors.grey[200] : Colors.white,
              //border: Border.all(color: Colors.black),
            ),
            child: Text(
              gridDataBowler[index],
              style: TextStyle(
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
              overflow: TextOverflow.visible,
              maxLines: null,
            ),
          );
        },
      ),
    ]);
  }

  //Match Odds Widget
  Widget _buildMatchOdds(MatchDetails matchDetails) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Header Row
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Team", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Min Rate", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Max Rate", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Over", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(thickness: 1),

          // List of Match Odds
          Obx(() {
            if (apiService.matchDetails.isEmpty) {
              return const Center(child: Text("No Match Odds Data Available"));
            }
            final matchOdds = apiService.matchOdds;

            return SizedBox(
              height: 300, // Set a fixed height to prevent overflow issues
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: matchOdds.length,
                separatorBuilder: (context, index) => const Divider(
                    thickness: 1), // ✅ Horizontal line after each item
                itemBuilder: (context, index) {
                  final odds = matchOdds[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(odds.team.team),
                        Text(odds.overs.isNotEmpty
                            ? odds.overs[0].minRate.toString()
                            : "-"),
                        Text(odds.overs.isNotEmpty
                            ? odds.overs[0].maxRate.toString()
                            : "-"),
                        Text(odds.overs.isNotEmpty
                            ? odds.overs[0].overs.toString()
                            : "-"),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  // Commentary Widget
  Widget _buildCommentary(MatchDetails matchDetails) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              "Match Commentary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(thickness: 1),
            Expanded(
              // ✅ Moved inside Column
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const Divider(thickness: 1),
                itemCount: apiService.commentory.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final commentary = apiService.commentory[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              child: Text(commentary.data.wicket != ""
                                  ? "wt"
                                  : commentary.data.runs),
                            ),
                            const SizedBox(height: 8),
                            Text(commentary.data.overs.toString()),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                commentary.data.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              //const SizedBox(height: 8),
                              Text(
                                commentary.data.description,
                                softWrap: true,
                                maxLines: null,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

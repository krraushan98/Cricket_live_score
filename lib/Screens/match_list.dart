import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goto_assignment/Api/api_service.dart';
import 'package:goto_assignment/Screens/match_details.dart';

class MatchList extends StatefulWidget {
  const MatchList({super.key});

  @override
  State<MatchList> createState() => _MatchListState();
}

class _MatchListState extends State<MatchList> {
  final ApiService apiService = Get.put(ApiService());
  Timer? timer;

  void autoCall() {
    timer = Timer.periodic(
        const Duration(seconds: 10), (Timer t) => apiService.fetchMatches());
  }

  @override
  void initState() {
    super.initState();
    apiService.fetchMatches();
    autoCall();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], 
      appBar: AppBar(
        title: const Text('🏏 Live Match ',
            style: TextStyle(color: Colors.white, fontSize: 28)),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (apiService.isLoadingMatchList.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (apiService.matchList.isEmpty) {
          return const Center(
            child: Text(
              "No Matches Found",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: apiService.matchList.length,
          itemBuilder: (context, index) {
            final match = apiService.matchList[index];

            return GestureDetector(
              onTap: () {
                Get.to(() => MatchDetailPage(),
                    arguments: {'id': match.matchId, 'series': match.series});
                print("Match ID: ${match.matchId}");
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.orange.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Match Series Title
                      Text(
                        match.series,
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
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.schedule, color: Colors.orange.shade700),
                          const SizedBox(width: 10),
                          Text(match.matchTime ?? "TBA",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black54)),
                          const SizedBox(width: 60),
                          Text(
                            match.matchStatus ?? "Upcoming",
                            style: TextStyle(
                              fontSize: 14,
                              color: match.matchStatus == "Live"
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 60),
                          Icon(Icons.calendar_today,
                              color: Colors.orange.shade700),
                          const SizedBox(width: 5),
                          Text(
                            match.matchDate ?? "TBA",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildTeamColumn(match.teamA),
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
                            _buildTeamColumn(match.teamB),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Match Venue
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on, color: Colors.red),
                          Text(
                            match.venue ?? "Venue TBA",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildTeamColumn(team) {
    return Column(
      children: [
        Text(
          team.name.toUpperCase(),
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
        ),
        const SizedBox(height: 5),
        if (team.score?.totalScore != null && team.score?.totalScore != "")
          Text(
            "${team.score!.totalScore}/${team.score!.wicket}",
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          )
        else
          const Text(
            "N/A",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        if (team.score?.over != null && team.score?.over != "")
          Text(
            "${team.score!.over} overs",
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          )
        else
          const Text(""),
      ],
    );
  }
}

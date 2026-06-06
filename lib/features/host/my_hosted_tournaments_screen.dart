import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'manage_tournament_screen.dart';

class MyHostedTournamentsScreen extends StatelessWidget {
  const MyHostedTournamentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B2D),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("My Hosted Tournaments"),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tournaments')
            .where('createdBy', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final tournaments = snapshot.data!.docs;

          if (tournaments.isEmpty) {
            return const Center(
              child: Text(
                "No Hosted Tournaments",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: tournaments.length,
            itemBuilder: (context, index) {

              final data = tournaments[index].data()
                  as Map<String, dynamic>;
                  final cardType =
    data['cardType'] ?? 'Bronze';

final isHero =
    data['isHero'] ?? false;

              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF16163A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    if (isHero)
Container(
  margin: const EdgeInsets.only(bottom: 10),
  padding: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  ),
  decoration: BoxDecoration(
    color: Colors.purple,
    borderRadius: BorderRadius.circular(20),
  ),
  child: const Text(
    "🔥 HERO TOURNAMENT",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
),

Container(
  margin: const EdgeInsets.only(bottom: 10),
  padding: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  ),
  decoration: BoxDecoration(
    color: cardType == 'Bronze'
        ? Colors.brown
        : cardType == 'Silver'
            ? Colors.grey
            : Colors.amber,
    borderRadius: BorderRadius.circular(20),
  ),
  child: Text(
    "$cardType CARD",
    style: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
),

if ((data['bannerImage'] ?? '').toString().isNotEmpty)
ClipRRect(
  borderRadius: BorderRadius.circular(15),
  child: Image.network(
    data['bannerImage'],
    height: 170,
    width: double.infinity,
    fit: BoxFit.cover,
  ),
),

const SizedBox(height: 12),

                    Text(
                      data['title'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "🎮 ${data['mode']}",
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                    Text(
                      "💰 Entry Fee: ₹${data['entryFee']}",
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                    Text(
  "🏆 Prize Pool: ₹${data['prizePool']}",
  style: const TextStyle(
    color: Colors.white70,
  ),
),

Text(
  "🎯 Reward: ${data['rewardType']}",
  style: const TextStyle(
    color: Colors.white70,
  ),
),

                    Text(
                      "👥 ${data['joinedPlayers']} / ${data['maxPlayers']}",
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                    Text(
                      "⏰ ${data['matchTime']}",
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 10),

LinearProgressIndicator(
  value: (data['joinedPlayers'] ?? 0) /
      (data['maxPlayers'] ?? 1),
),
                    Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  ),
  decoration: BoxDecoration(
    color: data['status'] == 'completed'
        ? Colors.green.withOpacity(0.2)
        : Colors.orange.withOpacity(0.2),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Text(
    data['status'] == 'completed'
        ? "🏁 Completed"
        : "🟠 Upcoming",
    style: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
),

const SizedBox(height: 12),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ManageTournamentScreen(
        tournamentId: tournaments[index].id,
      ),
    ),
  );
},
                        child: const Text(
                          "Manage Tournament",
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
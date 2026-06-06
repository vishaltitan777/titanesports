import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class MyMatchesScreen extends StatelessWidget {
  const MyMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B2D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("My Matches"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tournaments')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final tournaments = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: tournaments.length,
            itemBuilder: (context, index) {
              final tournament = tournaments[index];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('tournaments')
                    .doc(tournament.id)
                    .collection('participants')
                    .doc(user.uid)
                    .get(),
                builder: (context, participantSnapshot) {
                  if (!participantSnapshot.hasData) {
                    return const SizedBox();
                  }

                  if (!participantSnapshot.data!.exists) {
                    return const SizedBox();
                  }

                  final data =
                      tournament.data() as Map<String, dynamic>;
return Container(
  margin: const EdgeInsets.only(bottom: 20),
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: const Color(0xFF141B45),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: Colors.blueAccent.withOpacity(.3),
    ),
  ),
  child: Column(
    children: [

      Row(
        children: [

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              data['cardType'] ?? 'Bronze',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Spacer(),

          Text(
            data['mode'] ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          Text(
            "${data['joinedPlayers']}/${data['maxPlayers']}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

      const SizedBox(height: 20),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          rewardBox(
            "Prize Pool",
            "₹${data['prizePool']}",
          ),

          rewardBox(
            data['rewardType'] == "Per Kill"
                ? "Per Kill"
                : "Highest Kill",
            data['rewardType'] == "Per Kill"
                ? "₹${data['perKillReward'] ?? 0}"
                : "₹${data['highestKillReward'] ?? 0}",
          ),

          rewardBox(
            "Entry Fee",
            "₹${data['entryFee']}",
          ),
        ],
      ),

      const SizedBox(height: 20),

      const SizedBox(height: 15),

Row(
  children: [
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "Room ID : ${data['roomReleased'] == true ? data['roomId'] : 'Not Released'}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Password : ${data['roomReleased'] == true ? data['roomPassword'] : 'Not Released'}",
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    ),
  ],
),

const SizedBox(height: 15),

      Row(
        children: [

          Expanded(
            child: Text(
              data['matchTime'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          data['roomReleased'] == true
              ? ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                        text:
                            "ID:${data['roomId']} PASS:${data['roomPassword']}",
                      ),
                    );
                  },
                  child: const Text("Copy Room"),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(.2),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Waiting Host",
                    style: TextStyle(
                      color: Colors.orange,
                    ),
                  ),
                ),
        ],
      ),
    ],
  ),
);
                  },
              );
            },
          );
        },
      ),
    );
  }
  Widget rewardBox(
  String title,
  String value,
) {
  return Container(
    width: 90,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white10,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 11,
          ),
        ),
      ],
    ),
  );
}
}
 
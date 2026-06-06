import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ManageTournamentScreen extends StatefulWidget {
  final String tournamentId;

  const ManageTournamentScreen({
    super.key,
    required this.tournamentId,
  });

  @override
  State<ManageTournamentScreen> createState() =>
      _ManageTournamentScreenState();
}

class _ManageTournamentScreenState
    extends State<ManageTournamentScreen> {

  final roomIdController =
      TextEditingController();

  final roomPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B2D),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Manage Tournament"),
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tournaments')
          .doc(widget.tournamentId) 
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data =
              snapshot.data!.data()
                  as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  data['title'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  "Players: ${data['joinedPlayers']} / ${data['maxPlayers']}",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 25),

const Text(
  "Participants",
  style: TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 10),

Expanded(
  child: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('tournaments')
        .doc(widget.tournamentId)
        .collection('participants')
        .snapshots(),
    builder: (context, participantSnapshot) {

      if (!participantSnapshot.hasData) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      final participants =
          participantSnapshot.data!.docs;

      if (participants.isEmpty) {
        return const Text(
          "No Participants Yet",
          style: TextStyle(color: Colors.white70),
        );
      }

      return ListView.builder(
        itemCount: participants.length,
        itemBuilder: (context, index) {

          final participant =
              participants[index].data()
                  as Map<String, dynamic>;

          return ListTile(
            leading: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            title: Text(
              participant['name'] ?? 'Player',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          );
        },
      );
    },
  ),
),

                const SizedBox(height: 20),

TextField(
  controller: roomIdController,
  decoration: InputDecoration(
    hintText: "Room ID",
    filled: true,
    fillColor: const Color(0xFF16163A),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),
),

const SizedBox(height: 15),

TextField(
  controller: roomPasswordController,
  decoration: InputDecoration(
    hintText: "Room Password",
    filled: true,
    fillColor: const Color(0xFF16163A),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),
),

const SizedBox(height: 15),

SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () async {

  await FirebaseFirestore.instance
      .collection('tournaments')
      .doc(widget.tournamentId)
      .update({

    'roomId':
        roomIdController.text,

    'roomPassword':
        roomPasswordController.text,

    'roomReleased': true,
  });

  ScaffoldMessenger.of(context)
      .showSnackBar(
    const SnackBar(
      content:
          Text("Room Released"),
    ),
  );
},
    child: const Text(
      "Release Room",
    ),
  ),
),
const SizedBox(height: 15),

SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () async {

      await FirebaseFirestore.instance
    .collection('tournaments')
    .doc(widget.tournamentId)
    .update({
  'status': 'completed',
});

final tournamentDoc =
    await FirebaseFirestore.instance
        .collection('tournaments')
        .doc(widget.tournamentId)
        .get();

final tournamentData =
    tournamentDoc.data() as Map<String, dynamic>;

final hostUid =
    tournamentData['createdBy'];

final userRef =
    FirebaseFirestore.instance
        .collection('users')
        .doc(hostUid);

await userRef.update({
  'completedTournaments':
      FieldValue.increment(1),
});
final updatedHost =
    await userRef.get();

final hostData =
    updatedHost.data()
        as Map<String, dynamic>;

final completed =
    hostData['completedTournaments'] ?? 0;

String eligibleBadge = 'None';

if (completed >= 1500) {
  eligibleBadge = 'Titan';
}
else if (completed >= 500) {
  eligibleBadge = 'Gold';
}
else if (completed >= 250) {
  eligibleBadge = 'Silver';
}
else if (completed >= 50) {
  eligibleBadge = 'Bronze';
}

await userRef.update({
  'badgeEligible': eligibleBadge,
});


      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Tournament Completed"),
        ),
      );
    },
    child: const Text(
      "🏁 Complete Tournament",
    ),
  ),
),
              ],
            ),
          );
        },
      ),
    );
  }
}
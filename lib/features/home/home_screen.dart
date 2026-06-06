import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../matches/my_matches_screen.dart';
import '../wallet/wallet_screen.dart';
import '../host/host_profile_screen.dart';
import '../tournaments/host_tournament_screen.dart';
import '../profile/profile_screen.dart';
import '../admin/admin_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> createUserIfNotExists() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    final doc = await docRef.get();

    if (!doc.exists) {
        final titanId =
    "TTN${DateTime.now().millisecondsSinceEpoch}";
      await docRef.set({
  'name': user.displayName ?? 'Player',
  'email': user.email,
  'wallet': 0,
  'level': 1,
  'xp': 0,
  'matchesPlayed': 0,
  'wins': 0,
  'titanId': titanId,
    'role': 'player',
    'ign': '',
    'ffUid': '',

  'followers': 0,
  'rating': 0,
  'hostedTournaments': 0,
  'completedTournaments': 0,
  'badge': 'None',
  'hostBadge': 'None',
  'badgeEligible': 'None',

  'createdAt': FieldValue.serverTimestamp(),
});

      print("USER CREATED IN FIRESTORE");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    createUserIfNotExists();

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B2D),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "PROJECT TITAN",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
            IconButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
    HostTournamentScreen(),
      ),
    );
  },
  icon: const Icon(Icons.add),
),
            IconButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const WalletScreen(),
      ),
    );
  },
  icon: const Icon(Icons.account_balance_wallet),
),
  IconButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const MyMatchesScreen(),
        ),
      );
    },
    icon: const Icon(Icons.emoji_events),
  ),
  IconButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfileScreen(),
      ),
    );
  },
  icon: const Icon(Icons.edit),
),
  IconButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HostProfileScreen(),
      ),
    );
  },
  icon: const Icon(Icons.person),
),
IconButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AdminScreen(),
      ),
    );
  },
  icon: const Icon(Icons.admin_panel_settings),
),

  IconButton(
   onPressed: () async {
  await FirebaseAuth.instance.signOut();
},
    icon: const Icon(Icons.logout),
  ),
],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Welcome ${user?.displayName ?? "Player"}",
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 25),


           

const SizedBox(height: 15),

Expanded(
  child: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('tournaments')
        .where('status', isEqualTo: 'upcoming')
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
            "No tournaments available",
            style: TextStyle(color: Colors.white),
          ),
        );
      }

      return ListView.builder(
        itemCount: tournaments.length,
        itemBuilder: (context, index) {

          final data = tournaments[index].data()
              as Map<String, dynamic>;

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

                Text(
                  data['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "🎮 ${data['game']}",
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
                  "🎯 Per Kill: ₹${data['perKill']}",
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "👥 ${data['joinedPlayers']} / ${data['maxPlayers']} Players",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {

  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) return;

  final userDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid)
      .get();

  final userData =
      userDoc.data() as Map<String, dynamic>;

  final wallet = userData['wallet'] ?? 0;

  final entryFee = data['entryFee'] ?? 0;

  final tournamentId = tournaments[index].id;
  final joinedPlayers = data['joinedPlayers'] ?? 0;
final maxPlayers = data['maxPlayers'] ?? 0;

  final participantRef = FirebaseFirestore.instance
      .collection('tournaments')
      .doc(tournamentId)
      .collection('participants')
      .doc(currentUser.uid);

  final alreadyJoined = await participantRef.get();

  if (alreadyJoined.exists) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Already joined"),
      ),
    );
    return;
  }

  if (wallet < entryFee) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Insufficient Balance"),
      ),
    );
    return;
  }
  if (joinedPlayers >= maxPlayers) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Tournament Full"),
    ),
  );
  return;
}

  await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid)
      .update({
    'wallet': wallet - entryFee,
  });
  await FirebaseFirestore.instance
    .collection('users')
    .doc(currentUser.uid)
    .collection('transactions')
    .add({
  'amount': -entryFee,
  'type': 'entry_fee',
  'title': 'Tournament Entry',
  'createdAt': FieldValue.serverTimestamp(),
});

 await participantRef.set({
  'uid': currentUser.uid,
  'name': currentUser.displayName,
  'email': currentUser.email,

  'ign': userData['ign'] ?? '',
  'ffUid': userData['ffUid'] ?? '',

  'joinedAt': FieldValue.serverTimestamp(),
});

  await FirebaseFirestore.instance
      .collection('tournaments')
    .doc(tournamentId)
      .update({
    'joinedPlayers': FieldValue.increment(1),
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Tournament Joined Successfully"),
    ),
  );
},
child: Text(
  (data['joinedPlayers'] ?? 0) >=
          (data['maxPlayers'] ?? 0)
      ? "FULL"
      : "Join Now",
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
),
          ],
        ),
      ),
    );
  }
}
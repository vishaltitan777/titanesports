import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../host/my_hosted_tournaments_screen.dart';

class HostProfileScreen extends StatelessWidget {
  const HostProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B2D),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Host Profile"),
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data =
              snapshot.data!.data() as Map<String, dynamic>;

          final followers = data['followers'] ?? 0;
          final rating = data['rating'] ?? 0;
          final hosted = data['hostedTournaments'] ?? 0;
          final completed = data['completedTournaments'] ?? 0;
          final hostBadge =
    data['hostBadge'] ?? 'None';
    final badgeEligible =
    data['badgeEligible'] ?? 'None';

          return SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
              children: [

                const CircleAvatar(
                  radius: 45,
                  child: Icon(
                    Icons.person,
                    size: 50,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  user.displayName ?? "Host",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
  "Host Badge: $hostBadge",
  
  style: const TextStyle(
    color: Colors.amber,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),
const SizedBox(height: 8),

Text(
  "Eligible For: $badgeEligible",
  style: const TextStyle(
    color: Colors.green,
    fontSize: 16,
  ),
),

                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16163A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [

                      Text(
                        "Followers: $followers",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Rating: $rating ⭐",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Hosted Tournaments: $hosted",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),

Text(
  "Titan ID: ${data['titanId'] ?? ''}",
  style: const TextStyle(
    color: Colors.white,
    fontSize: 18,
  ),
),

                      const SizedBox(height: 10),

                      Text(
                        "Completed Tournaments: $completed",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 15),

LinearProgressIndicator(
  value: completed >= 50 ? 1 : completed / 50,
),
const SizedBox(height: 5),

Text(
  "Bronze Badge Progress: $completed / 50",
  style: const TextStyle(
    color: Colors.white70,
  ),
),
                      const SizedBox(height: 10),

if (hostBadge == 'None')
  const Text(
    "Bronze Card: Locked 🔒",
    style: TextStyle(
      color: Colors.grey,
      fontSize: 18,
    ),
  ),

if (hostBadge == 'Bronze')
  const Text(
    "Bronze Card: Unlimited ♾️",
    style: TextStyle(
      color: Colors.orange,
      fontSize: 18,
    ),
  ),

if (hostBadge == 'Silver')
  const Text(
    "Silver Card Unlocked 🥈",
    style: TextStyle(
      color: Colors.grey,
      fontSize: 18,
    ),
  ),

if (hostBadge == 'Gold')
  const Text(
    "Gold Card Unlocked 🥇",
    style: TextStyle(
      color: Colors.amber,
      fontSize: 18,
    ),
  ),

if (hostBadge == 'Titan')
  const Text(
    "Titan Card Unlocked 👑",
    style: TextStyle(
      color: Colors.purpleAccent,
      fontSize: 18,
    ),
  ),

const SizedBox(height: 10),

Text(
  hostBadge == 'Titan'
      ? "Silver Card: 1 Available"
      : "Silver Card: Locked 🔒",
  style: TextStyle(
    color: hostBadge == 'Titan'
        ? Colors.grey.shade300
        : Colors.grey,
    fontSize: 18,
  ),
),

const SizedBox(height: 10),

Text(
  hostBadge == 'Titan'
      ? "Gold Card: 1 Available"
      : "Gold Card: Locked 🔒",
  style: TextStyle(
    color: hostBadge == 'Titan'
        ? Colors.amber
        : Colors.grey,
    fontSize: 18,
  ),
),
SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const MyHostedTournamentsScreen(),
        ),
      );
    },
    child: const Text(
      "My Hosted Tournaments",
    ),
  ),
),                    ],
                  ),
                ),
              ],
            ),
          ),
        );
        },
      ),
    );
  }
}
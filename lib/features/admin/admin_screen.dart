import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B2D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Admin Panel"),
      ),
       body: StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('users')
      .where('badgeEligible', isNotEqualTo: 'None')
      .snapshots(),
  builder: (context, snapshot) {

    if (!snapshot.hasData) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final hosts = snapshot.data!.docs;

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: hosts.length,
      itemBuilder: (context, index) {

        final data =
            hosts[index].data()
                as Map<String, dynamic>;

        final uid = hosts[index].id;

        return Card(
          color: const Color(0xFF16163A),
          margin:
              const EdgeInsets.only(bottom: 15),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  data['name'] ?? 'Host',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Eligible: ${data['badgeEligible']}",
                  style: const TextStyle(
                    color: Colors.green,
                  ),
                ),

                Text(
                  "Current Badge: ${data['hostBadge'] ?? 'None'}",
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {

                      await FirebaseFirestore
                          .instance
                          .collection('users')
                          .doc(uid)
                          .update({

                        'hostBadge':
                            data['badgeEligible'],
                      });

                      ScaffoldMessenger.of(
                              context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Badge Approved",
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Approve ${data['badgeEligible']}",
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    },
),
    );
  }
}
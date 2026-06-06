import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  final ignController =
      TextEditingController();

  final ffUidController =
      TextEditingController();

  bool loaded = false;

  @override
  Widget build(BuildContext context) {

    final user =
        FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B2D),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Profile"),
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
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

          if (!loaded) {
            ignController.text =
                data['ign'] ?? '';

            ffUidController.text =
                data['ffUid'] ?? '';

            loaded = true;
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                TextField(
                  controller: ignController,
                  decoration: InputDecoration(
                    hintText: "IGN",
                    filled: true,
                    fillColor:
                        const Color(0xFF16163A),
                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                              15),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller:
                      ffUidController,
                  decoration: InputDecoration(
                    hintText:
                        "Free Fire UID",
                    filled: true,
                    fillColor:
                        const Color(0xFF16163A),
                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                              15),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {

                      await FirebaseFirestore
                          .instance
                          .collection('users')
                          .doc(user.uid)
                          .update({

                        'ign':
                            ignController.text,

                        'ffUid':
                            ffUidController.text,
                      });

                      ScaffoldMessenger.of(
                              context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Profile Updated",
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Save Changes",
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
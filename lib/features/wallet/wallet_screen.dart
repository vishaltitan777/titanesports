import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  Future<void> addMoney(int amount) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({
      'wallet': FieldValue.increment(amount),
    });
    await FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .collection('transactions')
    .add({
  'amount': amount,
  'type': 'deposit',
  'title': 'Money Added',
  'createdAt': FieldValue.serverTimestamp(),
});
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B2D),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Wallet"),
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

          final wallet = data['wallet'] ?? 0;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF8B5CF6),
                        Color(0xFF5B21B6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [

                      const Text(
                        "Current Balance",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "₹$wallet",
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () async {
                    await addMoney(50);
                  },
                  child: const Text("Add ₹50"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    await addMoney(100);
                  },
                  child: const Text("Add ₹100"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    await addMoney(500);
                  },
                  child: const Text("Add ₹500"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    await addMoney(1000);
                  },
                  child: const Text("Add ₹1000"),
                ),
                const SizedBox(height: 30),

const Align(
  alignment: Alignment.centerLeft,
  child: Text(
    "Transaction History",
    style: TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
),

const SizedBox(height: 15),

Expanded(
  child: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .snapshots(),
    builder: (context, snapshot) {

      if (!snapshot.hasData) {
        return const SizedBox();
      }

      final transactions = snapshot.data!.docs;

      return ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {

          final tx = transactions[index].data()
              as Map<String, dynamic>;

          return Card(
            color: const Color(0xFF16163A),
            child: ListTile(
              title: Text(
                tx['title'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                tx['type'] ?? '',
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
              trailing: Text(
                "₹${tx['amount']}",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      );
    },
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
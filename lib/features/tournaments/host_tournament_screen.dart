import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HostTournamentScreen extends StatefulWidget {
  const HostTournamentScreen({super.key});

  @override
  State<HostTournamentScreen> createState() =>
      _HostTournamentScreenState();
}

class _HostTournamentScreenState
    extends State<HostTournamentScreen> {

  final titleController = TextEditingController();
  final matchTimeController = TextEditingController();
  final bannerController = TextEditingController();

bool isHeroTournament = false;
  String selectedMode = "BR Squad";
int selectedEntryFee = 50;

final modes = [
  "BR Solo",
  "BR Duo",
  "BR Squad",
  "CS",
  "Lone Wolf",
];

final entryFees = [
  10,
  20,
  30,
  40,
  50,
  60,
  70,
  80,
  90,
  100,
];
Future<void> createTournament() async {
  final user = FirebaseAuth.instance.currentUser;

if (user == null) return;

final userDoc = await FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .get();

final userData =
    userDoc.data() as Map<String, dynamic>;

final hostBadge =
    userData['hostBadge'] ?? 'None';

if (hostBadge == 'None') {

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        "Get Bronze Badge To Host Paid Tournaments",
      ),
    ),
  );

  return;
}


    await FirebaseFirestore.instance
    .collection('tournaments')
    .add({

  'title': titleController.text,

  'game': 'Free Fire',

  'mode': selectedMode,

  'hostBadge': hostBadge,

'cardType': hostBadge,

  'rewardType': rewardType,
'perKillReward': getPerKillReward(),

  'entryFee': selectedEntryFee,

  'prizePool': getPrizePool(),

  'highestKillReward': getHighestKillReward(),

  'hostReward': getHostReward(),

  'maxPlayers': getMaxPlayers(),

  'joinedPlayers': 0,

  'matchTime': matchTimeController.text,

  'status': 'upcoming',

  'createdBy': user.uid,

  'roomId': '',

  'roomPassword': '',

  'roomReleased': false,
  'bannerImage': bannerController.text.trim(),
'isHero': isHeroTournament,

  'createdAt': FieldValue.serverTimestamp(),
});


    final userRef = FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid);


print("BEFORE INCREMENT");

await userRef.update({
  'hostedTournaments': FieldValue.increment(1),
});

print("AFTER INCREMENT");

final refreshedUserDoc =
    await userRef.get();

final refreshedUserData =
    refreshedUserDoc.data()
        as Map<String, dynamic>;

final hosted =
    refreshedUserData['hostedTournaments'] ?? 0;


print("ELIGIBLE BADGE UPDATED");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Tournament Submitted"),
      ),
    );

    Navigator.pop(context);
  }
int getMaxPlayers() {
  switch (selectedMode) {
   case "BR Duo":
  return 48;

case "BR Solo":
  return 48;

case "BR Squad":
  return 48;
    case "CS":
      return 8;
    case "Lone Wolf":
      return 2;
    default:
      return 50;
  }
}
String rewardType = "Highest Kill";

int getPrizePool() {
  return selectedEntryFee * 10;
}

int getHighestKillReward() {
  return selectedEntryFee * 5;
}
int getHostReward() {

  switch (selectedEntryFee) {

    case 10:
      return 20;

    case 20:
      return 30;

    case 30:
      return 40;

    case 40:
      return 50;

    case 50:
      return 60;

    case 60:
      return 70;

    case 70:
      return 80;

    case 80:
      return 90;

    case 90:
      return 100;

    case 100:
      return 110;

    default:
      return 20;
  }
}
final rewardTypes = [
  "Highest Kill",
  "Per Kill",
];
int getPerKillReward() {

  if (selectedMode != "BR Solo") {
    return 0;
  }

  switch (selectedEntryFee) {

    case 10:
      return 1;
    case 20:
      return 2;
    case 30:
      return 3;
    case 40:
      return 4;
    case 50:
      return 5;
    case 60:
      return 6;
    case 70:
      return 7;
    case 80:
      return 8;
    case 90:
      return 9;
    case 100:
      return 10;

    default:
      return 1;
  }
}

  Widget buildField(
    String hint,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: const Color(0xFF16163A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B2D),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Host Tournament"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildField(
  "Tournament Title",
  titleController,
),

buildField(
  "Match Time",
  matchTimeController,
),
buildField(
  "Banner Image URL",
  bannerController,
),

SwitchListTile(
  title: const Text(
    "Set As Hero Tournament",
    style: TextStyle(color: Colors.white),
  ),
  value: isHeroTournament,
  onChanged: (value) {
    setState(() {
      isHeroTournament = value;
    });
  },
),

const SizedBox(height: 15),

            DropdownButtonFormField<String>(
  value: selectedMode,
  dropdownColor: const Color(0xFF16163A),
  style: const TextStyle(color: Colors.white),
  decoration: const InputDecoration(
    labelText: "Mode",
    labelStyle: TextStyle(color: Colors.white),
  ),
  items: modes.map((mode) {
    return DropdownMenuItem(
      value: mode,
      child: Text(mode),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      selectedMode = value!;
    });
  },
),

const SizedBox(height: 15),

DropdownButtonFormField<int>(
  value: selectedEntryFee,
  dropdownColor: const Color(0xFF16163A),
  style: const TextStyle(color: Colors.white),
  decoration: const InputDecoration(
    labelText: "Entry Fee",
    labelStyle: TextStyle(color: Colors.white),
  ),
  items: entryFees.map((fee) {
    return DropdownMenuItem(
      value: fee,
      child: Text("₹$fee"),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      selectedEntryFee = value!;
    });
  },
),

const SizedBox(height: 15),
if (selectedMode == "BR Solo")
DropdownButtonFormField<String>(
  value: rewardType,
  dropdownColor: const Color(0xFF16163A),
  style: const TextStyle(color: Colors.white),
  decoration: const InputDecoration(
    labelText: "Reward Type",
    labelStyle: TextStyle(color: Colors.white),
  ),
  items: rewardTypes.map((type) {
    return DropdownMenuItem(
      value: type,
      child: Text(type),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      rewardType = value!;
    });
  },
),

const SizedBox(height: 15),

Container(
  width: double.infinity,
  padding: const EdgeInsets.all(15),
  decoration: BoxDecoration(
    color: const Color(0xFF16163A),
    borderRadius: BorderRadius.circular(15),
  ),
  child: Column(

    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
  Text(
    "Players: ${getMaxPlayers()}",
    style: const TextStyle(color: Colors.white),
  ),

  const SizedBox(height: 8),

  Text(
    "Prize Pool: ₹${getPrizePool()}",
    style: const TextStyle(color: Colors.white),
  ),

  const SizedBox(height: 8),

  Text(
  rewardType == "Per Kill"
      ? "Per Kill: ₹${getPerKillReward()}"
      : "Highest Kill Reward: ₹${getHighestKillReward()}",
  style: const TextStyle(color: Colors.white),
),

  const SizedBox(height: 8),

  Text(
    "Host Reward: ₹${getHostReward()}",
    style: const TextStyle(color: Colors.green),
  ),
],
  ),
),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: createTournament,
                child: const Text(
                  "Create Tournament",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
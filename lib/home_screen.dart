// here show if the the no contacts then show text
// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:my_people/add_friend_screen.dart';
import 'package:my_people/constants.dart';
import 'package:my_people/models/friend_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FriendModel> friendsList = [];
  Box<FriendModel>? box;

  @override
  void initState() {
    box = Hive.box<FriendModel>(Constants().friendsBox);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFriendScreen()),
          );
        },
        backgroundColor: Colors.amber,
        child: Icon(Icons.add, color: Colors.black),
      ),
      body: ValueListenableBuilder(
        valueListenable: box!.listenable(),
        builder: (context, _, _) {
          friendsList = box!.values.toList().cast<FriendModel>();
          if (friendsList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: 0.6, // Value between 0.0 and 1.0
                    child: Image.asset(
                      'assets/images/delete.png',
                      height: 150,
                      width: 150,
                      alignment: Alignment.center,
                    ),
                  ),
                  Opacity(
                    opacity: 0.6,
                    child: Text(
                      'No Contacts Found',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: friendsList.length,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            itemBuilder: (context, index) {
              final friend = friendsList[index];
              return GestureDetector(
                onTap: () => _alertDialog(context, friend),
                child: Card(
                  elevation: 6,
                  shadowColor: Colors.amber.withOpacity(0.3),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.amber.shade200,
                      backgroundImage: friend.image == null
                          ? AssetImage(Constants().logo) as ImageProvider
                          : MemoryImage(friend.image!),
                    ),
                    title: Text(
                      friend.name ?? '-',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      friend.mobilePhone ?? '-',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.phone,
                            color: Color(0xFF2196F3),
                          ),
                          iconSize: 26,
                          onPressed: () =>
                              callFriend(friend.mobilePhone ?? '-'),
                          tooltip: 'Call',
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          iconSize: 26,
                          onPressed: () => alertDeletFriend(index),
                          tooltip: 'Delete',
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _alertDialog(BuildContext context, FriendModel friend) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.person, color: Colors.amber, size: 28),
              SizedBox(width: 8),
              Text(
                'Friend Information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: SizedBox(
            height: 200,
            width: 250,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Colors.amber, thickness: 1),
                  const SizedBox(height: 10),
                  _infoRow("Name", friend.name),
                  _infoRow("Father Name", friend.fatherName),
                  _infoRow("Mobile Phone", friend.mobilePhone),
                  _infoRow("Address", friend.address),
                  _infoRow("Memories", friend.descreption),
                ],
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.amber.shade700,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value?.isNotEmpty == true ? value! : '-',
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> callFriend(String number) async {
    // try {
    //   if (!await launchUrlString('tel:$number')) {
    //     throw Exception('Could not launch');
    //   }
    // } catch (e) {
    //   print('.......This is error: $e');
    // }

    try {
      String url = 'tel: $number';
      if (!await launchUrl(Uri.parse(url))) ;
    } catch (e) {
      print('.........This is error: $e');
    }
  }

  Future<void> alertDeletFriend(index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 28),
              SizedBox(width: 8),
              Text(
                'Delete Contact',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete this friend?',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => deleteMyFriend(index),
              child: const Text('Yes'),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.amber),
                foregroundColor: Colors.amber.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteMyFriend(int index) async {
    Navigator.of(context).pop();
    try {
      if (box == null) return;

      final deletedFriend = box!.getAt(index);
      box!.deleteAt(index);

      // ✅ Show confirmation Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin:  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          duration:  Duration(seconds: 3),
          content: Row(
            children: [
               Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 22,
              ),
               SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${deletedFriend?.name ?? 'Friend'} has been deleted.',
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      // Optional: error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          duration: const Duration(seconds: 2),
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 22),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Failed to delete contact.',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

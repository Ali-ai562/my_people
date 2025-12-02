// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_people/constants.dart';
import 'package:my_people/models/friend_model.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final _formkey = GlobalKey<FormState>();
  Uint8List? realImage;

  final nameCtrl = TextEditingController();
  final fatherNameCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final memoriesCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Add Friend'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                spacing: 20,
                children: [
                  InkWell(
                    onTap: () {
                      // pickFriendImage();
                      showImagePickSheet();
                    },
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: realImage == null
                          ? null
                          : MemoryImage(realImage!),
                      backgroundColor: Colors.transparent,
                      child: realImage == null
                          ? Image.asset('assets/images/man.png', scale: 1)
                          : null,
                    ),
                  ),
                  SizedBox(height: 18),
                  TextFormField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person, color: Colors.black),
                      fillColor: Color(0xFFFBE9E7),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return '*Please fill this field ';
                      }
                      if (value!.length <= 3) {
                        return '*Please add the correct name ';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: fatherNameCtrl,
                    decoration: InputDecoration(
                      hintText: 'Father Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person, color: Colors.black),
                      fillColor: Color(0xFFFBE9E7),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return '*Please fill this field ';
                      }
                      if (value!.length == 2) {
                        return '*Please add the correct name ';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: mobileCtrl,
                    decoration: InputDecoration(
                      hintText: 'Moblie Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone, color: Colors.black),
                      fillColor: Color(0xFFFBE9E7),
                      filled: true,
                    ),
                    autovalidateMode: AutovalidateMode.onUnfocus,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return '*Please fill this field ';
                      }
                      if (value!.length != 11) {
                        return '*Please add the correct number ';
                      }
                      if (!value.startsWith('03')) {
                        return '*Please add the correct number ';
                      }
                      return null;
                    },

                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  TextFormField(
                    controller: addressCtrl,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Address',
                      border: OutlineInputBorder(),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 70.0),
                        child: Icon(Icons.add_home, color: Colors.black),
                      ),
                      fillColor: Color(0xFFFBE9E7),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return '*Please fill this field ';
                      }
                      if (value!.length <= 5) {
                        return '*Please add the correct address';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: memoriesCtrl,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Memories',
                      border: OutlineInputBorder(),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 70.0, left: 3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Icon(Icons.article, color: Colors.black)],
                        ),
                      ),
                      fillColor: Color(0xFFFBE9E7),
                      filled: true,
                    ),
                    // validator: (value) {
                    //   if (value != null && value.isEmpty) {
                    //     return '*Please fill this field ';
                    //   }
                    //   if (value!.length <= 5) {
                    //     return '*Please add the correct memoris ';
                    //   }
                    // },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        final friendName = nameCtrl.text.trim().isEmpty
                            ? 'Friend'
                            : nameCtrl.text.trim();

                        // ✅ Show success snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.green,
                            duration:  Duration(seconds: 3),
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    '$friendName added successfully!',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                        // ✅ Save the friend
                        FriendModel friendModel = FriendModel(
                          realImage,
                          nameCtrl.text,
                          fatherNameCtrl.text,
                          mobileCtrl.text,
                          addressCtrl.text,
                          memoriesCtrl.text,
                        );

                        saveFriends(friendModel);
                        Navigator.of(context).pop();

                        // ✅ Navigate back after a short delay
                        // Future.delayed(const Duration(milliseconds: 800), () {
                        // });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      fixedSize: Size(
                        MediaQuery.sizeOf(context).width / 1.8,
                        45,
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void pickFriendImage(ImageSource imageSource) async {
    XFile? friendImage = await ImagePicker().pickImage(source: imageSource);

    if (friendImage == null) {
      return;
    } else {
      realImage = await friendImage.readAsBytes();
      setState(() {});
    }
  }

  void showImagePickSheet() async {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),

      context: context,
      builder: (context) {
        return Container(
          height: 80,
          decoration: BoxDecoration(
            color: Color(0xFFFBE9E7),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          child: Row(
            spacing: 50,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  pickFriendImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(Icons.camera_alt),
                    Image.asset(
                      'assets/images/camera.png',
                      height: 30,
                      width: 30,
                    ),
                    Text(
                      'Camera',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  pickFriendImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(Icons.photo_album),
                    Image.asset(
                      'assets/images/gallery.png',
                      height: 32,
                      width: 32,
                    ),
                    Text(
                      'Gallery',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future saveFriends(FriendModel friendModel) async {
    try {
      final box = await Hive.openBox<FriendModel>(Constants().friendsBox);
      int friendIndex = await box.add(friendModel);
      setState(() {
        realImage = null;
        nameCtrl.clear();
        fatherNameCtrl.clear();
        mobileCtrl.clear();
        addressCtrl.clear();
        memoriesCtrl.clear();
      });

      print('........ This is friend Index: $friendIndex');
    } catch (error) {
      print('...............This is error; $error');
    }
  }
}

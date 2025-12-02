import 'dart:typed_data';

import 'package:hive_ce/hive.dart';
part 'friend_model.g.dart';

@HiveType(typeId: 0)
class FriendModel {
  @HiveField(0)
  Uint8List? image;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? fatherName;

  @HiveField(3)
  String? mobilePhone;

  @HiveField(4)
  String? address;

  @HiveField(5)
  String? descreption;

  FriendModel(
    this.image,
    this.name,
    this.fatherName,
    this.mobilePhone,
    this.address,
    this.descreption,
  );
}

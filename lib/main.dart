
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:my_people/constants.dart';
import 'package:my_people/models/friend_model.dart';
import 'package:my_people/splash_screen.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);
  Hive.registerAdapter(FriendModelAdapter());

  await Hive.openBox<FriendModel>(Constants().friendsBox);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My People',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: SplashScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:musicplayer/view/music_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Musify",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true 
      ),
      home: MusicPlayer(),
      debugShowCheckedModeBanner: false,
    );
  }
}
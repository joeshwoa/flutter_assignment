import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_assignment/firebase/firebase_services.dart';
import 'package:flutter_assignment/model/post.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  List<Post> posts = [];

  String type = 'hot';

  final FirebaseService firebaseService = FirebaseService();

  void fetchAndStorePosts() async {
    try {
      // Fetch posts from FirebaseService
      List<Post> fetchedPosts = [];
      if(posts.isNotEmpty) {
        fetchedPosts = await firebaseService.fetchPosts(type, posts.last.name);
      } else {
        fetchedPosts = await firebaseService.fetchPosts(type, '');
      }
      // Store fetched posts in Firebase using FirebaseService
      await firebaseService.storePosts(fetchedPosts);
      // Update the UI with the fetched posts
      posts.addAll(fetchedPosts);
    } catch (e) {
      log('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lepaya Assignment',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lepaya Assignment'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              Text('Hey there! Welcome to the Lepaya Flutter assignment.'),
              SizedBox(height: 16),
              Text(
                'Check the `readme` of this repository for the instructions.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

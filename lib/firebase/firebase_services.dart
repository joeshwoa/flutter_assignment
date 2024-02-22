import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_assignment/model/post.dart';
import 'package:http/http.dart' as http;

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Post>> fetchPosts(String type, String lastPostName) async {
    final response = await http.get(Uri.parse('https://www.reddit.com/r/FlutterDev/$type.json?${lastPostName.isNotEmpty?'after=$lastPostName':''}&limit=20'));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<Post> posts = [];
      final data = jsonDecode(response.body)['data']['children'];
      for (var post in data) {
        final postData = post['data'];
        posts.add(Post.fromJson({
          'name': postData['name'],
          'title': postData['title'],
          'selftext': postData['selftext'],
          'url': postData['url'],
          'type': type,
        }));
      }
      return posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> storePosts(List<Post> posts) async {
    for (var post in posts) {
      // Check if a post with the same name already exists
      final querySnapshot = await _firestore
          .collection('posts')
          .where('name', isEqualTo: post.name)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // Add the post only if no post with the same name exists
        await _firestore.collection('posts').add(post.toJson());
      }
    }
  }

  Future<List<Post>> getStoredPosts(String type, DocumentSnapshot? lastDocument, int pageSize) async {
    Query query = _firestore
        .collection('posts')
        .where('type', isEqualTo: type)
        .orderBy('createdAt', descending: true)
        .limit(pageSize);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final snapshot = await query.get();
    final List<Post> posts = [];
    for (var doc in snapshot.docs) {
      posts.add(Post.fromJson(doc.data() as Map<String, dynamic>));
    }
    return posts;
  }
}
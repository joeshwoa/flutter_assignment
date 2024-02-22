import 'package:flutter/material.dart';
import 'package:flutter_assignment/firebase/firebase_services.dart';
import 'package:flutter_assignment/model/post.dart';
import 'package:flutter_assignment/pages/home_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FirebaseService', () {
    late FirebaseService firebaseService;

    setUp(() {
      firebaseService = FirebaseService();
    });

    test('fetchPosts returns a list of posts', () async {
      final posts = await firebaseService.fetchPosts('hot', '');
      expect(posts, isA<List<Post>>());
    });

    test('storePosts stores posts in Firestore', () async {
      final postsToStore = [
        Post(name: 'test1', title: 'Test Post 1', selftext: '', url: '', type: ''),
        Post(name: 'test2', title: 'Test Post 2', selftext: '', url: '', type: ''),
      ];
      await firebaseService.storePosts(postsToStore);

      // Retrieve stored posts
      final storedPosts = await firebaseService.getStoredPosts('hot', null, 2);
      expect(storedPosts.length, equals(postsToStore.length));
    });

    test('getStoredPosts returns a list of stored posts', () async {
      final storedPosts = await firebaseService.getStoredPosts('hot', null, 2);
      expect(storedPosts, isA<List<Post>>());
    });
  });

  group('HomePageWidget', () {
    testWidgets('HomePageWidget UI Test', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(const HomePage());

      // Verify that the title is displayed
      expect(find.text('/r/FlutterDev'), findsOneWidget);

      // Tap on the 'Hot' tab
      await tester.tap(find.text('Hot'));
      await tester.pump();

      // Verify that posts are displayed
      expect(find.byType(InkWell), findsWidgets);
    });

    // Add more tests to cover different functionalities of HomePageWidget
  });
}

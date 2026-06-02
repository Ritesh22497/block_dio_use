// scripts/seed_firestore.dart
// Run: dart run scripts/seed_firestore.dart
//
// Seeds Firestore with sample video documents for testing.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();

  final sampleVideos = List.generate(20, (i) {
    final ref = firestore.collection('videos').doc();
    return MapEntry(ref, {
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'thumbnailUrl': 'https://picsum.photos/seed/$i/400/800',
      'username': 'user_${i + 1}',
      'userAvatar': 'https://i.pravatar.cc/150?img=${(i % 70) + 1}',
      'caption': 'Check out this amazing reel! 🔥 #trending #viral #reels ${List.generate(3, (j) => '#hashtag${i * 3 + j}').join(' ')}',
      'audioName': 'Original Sound - user_${i + 1}',
      'likesCount': (i + 1) * 1337,
      'commentsCount': (i + 1) * 42,
      'sharesCount': (i + 1) * 17,
      'isLiked': false,
      'createdAt': Timestamp.fromDate(
        DateTime.now().subtract(Duration(hours: i * 3)),
      ),
    });
  });

  for (final entry in sampleVideos) {
    batch.set(entry.key, entry.value);
  }

  await batch.commit();
  print('✅ Seeded ${sampleVideos.length} videos to Firestore.');
}

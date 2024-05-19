import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (chatSnapshots.hasError) {
            return const Center(
              child: Text('Something went wrong...'),
            );
          }

          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages found.'),
            );
          }

          final loadedMessages = chatSnapshots.data!.docs;

          return ListView.builder(itemCount: loadedMessages.length, reverse: true,
            itemBuilder: (ctx, index) =>
                Text(loadedMessages[index].data()['text']),
          );
        });
  }
}

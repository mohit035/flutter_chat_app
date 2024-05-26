import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});
  @override
  State<StatefulWidget> createState() {
    return _NewMessagesState();
  }
}

class _NewMessagesState extends State<NewMessages> {
  final _messageController = TextEditingController();
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where the user is not signed in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user is currently signed in.')),
      );
      return;
    }

    try {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!userData.exists || userData.data() == null) {
        // Handle the case where the user data is not found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User data not found.')),
        );
        return;
      }

      final userDataMap = userData.data()!;
      final username = userDataMap['username'];
      final userImage = userDataMap['image_url'];

      if (username == null || userImage == null) {
        // Handle the case where the required fields are not present in userData
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incomplete user data.')),
        );
        return;
      }

      // Send to Firebase
      await FirebaseFirestore.instance.collection('chat').add({
        'text': enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'username': username,
        'userImage': userImage,
      });

      _messageController.clear();
    } catch (error) {
      // Handle any errors that occur during the process
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${error.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
              color: Theme.of(context).colorScheme.primary,
              onPressed: _submitMessage,
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}

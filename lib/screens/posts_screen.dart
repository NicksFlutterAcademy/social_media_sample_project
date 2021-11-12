import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_medial_sample_project/screens/chat_screen.dart';
import 'package:social_medial_sample_project/screens/create_post_screen.dart';
import 'package:social_medial_sample_project/screens/sign_in_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_medial_sample_project/widgets/post_item.dart';
import 'dart:io';
import '../models/post_model.dart';

class PostsScreen extends StatefulWidget {
  static const String routeName = "/posts_screen";

  const PostsScreen({Key? key}) : super(key: key);

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Add Post (Pick image and go to create post screen)
          IconButton(
              onPressed: () async {
                final ImagePicker imagePicker = ImagePicker();

                final XFile? xFile = await imagePicker.pickImage(
                    source: ImageSource.gallery, imageQuality: 50);

                if (xFile != null) {
                  Navigator.of(context).pushNamed(
                    CreatePostScreen.routeName,
                    arguments: File(xFile.path),
                  );
                }
              },
              icon: const Icon(Icons.add, size: 30)),
          // Log Out (Navigate back to Sign in screen)
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout, size: 30)),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("posts").orderBy("timeStamp").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError ||
              snapshot.connectionState == ConnectionState.none) {
            return const Center(child: Text("Oops, something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final QueryDocumentSnapshot doc = snapshot.data!.docs[index];

              final Post post = Post.fromSnapshot(doc);

              return PostItem(post);

            },
          );
        },
      ),
    );
  }
}

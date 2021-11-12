import 'package:flutter/material.dart';
import 'package:social_medial_sample_project/models/post_model.dart';
import 'package:social_medial_sample_project/screens/chat_screen.dart';

class PostItem extends StatelessWidget {

  final Post post;

  const PostItem(this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

        Navigator.of(context).pushNamed(ChatScreen.routeName, arguments: post.postID);

      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(post.imageUrl),
                    fit: BoxFit.cover,
                  )
              ),
            ),
            const SizedBox(height: 6),
            Text(post.userName,
                style: Theme
                    .of(context)
                    .textTheme
                    .headline6),
            const SizedBox(height: 6),
            Text(post.description,
                style: Theme
                    .of(context)
                    .textTheme
                    .headline5),
          ],
        ),
      ),
    );
  }
}

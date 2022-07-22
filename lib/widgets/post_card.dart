import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intargram/providers/user_provider.dart';
import 'package:intargram/resources/resources.dart';
import 'package:intargram/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/comment_screen.dart';
import '../untils/untils.dart';

class PostCard extends StatefulWidget {
  const PostCard({Key? key, required this.snap}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentCount = 0;
  @override
  void initState() {
    super.initState();
    getComment();
  }

  void getComment() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentCount = snap.docs.length;
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FirestoreMethods().deletePost(postId);
    } catch (err) {
      showSnackbar(
        err.toString(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final snapComment = widget.snap;
    UserProvider user = Provider.of<UserProvider>(context);
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 16)
              .copyWith(right: 0),
          child: Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.snap['profImage']),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.snap['username'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style: const TextStyle(fontSize: 12),
                    )
                  ],
                ),
              )),
              IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.currentUser!.uid == widget.snap['uid']
                        ? showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shrinkWrap: true,
                                    children: ['delete']
                                        .map((e) => InkWell(
                                              onTap: () {
                                                deletePost(
                                                  widget.snap['postId']
                                                      .toString(),
                                                );
                                                // remove the dialog box
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                child: Text(e),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ))
                        : showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shrinkWrap: true,
                                    children: ['Lưu bài viết']
                                        .map((e) => InkWell(
                                              onTap: () {
                                                // remove the dialog box
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                child: Text(e),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ));
                  },
                  icon: const Icon(Icons.more_vert))
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Text(widget.snap['description']),
          ),
        ),
        GestureDetector(
          onDoubleTap: () async {
            await FirestoreMethods().likePost(
                widget.snap['postId'], user.getUser.uid, widget.snap['likes']);
            setState(() {
              isLikeAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(
                  widget.snap['postUrl'],
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLikeAnimating ? 1 : 0,
                child: LikeAnimation(
                  // ignore: prefer_const_constructors, sort_child_properties_last
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 150,
                  ),
                  isAnimation: isLikeAnimating,
                  duration: const Duration(milliseconds: 400),
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${widget.snap['likes'].length} Tim'),
              Text('$commentCount Bình luận')
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(height: 1, color: Theme.of(context).bottomAppBarColor),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LikeAnimation(
              isAnimation: widget.snap['likes'].contains(user.getUser.uid),
              smallLike: true,
              child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likePost(widget.snap['postId'],
                        user.getUser.uid, widget.snap['likes']);
                  },
                  icon: widget.snap['likes'].contains(user.getUser.uid)
                      ? SvgPicture.asset(
                          'assets/icons/ic_heart_full.svg',
                          color: Colors.red,
                        )
                      : SvgPicture.asset('assets/icons/ic_heart_full.svg')),
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommentScreen(
                              snap: snapComment, commentCount: commentCount)));
                },
                icon: SvgPicture.asset(
                  'assets/icons/ic_mess.svg',
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.share_sharp,
                )),
          ],
        ),
        const Line(height: 4)
      ]),
    );
  }
}

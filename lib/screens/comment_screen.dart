import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intargram/untils/untils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../resources/resources.dart';
import '../widgets/widgets.dart';


class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key, required this.snap,required this.commentCount}) : super(key: key);
  final int commentCount;
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  @override
  State<CommentScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CommentScreen> {
  bool isLikeAnimating = false;
  TextEditingController commentEditingController = TextEditingController();
  
  @override
  void dispose() {
    super.dispose();
    commentEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Row(
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
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(fontSize: 12),
                  )
                ],
              ),
            )),
          ],
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      child: Text(widget.snap['description']),
                    ),
                  ),
                  GestureDetector(
                    onDoubleTap: () async {
                      await FirestoreMethods().likePost(widget.snap['postId'],
                          user.getUser.uid, widget.snap['likes']);
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
                        Text('${widget.commentCount} bình luận')
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                        height: 1, color: Theme.of(context).bottomAppBarColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      LikeAnimation(
                        isAnimation:
                            widget.snap['likes'].contains(user.getUser.uid),
                        smallLike: true,
                        child: IconButton(
                            onPressed: () async {
                              await FirestoreMethods().likePost(
                                  widget.snap['postId'],
                                  user.getUser.uid,
                                  widget.snap['likes']);
                            },
                            icon:
                                widget.snap['likes'].contains(user.getUser.uid)
                                    ? SvgPicture.asset('assets/icons/ic_heart_full.svg',color: Colors.red,): SvgPicture.asset('assets/icons/ic_heart_full.svg')),
                      ),
                      IconButton(
                          onPressed: () {},
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
                  const Line(height: 4),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Tất cả ${widget.commentCount} bình luận')),
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.snap['postId'])
                          .collection('comments')
                          .snapshots(),
                      builder: (context, snaphot) {
                        if (snaphot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Column(
                            children: List.generate(
                          (snaphot.data! as dynamic).docs.length,
                          (index) => CommentCard(
                              snap: (snaphot.data! as dynamic)
                                  .docs[index]
                                  .data()),
                        ));
                      })
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        blurRadius: 7,
                        spreadRadius: 2,
                        offset: const Offset(2, 2)),
                  ],
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(user.getUser.imageAvatar),
                      ),
                      Container(
                        width: 280,
                        height: 40,
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).bottomAppBarColor,
                            borderRadius: BorderRadius.circular(40)),
                        child: TextField(
                          controller: commentEditingController,
                          autofocus: true,
                          decoration: const InputDecoration(
                              hintText: 'Viết bình luận...',
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 20, bottom: 8)),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            await FirestoreMethods().postComment(
                                widget.snap['postId'],
                                commentEditingController.text,
                                user.getUser.uid,
                                user.getUser.username,
                                user.getUser.imageAvatar);
                            setState(() {
                              commentEditingController.text = '';
                            });
                          },
                          icon: const Icon(Icons.send))
                    ]),
              ))
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({Key? key,required this.snap}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final snap;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      width: double.infinity,
      child: Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.snap['profImage']),
              ),
              Container(
                padding: const EdgeInsets.only(top: 7,bottom: 7,right: 7),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).bottomAppBarColor,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.snap['name'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        widget.snap['text'],
                        style: const TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                )),
              ),
            ],
          ),
    );
  }
}
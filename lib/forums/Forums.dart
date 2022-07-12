//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:safari/Forums/Business%20Logic/Forums_Cubit.dart';
// // import 'package:safari/Forums/Data%20Layer/CommentsAPI.dart';
// import 'package:safari/Forums/Replies.dart';
// // import 'package:safari/LoginAll/Presentation/hello.dart';
// // import 'package:safari/forums/Replies.dart';
// // import 'package:safari/forums/businesslogic/Forums_Cubit.dart';
// // import 'package:safari/forums/businesslogic/Forums_States.dart';
// // import 'package:safari/forums/datalayer/Comment_Model.dart';
// import 'package:safari/forums/datalayer/Comment_Repository.dart';
// import 'package:safari/forums/datalayer/CommentsAPI.dart';
// import 'package:safari/theme/colors/color.dart';


//
// // import '../LoginAll/Business Logic/Cubit_Login.dart';
// // import '../color.dart';
// import 'businesslogic/Forums_Cubit.dart';
// import 'businesslogic/Forums_States.dart';
// import 'datalayer/Comment_Model.dart';
// // import 'datalayer/Comment_Repository.dart';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:safari/forums/Replies.dart';
import 'package:safari/forums/businesslogic/Forums_Cubit.dart';
import 'package:safari/forums/businesslogic/Forums_States.dart';
import 'package:safari/forums/datalayer/Comment_Model.dart';
import 'package:safari/forums/datalayer/Comment_Repository.dart';
import 'package:safari/forums/datalayer/CommentsAPI.dart';
import 'package:safari/theme/colors/color.dart';


class Forums extends StatefulWidget {
  const Forums({Key? key}) : super(key: key);

  @override
  State<Forums> createState() => _ForumsState();
}

class _ForumsState extends State<Forums> {
  bool isloved = false;

  List<Comment> Comments = [];
  TextEditingController commentcontroler = TextEditingController();
  @override
  void initState() {
    BlocProvider.of<ForumsCubit>(context).GetAllCharacters() as List<Comment>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Forums"),
        backgroundColor: LightColors.bb,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext DialogContext) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            content: Container(
                              height: 150,
                              width: 300,
                              color: Colors.white,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 100,
                                    top: -60,
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundImage: AssetImage(
                                          "images/default.jpg"),
                                    ),
                                  ),
                                  Positioned(
                                      left: 16,
                                      top: 30,
                                      child: Text(
                                        "Ask Your Question Here",
                                        style: TextStyle(
                                            color: LightColors.bb,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700),
                                      )),
                                  Positioned(
                                    bottom: 10,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(25),
                                          border: Border.all(
                                              color: Colors.grey, width: 2)),
                                      height: 60,
                                      width: 280,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                textInputAction:
                                                TextInputAction.go,
                                                controller: commentcontroler,
                                                minLines: 1,
                                                maxLines: 5,
                                                decoration:
                                                InputDecoration.collapsed(
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  hintText: "....",
                                                  hintStyle:
                                                  TextStyle(fontSize: 19),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(right: 5),
                                            child: CircleAvatar(
                                              radius: 24,
                                              backgroundColor: LightColors.bb,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.send_outlined,
                                                  color: LightColors.white,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  BlocProvider.of<ForumsCubit>(
                                                      context)
                                                      .SendQuestion(
                                                      commentcontroler
                                                          .text);
                                                  commentcontroler.clear();
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: BlocBuilder<ForumsCubit, ForumsStates>(builder: (context, state) {
        if (state is CommentsLoaded) {
          Comments = state.Comments;
          print(Comments.length);
          return Container(
            color: Colors.black12,
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 20),
              child: ListView.separated(
                  itemBuilder: (context, index) => MaterialButton(
                      onPressed: () {
                        print('Item clicked');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                    create: (BuildContext context) =>
                                        ForumsCubit(ForumsInitialState(),
                                            CommentsRepository(CommentsAPI())),
                                    child: QuestionReplies(
                                        comment: Comments[index]))));
                      },
                      child: QuestionItem(Comments[index])),
                  separatorBuilder: (context, index) => SizedBox(
                    height: 10,
                  ),
                  itemCount: Comments.length),
            ),
          );
        } else
          return Center(
              child: CircularProgressIndicator(
                color: LightColors.bb,
              ));
      }),
    );
  }

  Widget QuestionItem(Comment comment) {
    return Container(
        constraints: BoxConstraints(minHeight: 200, minWidth: 500),
        decoration: BoxDecoration(
            color: LightColors.white, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Row(
              children: [
                CircleAvatar(
                    backgroundColor: LightColors.aa,
                    radius: 27,
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(comment.ImageURL),
                        radius: 25)),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        "@" + comment.Username,
                        style: TextStyle(color: LightColors.bb, fontSize: 12),
                      ),
                      Text(
                        "26/10/2021",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                    child: Text(
                      comment.message,
                      style: TextStyle(color: LightColors.bb),
                      textAlign: TextAlign.center,
                    ),
                  )),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LikeButton(
                    isLiked: isloved,
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.favorite,
                        color: isLiked ? Colors.deepOrange : LightColors.black3,
                        size: 20.0,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${BlocProvider.of<ForumsCubit>(context).Comments.length}",
                    style: TextStyle(color: LightColors.bb, fontSize: 16),
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.mode_comment_rounded,
                  color: LightColors.bb,
                  size: 18,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${BlocProvider.of<ForumsCubit>(context).Comments.length}",
                    style: TextStyle(color: LightColors.bb, fontSize: 16),
                  ),
                ),
              ],
            ),
          ]),
        ));
  }
}



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
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:safari/forums/Replies.dart';
import 'package:safari/forums/businesslogic/Forums_Cubit.dart';
import 'package:safari/forums/businesslogic/Forums_States.dart';
import 'package:safari/forums/datalayer/Comment_Repository.dart';
import 'package:safari/forums/datalayer/CommentsAPI.dart';
import 'package:safari/login/presentation/hello.dart';
import 'package:safari/models/components/quastion.dart';
import 'package:safari/models/components/replay.dart';
import 'package:safari/models/components/user.dart';
import 'package:safari/server/authintacation.dart';
import 'package:safari/server/database_server.dart';
import 'package:safari/theme/colors/color.dart';

import '../server/database_client.dart';

class Forums extends StatefulWidget {
  const Forums({Key? key}) : super(key: key);

  @override
  State<Forums> createState() => _ForumsState();
}

class _ForumsState extends State<Forums> {
  bool isLove = false;

  List<Question> questions = [];
  TextEditingController commentcontroler = TextEditingController();

  final ValueNotifier<bool> _loadingQuestions = ValueNotifier(false);
  final ValueNotifier<bool> _addingQuestions = ValueNotifier(false);

  Future<User?> _getUserData(String userId) async {
    print(userId);
    try {
      return await DataBaseClintServer.getUser(userId);
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('some error happened')));
    }
  }

  Future<void> _addQuestion(Question question) async {
    try {
      _addingQuestions.value = true;
      await DataBaseServer.addQuestion(question: question);
      questions.add(question);
      _addingQuestions.value = false;
    } catch (e) {
      _addingQuestions.value = false;

      debugPrint(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("some error happened")));
    }
  }

  Future<void> _loadQuestions() async {
    try {
      _loadingQuestions.value = true;
      questions = await DataBaseClintServer.getAllQuestions() ?? [];
      _loadingQuestions.value = false;
    } catch (e) {
      _loadingQuestions.value = false;
      debugPrint(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("some error happened")));
    }
  }

  @override
  initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor:  Colors.black12,
      backgroundColor: LightColors.a,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Forums"),
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
                                  const Positioned(
                                    left: 100,
                                    top: -60,
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundImage:
                                          AssetImage("images/default.jpg"),
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
                                              child:
                                                  ValueListenableBuilder<bool>(
                                                valueListenable:
                                                    _addingQuestions,
                                                builder: (c, value, child) => value
                                                    ? const CircularProgressIndicator(
                                                        color: Colors.orange,
                                                      )
                                                    : child!,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.send_outlined,
                                                    color: LightColors.white,
                                                    size: 20,
                                                  ),
                                                  onPressed: () async {
                                                    _addingQuestions.value =
                                                        true;
                                                    if (Authentication.user ==
                                                        null) {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (c) =>
                                                                  myLogin()));
                                                    }
                                                    User? u =
                                                        await DataBaseClintServer
                                                            .getUser(
                                                                Authentication
                                                                        .user!
                                                                        .email
                                                                        ?.split(
                                                                            '.')
                                                                        .first ??
                                                                    '');
                                                    if (u == null) {
                                                      debugPrint(
                                                          "User is not exists");
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      "User authenticated error")));
                                                      return;
                                                    }
                                                    await _addQuestion(Question(
                                                        id: 'id',
                                                        userId: u.id,
                                                        time: DateTime.now(),
                                                        txt: commentcontroler
                                                            .text,
                                                        replies: [],
                                                        loves: []));
                                                    commentcontroler.clear();
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
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
                  Icons.add,
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: _loadingQuestions,
        builder: (c, value, child) => value
            ? const Center(
                child: CircularProgressIndicator(
                color: LightColors.bb,
              ))
            : questions.isEmpty
                ? const Center(
                    child: Text("No data"),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 20),
                    child: ListView.separated(
                        itemBuilder: (context, index) => MaterialButton(
                            onPressed: () {
                              print('Item clicked');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (buildcontext) =>
                                          QuestionReplies(
                                            replies: questions[index].replies,
                                            question: questions[index],
                                          )));
                            },
                            child: QuestionItem(questions[index])),
                        separatorBuilder: (context, index) => SizedBox(
                              height: 10,
                            ),
                        itemCount: questions.length),
                  ),
      ),
    );
  }

  Widget QuestionItem(Question comment) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.35,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.2),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0.1,
                  blurRadius: 160)
            ],
            color: LightColors.white,
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            FutureBuilder<User?>(
              future: _getUserData(comment.userId),
              builder: (c, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    color: Colors.orange,
                  );
                } else if (snapshot.hasData && snapshot.data != null) {
                  return Row(
                    children: [
                      CircleAvatar(
                          backgroundColor: LightColors.a,
                          radius: 27,
                          child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(snapshot.data!.photoUrl),
                              radius: 25)),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              "@${snapshot.data!.name}",
                              style: TextStyle(
                                  color: LightColors.bb, fontSize: 12),
                            ),
                            Text(
                              DateFormat.yMMMEd().format(comment.time),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Text("No data");
                }
              },
            ),
            Expanded(
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: Text(
                  comment.txt,
                  style: TextStyle(color: LightColors.bb),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: ClipOval(
                      child: Container(
                        color: Colors.pink,
                        width: 35,
                        height: 35,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: LikeButton(
                            onTap: (isTaped) async {
                              try {
                                if (Authentication.user == null) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (c) => myLogin()));
                                }
                                debugPrint("user is authenticated");



                                debugPrint("love value is $isLove");
                                await DataBaseClintServer.loveQuestion(
                                    userId: Authentication.user!.uid,
                                    loveList: comment.loves,
                                    isLove: isLove,
                                    questionId: comment.id);
                                  setState((){});

                                print(comment.loves);

                                return true;
                              } on Exception catch (e) {
                                debugPrint(e.toString());
                                return false;

                              }
                            },
                            isLiked: comment.loves
                                .contains(Authentication.user?.uid ?? ""),
                            likeBuilder: (bool isLiked) {
                              isLove = isLiked;
                              return Icon(
                                isLiked
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: LightColors.white,
                                size: 20.0,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "${comment.loves.length}",
                    style: TextStyle(color: Colors.pink, fontSize: 16),
                  ),
                ),
                const Spacer(),
                ClipOval(
                  child: Container(
                    color: Colors.lightBlueAccent,
                    height: 36,
                    width: 36,
                    child: Icon(
                      Icons.mode_comment_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "${comment.replies.length}",
                    style:
                        TextStyle(color: Colors.lightBlueAccent, fontSize: 16),
                  ),
                ),
              ],
            ),
          ]),
        ));
  }
}

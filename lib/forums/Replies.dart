// import 'package:bubble/bubble.dart';
import 'package:bubble/bubble.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:safari/models/components/replay.dart';
import 'package:safari/server/authintacation.dart';
import 'package:safari/server/database_server.dart';
import 'package:safari/theme/colors/color.dart';

import '../login/presentation/hello.dart';
import '../models/components/user.dart';
import '../models/components/quastion.dart' as q;
import '../server/database_client.dart';

// import 'Business Logic/Forums_Cubit.dart';
// import 'Business Logic/Forums_States.dart';

class QuestionReplies extends StatefulWidget {
  final List<Replay> replies;
  final  q.Question question;
  const QuestionReplies({Key? key, required this.replies,required this.question}) : super(key: key);

  @override
  State<QuestionReplies> createState() => _QuestionRepliesState();
}

class _QuestionRepliesState extends State<QuestionReplies> {
  bool isloved = false;


  TextEditingController commentcontroler = TextEditingController();
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final ValueNotifier<bool> _addingReplay = ValueNotifier(false);

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


  Future<void> _addReplay( Replay replay)async{
    try{
      _addingReplay.value = true;
      await DataBaseServer.replayToQuestion(questionId:widget.question.id , replay: replay);
      _addingReplay.value = false;
    }catch(e){
      _addingReplay.value = false;
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("some error happened")));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
        //backgroundColor:Color.fromARGB(255, 235, 229, 229),
        backgroundColor: LightColors.a,
        appBar: AppBar(
          iconTheme: IconThemeData(color: LightColors.bb),
          backgroundColor: LightColors.white,
          elevation: 0,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                QuestionItem(widget.question),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.5,
                  width: MediaQuery.of(context).size.width,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _loading,
                    builder: (c,v,child)=>v?const CircularProgressIndicator(color: Colors.orange,):child!,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height*0.5,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.separated(

                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => Reply(widget.replies[index]),
                            separatorBuilder: (context, index) => SizedBox(
                              height: 10,
                            ),
                            itemCount: widget.replies.length),
                      ),
                    ),
                  ),
                ),

              ]),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            controller: commentcontroler,
                            minLines: 1,
                            maxLines: 5,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              hintText: "add a reply ...",
                              hintStyle:
                              TextStyle(fontSize: 19, color: LightColors.bb),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: LightColors.bb,
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _addingReplay,
                          builder: (c,value,child)=>value?const CircularProgressIndicator(
                            color: Colors.orange,
                          ):child!,
                          child: IconButton(
                            icon: Icon(
                              Icons.send_outlined,
                              color: LightColors.white,
                              size: 20,
                            ),
                            onPressed: () async{

                              _addingReplay.value = true;
                              if(Authentication.user == null){
                                Navigator.of(context).push(MaterialPageRoute(builder: (c)=>myLogin()));
                              }
                              User?u = await DataBaseClintServer.getUser(Authentication.user!.email?.split('.').first??'');
                              if(u == null){
                                debugPrint("User is not exists");
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User authenticated error")));
                                return ;
                              }
                              Replay r =Replay(txt: commentcontroler.text, userId: u.id, id: 'id', date: DateTime.now());
                              await _addReplay(r);
                              setState((){
                                widget.replies.add(r);
                              });
                              commentcontroler.clear();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget Reply(Replay replay) {

    if (replay.userId == (Authentication.user?.email?.split('.').first??"")) {
      return Row(
        children: [
          Expanded(
            child: Bubble(
              elevation: 2,
              margin: BubbleEdges.only(top: 10),
              radius: Radius.circular(26),
              alignment: Alignment.topRight,
              nip: BubbleNip.rightCenter,
              nipHeight: 10,
              nipWidth: 10,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 5, left: 10, right: 10),
                child: Text(
                  replay.txt,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.end,
                ),
              ),
              color: LightColors.bb,
            ),
          ),
          FutureBuilder<User?>(
            future: _getUserData(replay.userId),
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
                            style:
                                TextStyle(color: LightColors.bb, fontSize: 12),
                          ),
                          Text(
                            DateFormat.yMMMEd().format(replay.date),
                            style: TextStyle(color: Colors.grey, fontSize: 12),
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
        ],
      );
    } else {
      return Row(
        children: [
          FutureBuilder<User?>(
            future: _getUserData(replay.userId),
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
                            style:
                                TextStyle(color: LightColors.bb, fontSize: 12),
                          ),
                          Text(
                            DateFormat.yMMMEd().format(replay.date),
                            style: TextStyle(color: Colors.grey, fontSize: 12),
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
            child: Bubble(
              elevation: 2,
              margin: BubbleEdges.only(top: 10),
              radius: Radius.circular(25),
              alignment: Alignment.topLeft,
              nip: BubbleNip.leftCenter,
              nipHeight: 10,
              nipWidth: 10,
              color: Colors.lightBlue,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 5, left: 10, right: 10),
                child: Text(
                  replay.txt,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget QuestionItem(q.Question question) {
    return SizedBox(
      height: MediaQuery.of(context).size.height*0.2,
      child:Container(
          width: MediaQuery.of(context).size.width,
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
            padding: const EdgeInsets.all(10.0),
            child: Column(
                children: [
              FutureBuilder<User?>(
                future: _getUserData(question.userId),
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
                          padding: const EdgeInsets.all(2),
                          child: Column(
                            children: [
                              Text(
                                "@${snapshot.data!.name}",
                                style: TextStyle(
                                    color: LightColors.bb, fontSize: 12),
                              ),
                              Text(
                                DateFormat.yMMMEd().format(question.time),
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
                      padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
                      child: Text(
                        question.txt,
                        style: TextStyle(color: LightColors.bb),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
              ),
              SizedBox(
                height:2,
              ),

            ]),
          )),
    );
  }
}

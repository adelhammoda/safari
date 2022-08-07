import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:safari/localization/localization_bloc.dart';
import 'package:safari/login/presentation/hello.dart';
import 'package:safari/my_profile/CustomClip.dart';
import 'package:safari/register/presentation/widget/Loading_State.dart';
import 'package:safari/server/authintacation.dart';
import 'package:safari/server/database_client.dart';

import '../models/components/booking.dart';
import '../models/components/user.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  Color color = Colors.black;
  int X = 0;

  User? user;
  List<Booking> booking = [];
  final ValueNotifier<bool> _loadingUser = ValueNotifier(false);
  final ValueNotifier<bool> _loadingBooking = ValueNotifier(false);

  Future<void> _loadUserData() async {
    try {
      if (Authentication.user == null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (c) => myLogin()));
      } else {
        _loadingUser.value = true;
        user = await DataBaseClintServer.getUser(
            Authentication.user!.email?.split('.').first ?? '');
        _loadingUser.value = false;
        _loadUserPayment();
      }
    } catch (e) {
      _loadingUser.value = false;
      debugPrint(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Some error happened")));
    }
  }

  Future<void> _loadUserPayment() async {
    try {
      if (user == null) {
        debugPrint('user is null');
        return;
      }
      debugPrint("loading user booking");
      _loadingBooking.value = true;
      booking = await DataBaseClintServer.getUserBooking(user!.id) ?? [];
      _loadingBooking.value = false;
      debugPrint("loading completed");
    } on Exception catch (e) {
      _loadingBooking.value = false;
      debugPrint(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Some error happened")));
    }
  }

  @override
  initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final showDraggable = color == Colors.black;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 20,
            height: 20,
            child: Center(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: ValueListenableBuilder<bool>(
        valueListenable: _loadingUser,
        builder: (c, value, _) => value
            ? const LoadingWidget()
            : Padding(
                padding: const EdgeInsets.all(0.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ClipPath(
                        clipper: CustomClipPath(),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 500,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                  user?.photoUrl ??
                                      "https://www.arrajol.com/sites/default/files/styles/800x533/public/2017/10/25/184241-Dubai.jpg",
                                ),
                              )),

                          // color: Colors.amber,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color((0x00000000)),
                                    Color((0x00000000)),
                                    Color((0x00000000)),
                                    Color((0xC0000000)),
                                    Color((0xC0000000)),
                                    Color((0xC0000000))
                                  ]),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 130.0,
                                    height: 130.0,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                                "https://static.xx.fbcdn.net/assets/?revision=816167972411634&name=desktop-creating-an-account-icon&density=1"))),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    user?.name ?? "name",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: ExpansionTile(
                              onExpansionChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    X += 200;
                                  } else {
                                    X -= 200;
                                  }
                                });
                              },
                              textColor: Colors.green,
                              iconColor: Colors.green,
                              title: Text(
                                LocalizationCubit.get(context).localization
                                    ? 'حجوزاتي'
                                    : 'My Bookings',
                                // "Number Of Travellers",
                                style: const TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400),
                              ),
                              childrenPadding: const EdgeInsets.all(0),
                              children: [
                                ValueListenableBuilder<bool>(
                                    valueListenable: _loadingBooking,
                                    builder: (c, value, _) =>value?const LoadingWidget():
                                    booking.isEmpty?const Text("No data"):GridView.count(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          crossAxisCount: 2,
                                          children: List.generate(
                                            booking.length,
                                            (index) => Column(
                                              children: [
                                                Stack(
                                                  children: [
                                                    Align(
                                                       alignment: Alignment.bottomCenter,
                                                       child: SizedBox(
                                                         width: 170,
                                                         height: 170,
                                                         child: Image(
                                                          image: NetworkImage(
                                                              booking[index].image),

                                                          fit: BoxFit.fill,
                                                    ),
                                                       ),
                                                     ),
                                                    Positioned(
                                                    bottom: 0,
                                                        right: 0,
                                                      left: 0,
                                                      child: Container(
                                                        width: 170,
                                                        height: 40,
                                                        color: Colors.black
                                                            .withOpacity(0.7),
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .only(
                                                          top: 5,
                                                          bottom: 5,
                                                        ),
                                                        child: Text(
                                                          booking[index].name,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: const TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 40,
                                                      left: 0,
                                                      right: 0,
                                                      child: Container(
                                                        padding:const  EdgeInsets.all(5),
                                                        color: Colors.black38.withOpacity(0.5),
                                                        child: Text("${booking[index].cost} \$",
                                                          style: const TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.white,
                                                          ),),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

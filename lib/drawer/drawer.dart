import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:safari/animation/animateroute.dart';
import 'package:safari/drawer/setting/about_us.dart';
import 'package:safari/drawer/setting/account.dart';
import 'package:safari/drawer/setting/contact_us.dart';
import 'package:safari/drawer/setting/setting.dart';
import 'package:safari/generated/l10n.dart';
import 'package:safari/login/presentation/hello.dart';
import 'package:safari/my_profile/my_profile.dart';
import 'package:safari/register/presentation/Register_Screen.dart';
import 'package:safari/theme/colors/color.dart';
import 'package:safari/homelayout/homelayout.dart';
import 'package:safari/main_screen/main_screen.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreen: DrawerScreen(setIndex: (index) {
        setState(() {
          currentIndex = index;


        });
      },),
      mainScreen: currentScreen(),
      borderRadius: 30,
      //showShadow: true,

      angle: 0.0,
      slideWidth: (MediaQuery.of(context).size.height)-570,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.bounceIn,
      menuBackgroundColor: Theme.of(context).canvasColor,

    );
  }

  Widget currentScreen() {
    // return Main();
    switch(currentIndex) {
      case 0:
        return HomeLayout();
      case 1:
        return myLogin();

      case 2:
        return Setting();
      case 3:
        return AboutUs();
      case 4:
        return ContactUs();

      default:
        return HomeScreen();
    }
  }

}

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({Key? key, this.title = "Home"}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.title),
        centerTitle: true,
        leading: DrawerWidget(),
      ),
    );
  }
}

class DrawerScreen extends StatefulWidget {
  final ValueSetter setIndex;
  const DrawerScreen({Key? key, required this.setIndex}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(child:
          Container(
            child: Column(

              children: [
                CircleAvatar(child: Image.asset('images/malaysia1.jpg',),
                  maxRadius: 40,
                ),
                MaterialButton(
                  onPressed: (){
                    Navigator.of(context).push(Slide8(Page: MyProfile()));
                  },
                  child: Text(
                    'flutter',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ],),
          )),
          drawerList(Icons.home_outlined, S.of(context).pageHome, 0),
          Divider(),

          drawerList(
              Icons.perm_identity, S.of(context).pageAccount, 1),

          Divider(),
          drawerList(Icons.settings, S.of(context).pageSetting, 2),
          Divider(),

          drawerList(Icons.people_outline, S.of(context).pageAboutau, 3),
          Divider(),

          drawerList(Icons.call, S.of(context).pageContactus, 4),
          Divider(),




          Spacer(),
          Padding(padding: const EdgeInsets.all(8),child: InkWell(child:Row(
            children: [
              Icon(Icons.exit_to_app,),
              SizedBox(width: 5,),
              Text(S.of(context).pageLogout,style: Theme.of(context).textTheme.headline5,)
            ],
          )),),
          SizedBox(height: 30,)
        ],
      ),
    );
  }

  Widget drawerList(IconData icon, String text, int index) {
    return GestureDetector(

      onTap: () {
        widget.setIndex(index);
        ZoomDrawer.of(context)?.close();

      },

      child: Column(
        children: [

          Padding(padding: const EdgeInsets.all(8),child: InkWell(child:Row(
            children: [
              Icon(icon,color:Colors.white ,size: 25,),
              SizedBox(width: 10,),
              Text(text,style: Theme.of(context).textTheme.button,),
            ],
          )),),


        ],
      ),
    );
  }
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        ZoomDrawer.of(context)!.toggle();
      },
      icon: Icon(Icons.menu,),
    );
  }
}


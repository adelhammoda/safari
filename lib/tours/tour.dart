import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:safari/expanded/expandedwidget.dart';
import 'package:safari/generated/l10n.dart';
import 'package:safari/localization/localization_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:safari/login/presentation/hello.dart';
import 'package:safari/models/components/tour.dart';
import 'package:safari/models/offices/tourist_office.dart';
import 'package:safari/reviewmodle.dart';
import 'package:safari/server/authintacation.dart';
import 'package:safari/server/database_client.dart';
import 'package:safari/stars/star.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../Payment/Payment_Home.dart';
import '../models/components/comments.dart';
import '../models/components/user.dart';


class Tours extends StatefulWidget {
  final Tour tour;

  const Tours(this.tour, {Key? key}) : super(key: key);

  @override
  State<Tours> createState() => _ToursState();
}

class _ToursState extends State<Tours> {
  Future<List<Comment>?> _getComments(){
    try {
      return DataBaseClintServer.getComments(widget.tour.comments);
    } catch(e) {
      debugPrint(e.toString());
      return Future(() => null);
    }
  }


  Future<User?> _getUserData(String userId)async{
    print(userId);
    try{
      return await DataBaseClintServer.getUser(userId);
    }catch(e){
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('some error happened')));
    }
  }

  List<String> buttons = [
    'Detail',
    'reviews',
    'rate now',
  ];

  bool fav = false;
  int selectedindex = 0;
  double rating = -1;
  int currentIndex = 0;
  bool isloved = false;
  int lovecount = 0;
  final items = ['report'];
  final ValueNotifier<bool> _submitLoading = ValueNotifier(false);
  final ValueNotifier<bool> _commentLoading = ValueNotifier(false);
  final ValueNotifier<bool> _loadingPayment = ValueNotifier(false);

  void customLaunch(command) async {
    if (await canLaunchUrlString(command)) {
      await launchUrlString(command);
    } else {
      debugPrint('could not launch $command');
    }
  }

  initialState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.favorite),
        //     onPressed: (){
        //       fav=true;
        //     },
        //   ),
        // ],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _carouselSlider(widget.tour.images),
            const SizedBox(
              height: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 5),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    widget.tour.name,
                                    style:
                                    Theme.of(context).textTheme.headline1,
                                  ),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconTheme(
                                    data: const IconThemeData(
                                      color: Colors.amber,
                                      size: 30,
                                    ),
                                    child: StarDisplay(
                                        value: widget.tour.rateAverage()),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                LikeButton(
                                  likeCount: widget.tour.favorite.length,
                                  isLiked: widget.tour.favorite
                                      .contains(Authentication.user?.uid??''),
                                  onTap: (bool? tapped) async {
                                    if (Authentication.user == null) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (c) => myLogin()));
                                      return false;
                                    } else {
                                      try {
                                        bool isFavorite = widget.tour.favorite
                                            .contains(Authentication.user!.uid);
                                        List<String> ind =
                                        widget.tour.favorite.toList();
                                        if (isFavorite) {
                                          setState(() {
                                            widget.tour.favorite.removeWhere(
                                                    (element) =>
                                                element ==
                                                    Authentication.user!.uid);
                                          });
                                          debugPrint(
                                              "decrement tours favorite");


                                          await DataBaseClintServer
                                              .decrementToursFavorite(
                                              userId:
                                              Authentication.user!.uid,
                                              toursId: widget.tour.id,
                                              index: ind
                                                  .indexOf(Authentication
                                                  .user!.uid)
                                                  .toString());
                                          debugPrint(
                                              "decrement tours favorite completed");
                                          return false;
                                        } else {
                                          debugPrint(
                                              "increment tours favorite");
                                          Set<String> oldFavorite =
                                              widget.tour.favorite;
                                          setState(() => widget.tour.favorite
                                              .add(Authentication.user!.uid));
                                          await DataBaseClintServer
                                              .incrementToursFavorite(
                                              userId:
                                              Authentication.user!.uid,
                                              toursId: widget.tour.id,
                                              oldFavorite: oldFavorite);
                                          debugPrint(
                                              "increment tours favorite completed");
                                          return true;
                                        }
                                      } on Exception catch (e) {
                                        bool isFavorite = widget.tour.favorite
                                            .contains(Authentication.user!.uid);
                                        if (isFavorite) {
                                          widget.tour.favorite
                                              .add(Authentication.user!.uid);
                                        } else {
                                          widget.tour.favorite.removeWhere(
                                                  (element) =>
                                              element ==
                                                  Authentication.user?.uid);
                                        }
                                        print(e);
                                        setState(() {});
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                            content: Text(
                                                "some error happened")));
                                      }
                                    }
                                    return tapped;
                                  },
                                  // likeCount:lovecount,

                                  likeBuilder: (bool isLiked) {
                                    return Icon(
                                      Icons.favorite_outline,
                                      color: isLiked
                                          ? Colors.deepOrange
                                          : Colors.grey[700],
                                      size: 35.0,
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_pin,
                                    color: Colors.orangeAccent,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    widget.tour.country,
                                    style:
                                    Theme.of(context).textTheme.headline6,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            //color: Colors.black,
                            height: (MediaQuery.of(context).size.height) * 0.1,
                            child: Row(
                              children: [
                                buildContainer1(context, 0),
                                const SizedBox(
                                  width: 10,
                                ),
                                buildContainer2(context, 1),
                                const SizedBox(
                                  width: 10,
                                ),
                                buildContainer3(context, 2),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            // ListView.builder(
                            //     physics: BouncingScrollPhysics(),
                            //     scrollDirection: Axis.horizontal,
                            //     itemCount:buttons.length ,
                            //     itemBuilder: (context,index){
                            //       return _buildlist(context, index);

                            //     }),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              selectedindex == 0
                                  ? detail()
                                  : selectedindex == 1
                                  ? Reviews()
                                  : rate(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _carouselSlider(List<String> images) {
    return CarouselSlider(
      items: images
          .map((e) => ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(45),
          bottomLeft: Radius.circular(45),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(e, width: double.infinity, fit: BoxFit.cover),
          ],
        ),
      ))
          .toList(),
      options: CarouselOptions(
        viewportFraction: 1,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlay: true,
        enableInfiniteScroll: true,
        height: (MediaQuery.of(context).size.height) - 480,
      ),
    );
  }

  Widget detail() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Align(
                  alignment: LocalizationCubit.get(context).localization
                      ? Alignment.topRight
                      : Alignment.topLeft,
                  child: Row(
                    children: [
                      Text(
                        '${widget.tour.nights} ',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        '${S.of(context).pageNight} ',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      Text(
                        '${widget.tour.days} ',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        S.of(context).pageDay,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        DateFormat.yMEd().format(widget.tour.leavingDate),
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).pagePrice,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${widget.tour.cost} D',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          S.of(context).pageLike,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        //TODO:discuss this section
                        Text(
                          '45K',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          S.of(context).pagePlaces,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '43',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  Align(
                    alignment: LocalizationCubit.get(context).localization
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    child: Text(
                      S.of(context).pageProgram,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: LocalizationCubit.get(context).localization
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      child: ExpandedWidget(
                        text: widget.tour.program,
                      ),
                    ),
                  ),
                ],
              ),
              //SizedBox(height: 15,),
              const SizedBox(
                height: 5,
              ),
              Column(
                children: [
                  Align(
                    alignment: LocalizationCubit.get(context).localization
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    child: Text(
                      S.of(context).pageOurProgram,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: LocalizationCubit.get(context).localization
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      child: ExpandedWidget(
                          text: widget.tour
                              .programInclude //style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: LocalizationCubit.get(context).localization
                    ? Alignment.topRight
                    : Alignment.topLeft,
                child: Text(
                  S.of(context).pageContactus,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.call,
                            size: 25,
                            color: Theme.of(context).bottomAppBarColor,
                          ),
                          onPressed: () {
                            if (widget.tour.phones['call'] != null) {
                              customLaunch('tel:${widget.tour.phones['call']}');
                            }
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.tour.phones['call'] ?? 'Not exists',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.sms,
                            size: 25,
                            color: Theme.of(context).bottomAppBarColor,
                          ),
                          onPressed: () {
                            if (widget.tour.phones['message'] != null) {
                              customLaunch(
                                  'sms:${widget.tour.phones['message']}?body=I%20have%20problem in');
                            }
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.tour.phones['message'] ?? "Not exits",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 20,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                InkWell(
                  onTap:()async{
                    try {
                      if(Authentication.user == null){
                        Navigator.of(context).push(MaterialPageRoute(builder: (c)=>myLogin()));
                        _loadingPayment.value = false;
                      }
                      debugPrint("loading...");
                      _loadingPayment.value = true;
                     User? u = await DataBaseClintServer.getUser(Authentication.user?.email?.split('.').first??'');
                     if(u == null){
                       _loadingPayment.value = false;
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cant find user specified")));
                       return ;
                     }
                      TouristOffice? t=
                      await DataBaseClintServer.getTouristOfficeWhere(tourId: widget.tour.id);
                      _loadingPayment.value = false;
                      debugPrint("query completed and ther result is $t");
                      if(t == null){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Some error happened")));
                        return ;
                      }
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (c)=> PaymentHome(
                            imageUrl: widget.tour.images.first,
                            name: widget.tour.name,
                            cost: widget.tour.cost,
                            reservedId:widget.tour.id,
                            reservedPath: 'tourist_office/${t.id}',
                            uid:u.id
                          ))
                      );
                    } on Exception catch (e) {
                      debugPrint(e.toString());
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Some error happened")));
                    }
                  },
                  child:ValueListenableBuilder<bool>(
                    child:  Container(
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: (MediaQuery.of(context).size.height) * 0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        color: Colors.orange,
                      ),
                      child: Center(
                        child: Text(
                          S.of(context).pageBookNow,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    valueListenable: _loadingPayment,
                    builder: (c,value,child)=>value?const CircularProgressIndicator(color: Colors.orange,):
                    child!,
                  ),
                ),
                // const SizedBox(
                //   width: 10,
                // ),
                // Container(
                //   width: MediaQuery.of(context).size.width * 0.30,
                //   height: (MediaQuery.of(context).size.height) * 0.1,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(35),
                //     color: Colors.grey[600],
                //   ),
                //   //color: Theme.of(context).cardColor,
                //   child: MaterialButton(
                //     child: Text(
                //       S.of(context).pageByBank,
                //       style: const TextStyle(
                //         fontWeight: FontWeight.w800,
                //         fontSize: 16,
                //         color: Colors.white,
                //       ),
                //     ),
                //     onPressed: () {},
                //   ),
                // ),
                // const SizedBox(
                //   width: 7,
                // ),
                // Container(
                //   width: MediaQuery.of(context).size.width * 0.45,
                //   height: (MediaQuery.of(context).size.height) * 0.2,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(35),
                //     color: Colors.grey[600],
                //   ),
                //   //color: Theme.of(context).cardColor,
                //   child: MaterialButton(
                //     child: Text(
                //       S.of(context).pageWhenArrived,
                //       style: const TextStyle(
                //         fontWeight: FontWeight.w800,
                //         fontSize: 16,
                //         color: Colors.white,
                //       ),
                //     ),
                //     onPressed: () {},
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget Reviews(){
    bool isless=false;
    bool isMore = false;
    var select='bmw';
    List<String>itemss=['report'];
    double sum = 1 ;
    for(int i in widget.tour.rate){
      sum+=i;
    }
    List<double> ratings =widget.tour.rate.map((e) =>((e*100/sum)/100)).toList();
    return SingleChildScrollView(

      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8,),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:(widget.tour.rateAverage()).toString(),
                            style: TextStyle(fontSize: 48.0,color:Colors.indigo,),
                          ),
                          TextSpan(
                            text: "/5",
                            style: TextStyle(
                              fontSize: 24.0,
                              color:Color(0xffffdd9a),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10,),

                    StarDisplay( value: 4,),

                    SizedBox(height: 16.0),
                    Text(
                      "${reviewList.length} Reviews",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20,),


                Container(
                  height: 120,
                  width:MediaQuery.of(context).size.width*0.5,
                  child: ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Text(
                            "${index + 1}",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          SizedBox(width: 4.0),
                          Icon(Icons.star, color: Color(0xffffdd9a)),
                          SizedBox(width: 4.0),
                          LinearPercentIndicator(
                            lineHeight: 6.0,
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            width: MediaQuery.of(context).size.width / 2.8,
                            animation: true,
                            animationDuration: 2500,
                            percent: ratings[index],
                            progressColor: Colors.indigo,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),

            FutureBuilder<List<Comment>?>(
                future:_getComments() ,
                builder:
                    (c,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const CircularProgressIndicator(color: Colors.orange,);
                  } else if(snapshot.hasData || (snapshot.data?.isNotEmpty??false)){
                    snapshot.data!.sort(
                          (a, b) => b.time.compareTo(a.time),
                    );
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      //scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                      itemCount: snapshot.data?.length??0,
                      itemBuilder: (context, index) {
                        return Container(
                          padding:const EdgeInsets.only(
                            top: 2.0,
                            bottom: 2.0,
                            left: 16.0,
                            right: 0.0,
                          ),
                          child: FutureBuilder<User?>(
                            builder: (context,userSnapshot){
                              if(userSnapshot.connectionState == ConnectionState.waiting){
                                return Container(width: MediaQuery.of(context).size.width*0.9,
                                  height: 50,

                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withOpacity(0.5),
                                            Colors.black26.withOpacity(0.5),
                                          ]
                                      )
                                  ),);
                              }else if(userSnapshot.data != null && snapshot.hasData){
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 45.0,
                                          width: 45.0,
                                          margin: EdgeInsets.only(right: 16.0),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(userSnapshot.data!.photoUrl),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.circular(44.0),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.4,
                                          child: Column(
                                            children: [
                                              Text(
                                                userSnapshot.data!.name,
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                DateFormat.yMMMEd().format(snapshot.data![index].time),
                                                style: TextStyle(fontSize: 12.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(left: 48),
                                            child: DropdownButton(
                                              items: itemss
                                                  .map((e) =>
                                                  DropdownMenuItem(
                                                    child: Text("$e"),
                                                    value: e,
                                                  ))
                                                  .toList(),
                                              onChanged: (val) {},
                                              enableFeedback: false,
                                              iconEnabledColor: Colors.orange,
                                              iconDisabledColor: Colors.indigo,
                                              elevation: 0,
                                              borderRadius: BorderRadius.zero,
                                            )
                                          // IconButton(
                                          //   onPressed:(){
                                          //
                                          //     setState(() {
                                          //
                                          //     });
                                          //   },
                                          //   icon: Icon(Icons.more_vert),
                                          // ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2.0),
                                    Row(
                                      children: [
                                        SizedBox(width: 10),
                                      ],
                                    ),
                                    SizedBox(height: 8.0),
                                    GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          snapshot.data![index].txt,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black,
                                          ),
                                        )),
                                    Divider(
                                      thickness: 3,
                                      color: Colors.grey[200],
                                      indent: 20,
                                      endIndent: 20,
                                    )
                                  ],
                                );
                              }else{
                                print(userSnapshot.data);
                                return const Text("This user have some problem");
                              }
                            },
                            future: _getUserData(snapshot.data![index].userId),
                          ),
                        );

                        // return ReviewUI(
                        //   image: reviewList[index].image,
                        //   name: reviewList[index].name,
                        //   date: reviewList[index].date,
                        //   comment: reviewList[index].comment,
                        //   rating: reviewList[index].rating,
                        //   onPressed: () => print("More Action $index"),
                        //   onTap: () => setState(() {
                        //     isMore = !isMore;
                        //   }),
                        //   isLess: isMore,
                        // );
                      },
                      // itemBuilder: (context, index) {
                      //      return Divider(
                      //        thickness: 2.0,
                      //        color: Colors.orangeAccent,
                      //      );
                      //    },
                    );
                  }else{
                    return const Text("There is No comment");
                  }
                }),
            const SizedBox(height: 25,)

          ],
        ),
      ),
    );
  }

  ///rate now start
  Widget rate() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ratingg(),
          const SizedBox(
            height: 20,
          ),
          enterComment(),
          const SizedBox(
            height: 10,
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _submitLoading,
            builder: (context, value, widget) => value
                ? const CircularProgressIndicator(
              color: Colors.orange,
            )
                : widget!,
            child: ElevatedButton(
              onPressed: rating >= 0
                  ? () async {
                try {
                  _submitLoading.value = true;
                  await DataBaseClintServer.updateTourRate(
                      newRate: rating.floor() - 1,
                      id: widget.tour.id,
                      oldRate: widget.tour.rate[rating.floor() - 1])
                      .then((value) {
                    setState(() {
                      widget.tour.rate[rating.floor() - 1] =
                          widget.tour.rate[rating.floor() - 1] + 1;
                    });
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Thanks for your feedback!')));
                    _submitLoading.value = false;
                  });
                } catch (e) {
                  _submitLoading.value = false;
                  debugPrint(e.toString());
                  ScaffoldMessenger.of(context).clearSnackBars();
                  if (rating < 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please chose your rate')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error happened')));
                  }
                }
              }
                  : null,
              style: ElevatedButton.styleFrom(primary: Colors.orange),
              child: const Text("Submit"),
            ),
          )
        ],
      ),
    );
  }

  Widget ratingg() {
    //double rating=0;
    return Center(
        child: Row(
          children: [
            RatingBar.builder(
              maxRating: 1,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
                size: 10,
              ),
              onRatingUpdate: (rating) => setState(() {
                this.rating = rating;
              }),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              S.of(context).pageRating,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ));
  }

  final TextEditingController controller = TextEditingController();

  Widget enterComment() {
    return Row(
      children: [
        Container(
          // alignment: Alignment.center,
          //margin: EdgeInsets.only(left: 20, right: 20, top: 20),
          padding: const EdgeInsets.only(left: 20),
          height: 54,
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color(0xffEEEEEE),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0, 20),
                  blurRadius: 100,
                  color: Color(0xffEEEEEE)),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: const Color(0xffF5591F),
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              focusColor: const Color(0xffF5591F),
              hintText: S.of(context).pageEnterComment,
            ),
            onFieldSubmitted: (val) async {
              if(Authentication.user ==null){
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (c)=>myLogin(),
                    )
                );
              }else {
                User? u = await DataBaseClintServer.getUser(Authentication.user!.email?.split('.').first??"");
                if(u == null)return;
                try {
                  _commentLoading.value = true;
                  await DataBaseClintServer.addCommentToTour(
                      userId: u.id,
                      tourId: widget.tour.id,
                      comments: widget.tour.comments,
                      comment:Comment(
                          userId: u.id,
                          time: DateTime.now(),
                          id: '',
                          txt: controller.text
                      ));
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Thanks for your feedback!')));
                  _commentLoading.value = false;
                } catch (e) {
                  _commentLoading.value = false;
                  debugPrint(e.toString());
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error happened')));
                }
              }
            },
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white38,
            boxShadow: [
              const BoxShadow(
                  offset: Offset(0, 20),
                  blurRadius: 100,
                  color: Colors.white70),
            ],
          ),
          child: ValueListenableBuilder<bool>(
            valueListenable: _commentLoading,
            builder: (c,value,child)=>value?const CircularProgressIndicator(color: Colors.orange,):child!,
            child: IconButton(
              onPressed: () async {
                if(Authentication.user ==null){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (c)=>myLogin(),
                    )
                  );
                }else {
                  User? u = await DataBaseClintServer.getUser(Authentication.user!.email?.split('.').first??'');
                  if(u == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Some error in authentication")));
                    return;
                  }
                  try {
                  _commentLoading.value = true;
                  await DataBaseClintServer.addCommentToTour(
                      userId: u.id,
                      tourId: widget.tour.id,
                      comments: widget.tour.comments,
                      comment:Comment(
                        userId: u.id,
                        time: DateTime.now(),
                        id: '',
                        txt: controller.text
                      ));
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Thanks for your feedback!')));
                  _commentLoading.value = false;
                } catch (e) {
                  _commentLoading.value = false;
                  debugPrint(e.toString());
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error happened')));
                }
                }
              },
              icon: ValueListenableBuilder<bool>(
                valueListenable: _commentLoading,
                builder: (c, value, child) => value
                    ? const CircularProgressIndicator(color: Colors.orange)
                    : child!,
                child: const Icon(
                  Icons.comment_outlined,
                  color: Colors.lightBlueAccent,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ///end
  ///list of buttons
  Widget buildContainer1(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedindex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          children: [
            Container(
              //  height: 20,
//padding: EdgeInsets.symmetric(horizontal: 8,vertical: 20),
              width: size.width * 0.25,
              decoration: BoxDecoration(
                  color:
                  selectedindex == index ? Colors.orange : Colors.white70,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xffffdd9a))),
              child: Center(
                child: Text(
                  S.of(context).pageDetail,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color:
                    selectedindex == index ? Colors.white : Colors.orange,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContainer2(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedindex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          children: [
            Container(
              //  height: 20,
//padding: EdgeInsets.symmetric(horizontal: 8,vertical: 20),
              width: size.width * 0.25,
              decoration: BoxDecoration(
                  color:
                  selectedindex == index ? Colors.orange : Colors.white70,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xffffdd9a))),
              child: Center(
                child: Text(
                  S.of(context).pageReviews,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color:
                    selectedindex == index ? Colors.white : Colors.orange,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContainer3(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedindex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          children: [
            Container(
              //  height: 20,
//padding: EdgeInsets.symmetric(horizontal: 8,vertical: 20),
              width: size.width * 0.25,
              decoration: BoxDecoration(
                  color:
                  selectedindex == index ? Colors.orange : Colors.white70,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xffffdd9a))),
              child: Center(
                child: Text(
                  S.of(context).pageRateNow,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color:
                    selectedindex == index ? Colors.white : Colors.orange,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

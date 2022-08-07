import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:safari/localization/localization_bloc.dart';
import 'package:safari/models/offices/restaurant.dart';
import 'package:safari/restaurant/bloc/restaurant_cubit.dart';
import 'package:safari/restaurant/bloc/restaurant_states.dart';
import 'package:safari/reviewmodle.dart';
import 'package:safari/server/authintacation.dart';
import 'package:safari/stars/star.dart';
import 'package:safari/maps.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:url_launcher/url_launcher.dart';
import '../login/presentation/hello.dart';
import '../models/offices/restaurant.dart' as r;
import '../models/components/comments.dart';
import '../models/components/user.dart' as u;
import '../server/database_client.dart';



class RestaurantScreen extends StatefulWidget {
  final r.Restaurant restaurant;
  const RestaurantScreen({Key? key,required this.restaurant}) : super(key: key);

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
String? _comment ;
final ValueNotifier<bool> _commentLoading = ValueNotifier(false);
final ValueNotifier<bool> _rateLoading = ValueNotifier(false);



    void customLaunch(command)async{
    if(await canLaunch(command)){
      await UrlLauncher.launch(command);
    }else{
      print('could not launch $command');
    }
  }


    Future<List<Comment>?> _getComments(){
      try {
          return DataBaseClintServer.getComments(widget.restaurant.comments);
      } catch(e) {
       debugPrint(e.toString());
       return Future(() => null);
      }
    }


    Future<void> _addCommentToRestaurant(
        String? userId,
        String txt) async {
      try {
        if (userId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("You have to be authenticated")));
        } else {
          Comment comment =
          Comment(id: 'id', time: DateTime.now(), txt: txt, userId: userId);
          await DataBaseClintServer.addCommentToRestaurant(
              userId: userId,
              comments: widget.restaurant.comments,
              comment: comment,
              rasId:widget.restaurant.id );
          widget.restaurant.comments.add(userId);
        }
      } catch (e) {
        debugPrint(e.toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("some error happened")));
      }
    }




    Future<u.User?> _getUserData(String userId)async{
      print(userId);
      try{
        return await DataBaseClintServer.getUser(userId);
      }catch(e){
        debugPrint(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('some error happened')));
      }
    }


  List<String>buttons=[
    'Detail',
    'reviews',
    'rate now'
  ];
  int selectedindex=0;
  double rating=0;


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RestaurantCubit(RestaurantInitState()),
      child: BlocConsumer<RestaurantCubit,RestaurantState>(
        listener: (context, state){
          if (state is RestaurantLoadingErrorState){
             ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message))
              );
          }
        },
        builder: (context, state){
          if(state is RestaurantLoading){
              return Center(
                    child: CircularProgressIndicator(),
                  );
          }
          else {
            return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                     color: Colors.black26,

                ),

                child: Center(
                  child: IconButton(
                    onPressed: (){
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
          body: SingleChildScrollView(
            child:
            Column(
                 children: [
                      _CarouselSlider(),
                      SizedBox(height: 20,),
                         Container(
                padding: EdgeInsets.only(left: 10),
                height: 40,
                child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  buildContainer1(context, 0),
                                  SizedBox(width: 10,),
                                  buildContainer2(context, 1),
                                  SizedBox(width: 10,),
                                  buildContainer3(context, 2),
                                  SizedBox(width: 10,),
                                ],
                              ),
                            ),
                // ListView.builder(
                //     physics: BouncingScrollPhysics(),
                //     scrollDirection: Axis.horizontal,
                //     itemCount:buttons.length ,
                //     itemBuilder: (context,index){
                //       return _buildlist(context, index);

                //     }),

              ),
              SizedBox(height: 1,),

              Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(height: 10,),
                    selectedindex==0?Detail(): selectedindex==1?Reviews():Rate(),
                  ],),
                ),
              ),



                 ],
            ),
          ),
        );
          }

        }),
    );
  }

  Widget _CarouselSlider() {
    return CarouselSlider(items: widget.restaurant.imagesPath.map((e) =>
        ClipRRect(

          borderRadius: BorderRadius.only(bottomRight: Radius.circular(35),bottomLeft: Radius.circular(35),),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(e, width: double.infinity,fit: BoxFit.cover),
                 Positioned(
                        bottom: 10,
                        left: 0,
                        child: Container(
                          // width: (MediaQuery.of(context).size.width)-250,
                          // height: 40,

                          padding: EdgeInsets.only(left: 20,bottom: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: (MediaQuery.of(context).size.width)-70,
                                child:  Text(
                                  widget.restaurant.description,
                                  style:const TextStyle(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                     ),
                            ),
                              ),
                              SizedBox(height: 5,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width)-70,
                                child: const Text(
                                  "Enjoy beautiful places in our Fairy Meadows and Naran",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                     ),
                            ),
                              ),
                              const SizedBox(height: 15,),
                              Container(
                                width: (MediaQuery.of(context).size.width),
                                child: Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                          Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children:  [
                                    const Icon(
                                      Icons.place,
                                      size: 25,
                                    ),
                                    const SizedBox(width: 5,),
                                    Text(
                                      widget.restaurant.country,
                                      style:const TextStyle(
                                        color: Colors.white,

                                      ),
                                    ),
                                  ],
                                ),
                                        const SizedBox(height: 15,),
                                        const IconTheme(
                                 data: IconThemeData(
                                   color: Colors.amber,
                                   size: 20,
                                 ),
                                 child: StarDisplay(value: 4),
                                    ),

                                      ],
                                    ),
                                    SizedBox(width: (MediaQuery.of(context).size.width)-170,),
                                    Align(
                                  alignment: Alignment.centerRight,
                                  child:   LikeButton(
                                      onTap: (isTaped) async {
                                        if (Authentication.user == null) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (c) => myLogin()));
                                        } else {
                                          bool isLiked =  widget.restaurant.loves
                                              .contains(Authentication.user?.uid);
                                          await DataBaseClintServer.love(
                                              userId: Authentication.user!.uid,
                                              loveList: widget.restaurant.loves,
                                              isLove: isLiked,
                                              ref:
                                              'restaurants/${widget.restaurant.id}');

                                          if (!isLiked) {
                                            widget.restaurant.loves
                                                .add(Authentication.user!.uid);
                                            setState((){});
                                            return true;

                                          } else {
                                            widget.restaurant.loves.remove(
                                                Authentication.user!.uid);
                                            setState((){});
                                            return false;
                                          }


                                        }
                                      },
                                    isLiked :widget.restaurant.loves.contains(Authentication.user?.uid??''),
                                    // likeCount:lovecount,

                                    likeBuilder: (bool isLiked) {
                                 return Icon(
                                   Icons.favorite_outline,
                                   color: isLiked ? Colors.pinkAccent: Colors.white,
                                   size: 35.0,

                                 );
                                 onPressed: () {
                                   Navigator.pop(context);
                                 };
                                    },

                                  ),

                                ),

                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),

            ],
          ),
        )).toList(),
      options: CarouselOptions(
        viewportFraction: 1,
        autoPlayInterval: Duration(seconds: 4),
        autoPlay: true,
        enableInfiniteScroll: true,

        height: (MediaQuery.of(context).size.height)-250,
      ),
    );
  }

  Widget _buildlist(BuildContext context,int index){
    Size size=MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        setState(() {
          selectedindex=index;
        });

      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
           height: size.height*0.4,
//padding: EdgeInsets.symmetric(horizontal: 8,vertical: 20),
          width: size.width*0.4,
          decoration: BoxDecoration(
              color:selectedindex==index?Colors.pink: Colors.white70,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.pink)

          ),
          child: Center(
            child: Text(
              buttons[index],
              style: TextStyle(fontWeight: FontWeight.bold,
                  color: selectedindex==index? Colors.white:Colors.pink
              ),
            ),
          ),
        ),
      ),
    );

  }



  Widget Detail(){
     return SingleChildScrollView(
          child: Column(
            children: [
              //  SizedBox(height: 20,),
                      Container(

                        width: (MediaQuery.of(context).size.width),
                        child: Card(
                          shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(35),
                             ),
                          elevation: 1,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20,left: 20),
                            child: Column(

                              children: [
                                Row(

                                  children: [
                                    Text(
                                      LocalizationCubit.get(context).localization ? 'اوقات الدوام' : 'Time : ',
                                      // "Time : ",
                                      style: TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      "${(widget.restaurant.timeFrom.hour%12).toString().padLeft(2,'0')}:${widget.restaurant.timeFrom.minute.toString().padLeft(2,'0')}"
                                          " ${widget.restaurant.timeFrom.hour>12?"PM":"AM"}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(width: 3,),
                                    Text(
                                      "-",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      ),
                                      SizedBox(width: 3,),
                                    Text(
                                      "${(widget.restaurant.timeTo.hour%12).toString().padLeft(2,'0')}:${widget.restaurant.timeTo.minute.toString().padLeft(2,'0')}"
                                          " ${widget.restaurant.timeTo.hour>12?"PM":"AM"}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                 Row(

                                  children: [
                                    Text(
                                      LocalizationCubit.get(context).localization ? 'نوع الطعام : ' : 'Type : ',
                                      // "Type : ",
                                      style: TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      widget.restaurant.foodType,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                   ],
                                ),
                                SizedBox(height: 10,),
                                Row(

                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.call,
                                  size: 30,
                                  color: Colors.indigo,

                                ),
                                onPressed: (){
                                  customLaunch('tel:${widget.restaurant.phone['call']}');
                                },
                              ),
                              SizedBox(width: 10,),
                              Text(
                                widget.restaurant.phone['call'].toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                              ],
                            ),
                          ),

                        ),
                      ),
                      SizedBox(height: 15,),
                        Padding(
              padding: const EdgeInsets.only(right: 230),
              child: Text(
                LocalizationCubit.get(context).localization ? 'الموقع' : 'LOCATION',//'LOCATION',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                ),
              )
          ),
          SizedBox(height: 20,),

          MaterialButton(
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context)=>Maps(),),);
            },
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[500],
                image: new DecorationImage(image: AssetImage("images/map.jpg"),fit:BoxFit.cover,),
              ),

            ),
          ),
         SizedBox(height: 15,),
                      Container(
                        height: 60,
                        width: (MediaQuery.of(context).size.width)-40,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocalizationCubit.get(context).localization ? 'قم بزيارته الان' : 'Visit Now',
                                // "Visit Now",
                                  style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1,
                                         ),
                              ),
                              SizedBox(width: 10,),
                              Icon(
                                Icons.account_balance_outlined,
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                           color: Colors.pink,
                           borderRadius: BorderRadius.circular(20),
                           border: Border.all(color: Color(0xffffdd9a))

              ),
                      ),
                      SizedBox(height: 20,),
            ],
          ),
     );
  }

   Widget Reviews(){
    bool isless=false;
    bool isMore = false;
    var select='bmw';
    List<String>itemss=['report'];
    double sum = 1 ;
    for(int i in widget.restaurant.stars){
      sum+=i;
    }
    List<double> ratings =widget.restaurant.stars.map((e) =>((e*100/sum)/100)).toList();
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
                            text:(widget.restaurant.rateAverage()-1).toString(),
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
                          child: FutureBuilder<u.User?>(
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
  Widget Rate(){
    return Center(
      child: Column(
        children: [ratingg(),
          SizedBox(height: 20,),
          EnterComment(),
          SizedBox(height: 10,),

        ],
      ),
    );

  }

Widget ratingg(){
  //double rating=0;
  return Center(child: Row(children: [
    RatingBar.builder(
      maxRating: 1,
      itemBuilder: (context,_)=>
          Icon(Icons.star,color: Colors.amber,size: 10,),
      onRatingUpdate: (rating)=>setState(() {
        this.rating=rating;
      }),
    ),
    SizedBox(width: 10,),
    InkWell(
      onTap: ()async{
        if(rating-1<0 || rating-1 >=5){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid rate")));
          return ;
        }
        try{
          print("rating loading...");
          _rateLoading.value = true;
            await DataBaseClintServer.rate(rating.floor()-1, 'restaurants', widget.restaurant.id, widget.restaurant.stars).then((value) {
              _rateLoading.value = false;
              print("rating finshed");
            });

        }catch(e){
          _rateLoading.value = false;
          debugPrint(e.toString());
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Some error happened")));
        }
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: _rateLoading,
        builder: (context,value,child)=>value?const CircularProgressIndicator(
          color: Colors.orange,
        ):child!,
        child: Row(
          children: [
            Text(
              "Done",
              style:TextStyle(fontSize: 25,
                  color: Colors.green) ,
            ),
            Icon(Icons.done,color: Colors.green,)
          ],
        ),
      ),
    ),


  ],)
  );
}
  Widget EnterComment(){
    return Row(
      children: [
        Container(

          padding: EdgeInsets.only(left: 20 ),
          height: 54,
          width: 250,
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(50),
            color: Color(0xffEEEEEE),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 20),
                  blurRadius: 100,
                  color: Color(0xffEEEEEE)
              ),
            ],
          ),
          child: TextFormField(

            keyboardType: TextInputType.visiblePassword,

            cursorColor: Color(0xffF5591F),
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              focusColor: Color(0xffF5591F),

              hintText: LocalizationCubit.get(context).localization ? 'اكتب التعليق' : 'Enter Comment',
//"Enter Comment",


            ),
            onChanged: (val){
              _comment = val;
            },
            onFieldSubmitted: (val)async{
              _comment = val;
              if (Authentication.user == null) {
                //the user is not logged in
                Navigator.of(context).push(MaterialPageRoute(builder: (c) =>
                    myLogin()));
              } else if (_comment == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const  SnackBar(content:  Text("You must enter a comment")));
              }


              else {
                //the user is logged in
                try {
                  _commentLoading.value = true;
                  u.User? user = await DataBaseClintServer.getUser(Authentication.user!.email?.split('.').first??'');
                  if(user == null ) return;
                    await _addCommentToRestaurant(
                         user.id,_comment!,);

                  _commentLoading.value = false;
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const  SnackBar(content:  Text("⨮ Adding successfully")));
                } catch (e) {
                  _commentLoading.value = false;
                  debugPrint(e.toString());
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const  SnackBar(content:  Text("Error in adding this comment")));
                }
              }
            },


          ),

        ),
        SizedBox(width: 2,),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white38,
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 20),
                  blurRadius: 100,
                  color: Colors.white70
              ),
            ],
          ),
            child:ValueListenableBuilder<bool>(
              valueListenable: _commentLoading,
              builder: (c, value, child) =>
              value ? const CircularProgressIndicator(
                color: Colors.orange,
              ) : child!,
              child:IconButton(
                onPressed: () async {
                  if (Authentication.user == null) {
                    //the user is not logged in
                    Navigator.of(context).push(MaterialPageRoute(builder: (c) =>
                        myLogin()));
                  } else if (_comment == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const  SnackBar(content:  Text("You must enter a comment")));
                  }


                  else {
                    //the user is logged in
                    try {
                      _commentLoading.value = true;
                      u.User? user = await DataBaseClintServer.getUser(Authentication.user!.email?.split('.').first??'');
                      if(user == null ) return;
                      await _addCommentToRestaurant(
                        _comment!, user.id,);
                      _commentLoading.value = false;
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const  SnackBar(content:  Text("⨮ Adding successfully")));
                    }  catch (e) {
                      _commentLoading.value = false;
                      debugPrint(e.toString());
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const  SnackBar(content:  Text("Error in adding this comment")));
                    }
                  }
                },
                icon: const Icon(
                  Icons.comment_outlined,
                  color: Colors.lightBlueAccent,
                ),
              ) ,
            )
        ),






      ],
    );


  }

  ///list of buttons
  Widget buildContainer1(BuildContext context,int index){
    Size size=MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        setState(() {
          selectedindex=index;
        });

      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          children: [
             Container(
           height: size.height*0.4,
//padding: EdgeInsets.symmetric(horizontal: 8,vertical: 20),
          width: size.width*0.4,
          decoration: BoxDecoration(
              color:selectedindex==index?Colors.pink: Colors.white70,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xffe91e63))

          ),
          child: Center(
            child: Text(
              LocalizationCubit.get(context).localization ? 'التفاصيل' : 'details',
              // S.of(context).pageDetail,
              style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: selectedindex==index? Colors.white:Colors.pink,
              ),
            ),
          ),
        ),
          ],
        ),
      ),
    );

  }

  Widget buildContainer2(BuildContext context,int index){
    Size size=MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        setState(() {
          selectedindex=index;
        });

      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          children: [
             Container(
           height: size.height*0.4,
//padding: EdgeInsets.symmetric(horizontal: 8,vertical: 20),
          width: size.width*0.4,
          decoration: BoxDecoration(
              color:selectedindex==index?Colors.pink: Colors.white70,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xffe91e63))

          ),
          child: Center(
            child: Text(
              // S.of(context).pageReviews,
               LocalizationCubit.get(context).localization ? 'الاراء' : 'reviews',
              style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: selectedindex==index? Colors.white:Colors.pink,
              ),
            ),
          ),
        ),

          ],
        ),
      ),
    );

  }

  Widget buildContainer3(BuildContext context,int index){
    Size size=MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        setState(() {
          selectedindex=index;
        });

      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          children: [
             Container(
           height: size.height*0.4,
//padding: EdgeInsets.symmetric(horizontal: 8,vertical: 20),
          width: size.width*0.4,
          decoration: BoxDecoration(
              color:selectedindex==index?Colors.pink: Colors.white70,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xffe91e63))

          ),
          child: Center(
            child: Text(
              // S.of(context).pageRateNow,
               LocalizationCubit.get(context).localization ? 'قيم الان' : 'rate now',
              style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: selectedindex==index? Colors.white:Colors.pink,
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
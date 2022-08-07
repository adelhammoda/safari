import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:safari/login/presentation/hello.dart';
import 'package:safari/models/components/landmark.dart';
import 'package:safari/places/bloc/places_cubit.dart';
import 'package:safari/places/bloc/places_states.dart';
import 'package:safari/places/datalayer/places_model.dart';
import 'package:safari/server/authintacation.dart';
import 'package:safari/server/database_client.dart';
import 'package:safari/stars/star.dart';
import 'package:safari/maps.dart';
import 'package:safari/localization/localization_bloc.dart';

class PlacesScreen extends StatefulWidget {
  // const PlacesScreen({Key? key}) : super(key: key);

  final Landmark landmark;

  const PlacesScreen({required this.landmark, Key? key}) : super(key: key);

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  // late AddPlacesModel placemodel;
  late int placemodel;
  late String city;

  // late List<String> imagelist2;

  int current = 0;

  @override
  void initState() {
    // BlocProvider.of<PlacesCubit>(context).GetOnePlaceRequest(city, placemodel);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 20,
            height: 20,
            child: Center(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black26,
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: PlaceList(),
    );
  }

  Widget PlaceList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _CarouselSlider(), // SizedBox(height: 20,),
          Container(
            height: (MediaQuery.of(context).size.height) * 0.2,
            width: (MediaQuery.of(context).size.width),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
              elevation: 1,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          LocalizationCubit.get(context).localization
                              ? 'اوقات الدوام:'
                              : 'Time : ',
                          // "Time : ",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${(widget.landmark.timeFrom.hour).toString().padLeft(2, '0')}:${widget.landmark.timeFrom.minute}",
                          // "8 AM",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          "-",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          "${(widget.landmark.timeTo.hour).toString().padLeft(2, '0')}:${widget.landmark.timeTo.minute}",
                          // "9 PM",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          LocalizationCubit.get(context).localization
                              ? 'الايام:'
                              : 'Days : ',
                          // "Days : ",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.landmark.dayFrom,
                          // "Friday",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          "-",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          widget.landmark.dayTo,
                          // "Tuesday",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          LocalizationCubit.get(context).localization
                              ? 'التكلفة:'
                              : 'Total costs : ',
                          // "Total: ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          widget.landmark.cost.toString(),
                          // "1500.0",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
              padding: const EdgeInsets.only(right: 230),
              child: Text(
                LocalizationCubit.get(context).localization
                    ? 'الموقع'
                    : 'LOCATION',
                // 'LOCATION',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )),
          SizedBox(
            height: 20,
          ),

          MaterialButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Maps(),
                ),
              );
            },
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[500],
                image: new DecorationImage(
                  image: AssetImage("images/map.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 60,
            width: (MediaQuery.of(context).size.width) - 40,
            decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xffffdd9a))),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocalizationCubit.get(context).localization
                        ? 'قم بزيارته'
                        : 'Visit Now',
                    // "Visit Now",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.account_balance_outlined,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _CarouselSlider() {
    return CarouselSlider(
      items: widget.landmark.images
          .map((e) => ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(35),
                  bottomLeft: Radius.circular(35),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(e, width: double.infinity, fit: BoxFit.cover),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      child: Container(
                        // width: (MediaQuery.of(context).size.width)-250,
                        // height: 40,

                        padding: EdgeInsets.only(left: 20, bottom: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width) - 70,
                              child: Text(
                                widget.landmark.name,
                                // "Enjoy the Fairy Meadows",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width) - 70,
                              child: Text(
                                widget.landmark.description,
                                // "Enjoy beautiful places in our Fairy Meadows and Naran",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: (MediaQuery.of(context).size.width),
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.place,
                                            size: 25,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            widget.landmark.location['city']
                                                .toString(),
                                            // "Pakistan",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      IconTheme(
                                        data: IconThemeData(
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                        child: StarDisplay(value: 5),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width) -
                                        170,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: LikeButton(
                                      onTap: (isTaped) async {
                                        if (Authentication.user == null) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (c) => myLogin()));
                                        } else {
                                         bool isLiked =  widget.landmark.love
                                              .contains(Authentication.user?.uid);
                                         await DataBaseClintServer.love(
                                             userId: Authentication.user!.uid,
                                             loveList: widget.landmark.love,
                                             isLove: isLiked,
                                             ref:
                                             'transportation_office/${widget.landmark.id}');

                                            if (!isLiked) {
                                              widget.landmark.love
                                                  .add(Authentication.user!.uid);
                                              setState((){});
                                              return true;

                                            } else {
                                              widget.landmark.love.remove(
                                                  Authentication.user!.uid);
                                              setState((){});
                                              return false;
                                            }


                                        }
                                      },
                                      isLiked: widget.landmark.love
                                          .contains(Authentication.user?.uid),
                                      // likeCount:lovecount,

                                      likeBuilder: (bool isLiked) {
                                        return Icon(
                                          Icons.favorite_outline,
                                          color: isLiked
                                              ? Colors.pinkAccent
                                              : Colors.white,
                                          size: 35.0,
                                        );
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
              ))
          .toList(),
      options: CarouselOptions(
        viewportFraction: 1,
        autoPlayInterval: Duration(seconds: 4),
        autoPlay: true,
        enableInfiniteScroll: true,
        height: (MediaQuery.of(context).size.height) - 250,
      ),
    );
  }
}

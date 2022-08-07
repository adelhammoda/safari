import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:safari/models/offices/airplanes.dart';
import 'package:safari/server/database_client.dart';
import '../models/components/flight.dart' as f;

class Flight extends StatefulWidget {
  final Airplanes airplanes;
  final String from;
  final String to;

  const Flight(
      {Key? key, required this.airplanes, required this.from, required this.to})
      : super(key: key);

  @override
  _FlightState createState() => _FlightState();
}

class _FlightState extends State<Flight> {
  final controller = TextEditingController();

  bool booking = false;

  Future<void> showinformation(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                  //  var height = MediaQuery.of(context).size.height;
                  // var width = MediaQuery.of(context).size.width;

                  return Container(
                    width: 256,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 10.0, left: 10, top: 10),
                          child: Row(
//   mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 20,
                                    width: 80,
                                    child: Center(
                                      child: Text(
                                        "ESB Ankara esenboga Airport",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "00:10",
                                    style: TextStyle(
                                        color: Color(0xff0a4467),
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // RichText(text: TextSpan(
                                  //     text:"00:11",style:
                                  // textstyle(
                                  //   color: Colors.indigo,
                                  //   fontSize: 25,
                                  // ),
                                  //  children: [
                                  //
                                  //    TextSpan(text: 'PM',style: textstyle(
                                  //      color: Colors.indigo,
                                  //      fontSize: 18,
                                  //      ))
                                  //  ]
                                  // )
                                  // )
                                ],
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.transparent,
                                  image: new DecorationImage(
                                    image: AssetImage("images/aircraft.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 35,
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 20,
                                    width: 80,
                                    child: Center(
                                      child: Text(
                                        "ESB Ankara esenboga Airport",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "00:10",
                                    style: TextStyle(
                                        color: Color(0xff0a4467),
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Container(
                            height: 20,
                            width: 85,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                border: Border.all(color: Color(0xffffdd9a))),
                            child: Row(
                              children: [
                                Text(
                                  "  10h45m 1stop  ",
                                  style: TextStyle(
                                      color: Colors.grey[800], fontSize: 10),
                                ),
                                Icon(
                                  Icons.timer,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        ///if var  round trip true :
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 10.0, left: 10, top: 10),
                          child: Row(
//   mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Column(children: [
                              //   Container(
                              //     height: 20,
                              //     width:80,
                              //     child: Center(
                              //       child: Text(" Amman Queen Alia International Airport",
                              //         style: TextStyle(
                              //             color: Colors.grey,
                              //             fontSize: 10,
                              //             fontWeight: FontWeight.w400),),
                              //     ),
                              //   ),
                              //   SizedBox(height: 5,),
                              //
                              //   Text("19:30",style: TextStyle(
                              //       color: Color(0xff0a4467),
                              //       fontSize: 25,
                              //       fontWeight: FontWeight.bold),),
                              //
                              // ],),
                              SizedBox(
                                width: 35,
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.transparent,
                                  image: new DecorationImage(
                                    image: AssetImage("images/aircraft.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              // Column(children: [
                              //   Container(
                              //     height: 20,
                              //     width:80,
                              //     child: Center(
                              //       child: Text("ESB Ankara esenboga Airport",
                              //
                              //         style: TextStyle(
                              //             color: Colors.grey,
                              //             fontSize: 10,
                              //             fontWeight: FontWeight.w400),),
                              //     ),
                              //   ),
                              //   SizedBox(height: 5,),
                              //   Text("00:10",style: TextStyle(
                              //       color: Color(0xff0a4467),
                              //       fontSize: 25,
                              //       fontWeight: FontWeight.bold),),
                              //
                              // ],)
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Center(
                        //   child: Container(
                        //     height: 20,
                        //     width: 85,
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(15),
                        //         color: Colors.white,
                        //         border: Border.all(color:  Color(0xffffdd9a))
                        //
                        //     ),
                        //     child: Row(children: [
                        //       Text("  10h45m 1stop  ",style: TextStyle(color: Colors.grey[800],fontSize:10),),
                        //       Icon(Icons.timer,size: 14,color: Colors.grey,),
                        //     ],),
                        //   ),
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 150),
                              child: Text("services"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Container(
                                  child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.local_dining_outlined,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.wifi,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.cable,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.local_movies_rounded,
                                    color: Colors.grey,
                                  ),
                                ],
                              )),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ));
  }

  double? height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    Future<List<f.Flight>?> _getFlights() async {
      try {
        List<f.Flight>? res = await DataBaseClintServer.getAllFlight();
        List<f.Flight> filteredList = [];
        if (res != null && res.isNotEmpty) {
          for (String fId in widget.airplanes.flightId) {
            f.Flight flight = res.firstWhere((element) {
              return element.id == '-$fId';
            },
                orElse: () => f.Flight(
                    id: 'id',
                    cost: 100,
                    relax: 90,
                    dateFrom: DateTime.now(),
                    dateTo: DateTime.now(),
                    from: 'from',
                    numberOfPassengers: 2,
                    passengersCapacity: 2,
                    to: 'to'));
            if (flight.id != 'id' &&
                flight.from.toLowerCase() == widget.from.toLowerCase() &&
                flight.to.toLowerCase() == widget.to.toLowerCase()) {
              filteredList.add(flight);
            }
          }
        }
        return filteredList;
      } on Exception catch (e) {
        debugPrint(e.toString());
      }
    }

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
      body: Center(
        child: SingleChildScrollView(
          child: FutureBuilder<List<f.Flight>?>(
            future: _getFlights(),
            builder: (c, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                  ),
                );
              } else if (snapshot.hasData &&
                  snapshot.data != null &&
                  (snapshot.data?.isNotEmpty ?? false)) {
                print( snapshot.data?.length);
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data?.length??0,
                      itemBuilder: (c,index)=>SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: height! * .4,
                                  //width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color(0xffe3f1f2),
                                    image: const DecorationImage(
                                      image: AssetImage("images/TRAVEL_CONCEPT.jpg"),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: height! * .6,
                                  //width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey[100],
                                    //   border: Border.all(color: Color(0xffffdd9a),width: 3)
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 250,
                              left: 30,
                              right: 30,
                              bottom: 280,
                              child: Stack(
                                children: [
                                  ConstrainedBox(
                                    constraints: new BoxConstraints.expand(),
                                    child: Container(
                                      width: 256,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        //borderRadius: BorderRadius.circular(5),
                                        color: Colors.white, shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              widget.airplanes.imagesPath.first),
                                          //fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Swiper.children(
                                      pagination: SwiperPagination(
                                          margin: const EdgeInsets.only(top: 20,bottom: 25),
                                          builder: DotSwiperPaginationBuilder(
                                              color: Colors.grey[400],
                                              activeColor: const Color(0xffffdd9a),
                                              size: 7,
                                              activeSize: 10)),
                                      children: [
                                        Container(
                                          width: 256,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0, left: 10, top: 10),
                                                child: Row(
//   mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children:  [
                                                       const Text(
                                                          "Depart",
                                                          style: TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 18,
                                                              fontWeight:
                                                              FontWeight.w400),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          DateFormat.Hm().format(snapshot.data![index].dateFrom),
                                                          style:const TextStyle(
                                                              color: Color(0xff0a4467),
                                                              fontSize: 25,
                                                              fontWeight:
                                                              FontWeight.bold),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 30,
                                                    ),
                                                    Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(15),
                                                        color: Colors.transparent,
                                                        image: const DecorationImage(
                                                          image: AssetImage(
                                                              "images/aircraft.png"),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 40,
                                                    ),
                                                    Column(
                                                      children:  [
                                                        const Text(
                                                          "Arrive",
                                                          style: TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 15,
                                                              fontWeight:
                                                              FontWeight.w400),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          DateFormat.Hm().format(snapshot.data![index].dateTo),
                                                          style:const TextStyle(
                                                              color: Color(0xff0a4467),
                                                              fontSize: 25,
                                                              fontWeight:
                                                              FontWeight.bold),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Center(
                                                child: Container(
                                                  height: 20,
                                                  width: 95,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(15),
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color:
                                                          const Color(0xffffdd9a))),
                                                  child:  Text("    ${
                                                      snapshot.data![index].dateFrom.difference(snapshot.data![index].dateTo).inHours.abs()
                                                  }h ${
                                                      snapshot.data![index].dateFrom.difference(snapshot.data![index].dateTo).inHours%60
                                                  }M "),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0, left: 10, bottom: 5),
                                                child: Row(
//   mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children:  [
                                                        Text(
                                                          DateFormat.EEEE().format(snapshot.data![index].dateFrom),
                                                          style:const TextStyle(
                                                              color: Color(0xff0a4467),
                                                              fontSize: 15,
                                                              fontWeight:
                                                              FontWeight.w400),
                                                        ),
                                                        const  SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          DateFormat.MMMMd().format(snapshot.data![index].dateTo),
                                                          style: TextStyle(
                                                              color: Color(0xff0a4467),
                                                              fontSize: 10,
                                                              fontWeight:
                                                              FontWeight.bold),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 25,
                                                    ),
                                                    MaterialButton(
                                                        onPressed: () async {
                                                          // Navigator.push(
                                                          //     context,
                                                          //     MaterialPageRoute(builder: (BuildContext context) =>Sttack()));
                                                          await showinformation(
                                                              context);
                                                        },
                                                        child: const Icon(
                                                          Icons.info_outline,
                                                          color: Colors.grey,
                                                        )),
                                                    const SizedBox(
                                                      width: 7,
                                                    ),
                                                    Column(
                                                      children:  [
                                                        Text(
                                                          DateFormat.EEEE().format(snapshot.data![index].dateTo),
                                                          style: TextStyle(
                                                              color: Color(0xff0a4467),
                                                              fontSize: 15,
                                                              fontWeight:
                                                              FontWeight.w400),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          DateFormat.MMMMd().format(snapshot.data![index].dateTo),
                                                          style: TextStyle(
                                                              color: Color(0xff0a4467),
                                                              fontSize: 10,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontFamily: 'Sriracha'),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
//                         Container(
//                           width: 256,
//                           height: 170,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             color: Colors.white,
//
//
//                           ),
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 10.0,left: 10,top: 10),
//                                 child: Row(
// //   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Column(children: const[
//                                       Text("Depart",style: TextStyle(
//                                           color: Colors.grey,
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w400),),
//                                       SizedBox(height: 5,),
//                                       Text("19:30",style: TextStyle(
//                                           color: Color(0xff0a4467),
//                                           fontSize: 25,
//                                           fontWeight: FontWeight.bold),),
//
//                                     ],),
//                                     SizedBox(width: 40,),
//                                     Container(
//                                       height: 40,
//                                       width: 40,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(15),
//                                         color: Colors.transparent,
//                                         image: const DecorationImage(image: AssetImage("images/aircraft.png"),fit:BoxFit.cover,),
//                                       ),
//
//                                     ),
//                                     SizedBox(width:40,),
//                                     Column(children: const [
//                                       Text("Arrive",style: TextStyle(
//                                           color: Colors.grey,
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w400),),
//                                       SizedBox(height: 5,),
//                                       Text("00:10",style: TextStyle(
//                                           color: Color(0xff0a4467),
//                                           fontSize: 25,
//                                           fontWeight: FontWeight.bold),),
//
//                                     ],)
//
//                                   ],
//
//                                 ),
//                               ),
//                               const SizedBox(height:10,),
//                               Center(
//                                 child: Container(
//                                   height: 20,
//                                   width: 95,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(15),
//                                       color: Colors.white,
//                                       border: Border.all(color:  const Color(0xffffdd9a))
//
//                                   ),
//                                   child: Text("  20h45m 1stop"),
//                                 ),
//                               ),
//                               const SizedBox(height:30,),
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 10.0,left: 10,bottom: 5),
//                                 child: Row(
// //   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Column(children: const [
//                                       Text("Monday",style: TextStyle(
//                                           color: Color(0xff0a4467),
//                                           fontSize:15,
//                                           fontWeight: FontWeight.w400),),
//                                       SizedBox(height: 5,),
//                                       Text("January 28",style: TextStyle(
//                                           color: Color(0xff0a4467),
//                                           fontSize: 10,
//                                           fontWeight: FontWeight.bold),),
//
//                                     ],),
//                                     const SizedBox(width:45,),
//                                     Container(
//                                       height: 40,
//                                       width: 40,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(15),
//                                         color: Colors.transparent,
//                                         image:const DecorationImage(image: AssetImage("images/aircraft.png"),fit:BoxFit.cover,),
//                                       ),
//
//                                     ),
//                                     const SizedBox(width:45,),
//                                     Column(children: const [
//                                       Text("Tuesday",style: TextStyle(
//                                           color: Color(0xff0a4467),
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w400),),
//                                       SizedBox(height: 5,),
//                                       Text("January 29",style: TextStyle(
//                                           color: Color(0xff0a4467),
//                                           fontSize: 10,
//                                           fontWeight: FontWeight.bold),),
//
//                                     ],)
//
//                                   ],
//
//                                 ),
//                               ),
//
//
//
//
//
//                             ],
//                           ),
//
//                         ),
                                      ])
                                ],
                              ),
                            ),
                            //for right text
                            Positioned(
                              top: 125,
                              left: 25,
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Color(0xff0a4467),
                                  fontFamily: 'Canterbury',
                                ),
                                child: AnimatedTextKit(
                                  repeatForever: true,
                                  animatedTexts: [
                                    ScaleAnimatedText(snapshot.data![index].from.toUpperCase()),
                                  ],
                                ),
                              ),
                            ),
                            //for left text
                            Positioned(
                              top: 125,
                              right: 25,
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Color(0xff0a4467),
                                  fontFamily: 'Canterbury',
                                ),
                                child: AnimatedTextKit(
                                  repeatForever: true,
                                  animatedTexts: [
                                    ScaleAnimatedText(snapshot.data![index].to.toUpperCase()),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 480,
                              right: 30,
                              left: 30,
                              child: Container(
                                height: 150,
                                width: 250,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                  color: Colors.white,

                                  //fit: BoxFit.fitWidth,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0, top: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 25,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: const Color(0xffffb541),

                                          //fit: BoxFit.fitWidth,
                                        ),
                                        child: Center(
                                            child: const Text(
                                              " Round Trip",
                                              style: TextStyle(color: Colors.white),
                                            )),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'Cost',
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                               Text(
                                                snapshot.data![index].cost.toString(),
                                                style: const TextStyle(
                                                    color: Color(0xff0a4467),
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 25,
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Passengers',
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                               Text(
                                                snapshot.data![index].numberOfPassengers.toString(),
                                                style:const TextStyle(
                                                    color: Color(0xff0a4467),
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 25,
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Capacity',
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                               Text(
                                                snapshot.data![index].passengersCapacity.toString(),
                                                style:const TextStyle(
                                                    color: Color(0xff0a4467),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 25,
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Relaxant',
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                               Text(
                                                '${snapshot.data![index].relax}%',
                                                style:const TextStyle(
                                                    color: Color(0xff0a4467),
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            ///divider
                            Positioned(
                              top: 640,
                              right: 40,
                              left: 40,
                              child: Container(
                                height: 30,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0),
                                  color: Colors.white,

                                  //fit: BoxFit.fitWidth,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.only(bottom: 1.9),
                                  child: Center(
                                      child: Text(
                                          '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -- - -')),
                                ),
                              ),
                            ),

                            ///nothing
                            Positioned(
                              top: 680,
                              right: 30,
                              left: 30,
                              child: Container(
                                height: 150,
                                width: 250,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10)),
                                  color: Colors.white,

                                  //fit: BoxFit.fitWidth,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),

                                    const Text(
                                      '    Bar Code',
                                      style: TextStyle(
                                          color: Color(0xff0a4467),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // SizedBox(height: 10,),

                                    booking == false
                                        ? Padding(
                                      padding: const EdgeInsets.only(left: 80.0),
                                      child: Container(
                                        height: 50,
                                        width: 400,
                                        decoration: BoxDecoration(
                                          // borderRadius: BorderRadius.zero,
                                          color: Colors.white,
                                        ),
                                        child: Text(
                                          '  you have a Bar Code here when you are Booking ',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 10),
                                        ),
                                      ),
                                    )
                                        : Padding(
                                      padding: const EdgeInsets.only(left: 70.0),
                                      child: QrImage(
                                        data: controller.text,
                                        backgroundColor: Colors.white,
                                        version: QrVersions.auto,
                                        size: 100,
                                        gapless: false,
                                        errorStateBuilder: (cxt, err) {
                                          return const Center(
                                            child: Text(
                                              "Uh oh! Something went wrong...",
                                              textAlign: TextAlign.center,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 1,
                                    ),
                                    booking == false
                                        ? MaterialButton(
                                      onPressed: () {
                                        setState(() {
                                          buildTextField(context);
                                          print(controller.text);
                                        });
                                      },
                                      child: Container(
                                        height: 45,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: const Color(0xffffdd9a),
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(top: 10.0),
                                          child: const Text('  Booking'),
                                        ),
                                      ),
                                    )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                );
              } else {
                return const Center(
                  child: Text(
                    "This flight company don't have any trips that match your choice",
                    style: TextStyle(fontSize: 25),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget diolong() {
    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Column(
                children: [
                  Container(
                    width: 256,
                    height: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 10.0, left: 10, top: 10),
                          child: Row(
//   mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: const [
                                  Text(
                                    "Depart",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "19:30",
                                    style: TextStyle(
                                        color: Color(0xff0a4467),
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.transparent,
                                  image: const DecorationImage(
                                    image: AssetImage("images/aircraft.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 40,
                              ),
                              Column(
                                children: const [
                                  Text(
                                    "Depart",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "19:30",
                                    style: TextStyle(
                                        color: Color(0xff0a4467),
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Container(
                            height: 20,
                            width: 95,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                border:
                                    Border.all(color: const Color(0xffffdd9a))),
                            child: const Text("  20h45m 1stop"),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 10.0, left: 10, bottom: 10),
                          child: Row(
//   mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: const [
                                  Text(
                                    "Monday",
                                    style: TextStyle(
                                        color: Color(0xff0a4467),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "January 28",
                                    style: TextStyle(
                                        color: Color(0xff0a4467),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 45,
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.transparent,
                                  image: new DecorationImage(
                                    image: AssetImage("images/aircraft.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 45,
                              ),
                              Column(
                                children: const [
                                  Text(
                                    "Tuesday",
                                    style: TextStyle(
                                        color: Color(0xff0a4467),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "January 29",
                                    style: TextStyle(
                                        color: Color(0xff0a4467),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        icon: const Icon(Icons.info_outline));
  }

  Widget Sttack() {
    return Stack(
      children: [
        Container(
          width: 256,
          height: 170,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 10, top: 10),
              child: Row(
//   mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: const [
                      Text(
                        "Depart",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "19:30",
                        style: TextStyle(
                            color: Color(0xff0a4467),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.transparent,
                      image: new DecorationImage(
                        image: AssetImage("images/aircraft.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Column(
                    children: [
                      Text(
                        "Depart",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "19:30",
                        style: TextStyle(
                            color: Color(0xff0a4467),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ]),
        )
      ],
    );
  }

  buildTextField(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                  //  var height = MediaQuery.of(context).size.height;
                  // var width = MediaQuery.of(context).size.width;

                  return SingleChildScrollView(
                    child: TextField(
                      controller: controller,
                      style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      decoration: InputDecoration(
                          hintText: 'enter the data',
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          suffixIcon: (IconButton(
                            color: Colors.indigo,
                            icon: const Icon(
                              Icons.arrow_forward_sharp,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                booking = true;
                              }
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(builder: (BuildContext context) =>description()));

                                  );
                              Navigator.pop(context);
                            },
                          ))),
                    ),
                  );
                },
              ),
            ));
  }
}

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:safari/animation/animateroute.dart';
import 'package:safari/cars/information.dart';
import 'package:safari/offers/offer.dart';


class ListCars extends StatefulWidget {
  const ListCars({Key? key}) : super(key: key);

  @override
  _ListCarsState createState() => _ListCarsState();
}

class _ListCarsState extends State<ListCars> {
  // final List<Map<String, dynamic>> _items = List.generate(
  //     4,
  //         (index) => {
  //       "id": index,
  //       "title": "Item $index",
  //       "height": Random().nextInt(150) + 50.5
  //     });
  List<Images> imageList = [
    Images( image:('images/malaysia1.jpg'),index: 0),
    Images( image:('images/malaysia2.jpg'),index: 1),
    Images( image:('images/malaysia6.jpg'),index: 2),
    Images( image:('images/malaysia7.jpg'),index: 3),
    // Images( image:( 'images/malaysia8.jpg'),),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 110,left: 7,right: 5,bottom: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Ink.image(
                    image: AssetImage(
                      'images/1652625125006-modified.png',
                    ),
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(Slide6(Page: InfoCars()));
                          },
                        ),],),
                    width: (MediaQuery.of(context).size.width)-240,
                    height:  (MediaQuery.of(context).size.height)-635,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 15,),
                  MaterialButton(
                    onPressed: (){
                      Navigator.of(context).push(Slide6(Page: InfoCars()));
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'UberX',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Text(
                              '4',
                              style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 5,),
                            Icon(Icons.people_sharp,color: Colors.indigo,size: 25,),
                            SizedBox(width: 20,),
                            Text(
                              '20D',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Container(
                          width: 160,
                          child: Text(
                            'every day',
                            style: Theme.of(context).textTheme.subtitle1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Ink.image(
                    image: AssetImage(
                      'images/bus101-modified.png',
                    ),
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(Slide6(Page: InfoCars()));
                          },
                        ),],),
                    width: (MediaQuery.of(context).size.width)-240,
                    height:  (MediaQuery.of(context).size.height)-635,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 15,),
                  MaterialButton(
                    onPressed: (){
                      Navigator.of(context).push(Slide6(Page: InfoCars()));
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'UberX',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Text(
                              '8',
                              style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 5,),
                            Icon(Icons.people_sharp,color: Colors.indigo,size: 25,),
                            SizedBox(width: 20,),
                            Text(
                              '200D',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Container(
                          width: 160,
                          child: Text(
                            'every day',
                            style: Theme.of(context).textTheme.subtitle1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Ink.image(
                    image: AssetImage(
                      'images/van101-modified.png',
                    ),
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(Slide6(Page: InfoCars()));
                          },
                        ),],),
                    width: (MediaQuery.of(context).size.width)-240,
                    height:  (MediaQuery.of(context).size.height)-635,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 15,),
                  MaterialButton(
                    onPressed: (){
                      Navigator.of(context).push(Slide6(Page: InfoCars()));
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'UberX',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Text(
                              '6',
                              style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 5,),
                            Icon(Icons.people_sharp,color: Colors.indigo,size: 25,),
                            SizedBox(width: 20,),
                            Text(
                              '75D',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Container(
                          width: 160,
                          child: Text(
                            'every day',
                            style: Theme.of(context).textTheme.subtitle1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Ink.image(
                    image: AssetImage(
                      'images/car101-modified.png',
                    ),
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(Slide6(Page: InfoCars()));
                          },
                        ),],),
                    width: (MediaQuery.of(context).size.width)-240,
                    height:  (MediaQuery.of(context).size.height)-635,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 15,),
                  MaterialButton(
                    onPressed: (){
                      Navigator.of(context).push(Slide6(Page: InfoCars()));
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'UberX',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Text(
                              '4',
                              style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 5,),
                            Icon(Icons.people_sharp,color: Colors.indigo,size: 25,),
                            SizedBox(width: 20,),
                            Text(
                              '50D',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Container(
                          width: 160,
                          child: Text(
                            'every day',
                            style: Theme.of(context).textTheme.subtitle1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              // Row(
              //   children: [
              //     Ink.image(
              //       image: AssetImage(
              //         'images/cart11.jpg',
              //       ),
              //       child: Stack(
              //         children: [
              //           InkWell(
              //             onTap: (){
              //               Navigator.of(context).push(Slide6(Page: InfoCars()));
              //             },
              //           ),],),
              //       width: (MediaQuery.of(context).size.width)-225,
              //                         height:  (MediaQuery.of(context).size.height)-620,
              //       fit: BoxFit.cover,
              //     ),
              //     SizedBox(width: 15,),
              //     Column(
              //       children: [
              //         Row(
              //           children: [
              //             Text(
              //               'UberX',
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontWeight: FontWeight.w700,
              //                 fontSize: 24,
              //               ),
              //             ),
              //             SizedBox(width: 10,),
              //             Text(
              //               '4',
              //               style: TextStyle(
              //                 color: Colors.indigo,
              //                 fontWeight: FontWeight.w500,
              //                 fontSize: 18,
              //               ),
              //             ),
              //             SizedBox(width: 5,),
              //             Icon(Icons.people_sharp,color: Colors.indigo,size: 25,),
              //             SizedBox(width: 40,),
              //             Text(
              //               '20D',
              //               style: Theme.of(context).textTheme.headline4,
              //             ),
              //           ],
              //         ),
              //         SizedBox(height: 20,),
              //         Container(
              //           width: 160,
              //           child: Text(
              //             'every day',
              //             style: Theme.of(context).textTheme.subtitle1,
              //             textAlign: TextAlign.left,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              // SizedBox(height: 20,),
              // Row(
              //   children: [
              //     Ink.image(
              //       image: AssetImage(
              //         'images/cart11.jpg',
              //       ),
              //       child: Stack(
              //         children: [
              //           InkWell(
              //             onTap: (){
              //               Navigator.of(context).push(Slide6(Page: InfoCars()));
              //             },
              //           ),],),
              //      width: (MediaQuery.of(context).size.width)-225,
              //                         height:  (MediaQuery.of(context).size.height)-620,
              //       fit: BoxFit.cover,
              //     ),
              //     SizedBox(width: 15,),
              //     Column(
              //       children: [
              //         Row(
              //           children: [
              //             Text(
              //               'UberX',
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontWeight: FontWeight.w700,
              //                 fontSize: 24,
              //               ),
              //             ),
              //             SizedBox(width: 10,),
              //             Text(
              //               '4',
              //               style: TextStyle(
              //                 color: Colors.indigo,
              //                 fontWeight: FontWeight.w500,
              //                 fontSize: 18,
              //               ),
              //             ),
              //             SizedBox(width: 5,),
              //             Icon(Icons.people_sharp,color: Colors.indigo,size: 25,),
              //             SizedBox(width: 40,),
              //             Text(
              //               '20D',
              //               style: Theme.of(context).textTheme.headline4,
              //             ),
              //           ],
              //         ),
              //         SizedBox(height: 20,),
              //         Container(
              //           width: 160,
              //           child: Text(
              //             'every day',
              //             style: Theme.of(context).textTheme.subtitle1,
              //             textAlign: TextAlign.left,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              // SizedBox(height: 20,),
            ],
          ),
          //     GridView.count(
          //         primary: false,
          //         padding: const EdgeInsets.all(20),
          //         crossAxisSpacing: 15,
          //         mainAxisSpacing: 10,
          //         crossAxisCount: 2,
          //         children: <Widget>[
          //         Ink.image(
          //                     image: AssetImage(
          //                         'images/cart11.jpg',
          //               ),
          //                 child: Stack(
          //                   children: [
          //                     InkWell(
          //                     onTap: (){
          //                       Navigator.of(context).push(Slide6(Page: InfoCars()));
          //                     },
          //                   ),
          //                     Positioned(
          //                       bottom: 0,
          //                       right: 0,
          //                       child: Container(
          //                         width: (MediaQuery.of(context).size.width)-220,
          //                         height: 40,
          //                         color: Colors.black54,
          //                         padding: EdgeInsets.all(10),
          //                         child: MaterialButton(
          //                           onPressed: (){},
          //                           child: Center(
          //                              child: Text(
          //                               'Taxi to 4 P',
          //                               style: TextStyle(
          //                                 color: Colors.yellowAccent,
          //                                 fontSize: 18,
          //                                 fontWeight: FontWeight.w800,
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                    ],
          //                 ),
          //           //width: (MediaQuery.of(context).size.width)-270,
          //           //height:  (MediaQuery.of(context).size.height)-640,
          //           //fit: BoxFit.cover,
          //         ),
          //         Ink.image(
          //             image: AssetImage(
          //               'images/car9.jpg',
          //             ),
          //             child: Stack(
          //               children: [
          //                 InkWell(
          //                   onTap: (){
          //                     Navigator.of(context).push(Slide6(Page: InfoCars()));
          //                   },
          //                 ),
          //                 Positioned(
          //                   bottom: 0,
          //                   right: 0,
          //                   child: Container(
          //                     width: (MediaQuery.of(context).size.width)-220,
          //                     height: 40,
          //                     color: Colors.black54,
          //                     padding: EdgeInsets.all(10),
          //                     child: MaterialButton(
          //                       onPressed: (){},
          //                       child: Center(
          //                         child: Text(
          //                           'Car to 4 P',
          //                           style: TextStyle(
          //                             color: Colors.yellowAccent,
          //                             fontSize: 18,
          //                             fontWeight: FontWeight.w800,
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             //width: (MediaQuery.of(context).size.width)-270,
          //             //height:  (MediaQuery.of(context).size.height)-640,
          //             //fit: BoxFit.cover,
          //           ),
          //         Ink.image(
          //             image: AssetImage(
          //               'images/cart11.jpg',
          //             ),
          //             child: Stack(
          //               children: [
          //                 InkWell(
          //                   onTap: (){
          //                     Navigator.of(context).push(Slide6(Page: InfoCars()));
          //                   },
          //                 ),
          //                 Positioned(
          //                   bottom: 0,
          //                   right: 0,
          //                   child: Container(
          //                     width: (MediaQuery.of(context).size.width)-220,
          //                     height: 40,
          //                     color: Colors.black54,
          //                     padding: EdgeInsets.all(10),
          //                     child: MaterialButton(
          //                       onPressed: (){},
          //                       child: Center(
          //                         child: Text(
          //                           'Bus to 25 P',
          //                           style: TextStyle(
          //                             color: Colors.yellowAccent,
          //                             fontSize: 18,
          //                             fontWeight: FontWeight.w800,
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             //width: (MediaQuery.of(context).size.width)-270,
          //             //height:  (MediaQuery.of(context).size.height)-640,
          //             //fit: BoxFit.cover,
          //           ),
          //         Ink.image(
          //             image: AssetImage(
          //               'images/cart11.jpg',
          //             ),
          //             child: Stack(
          //               children: [
          //                 InkWell(
          //                   onTap: (){
          //                     Navigator.of(context).push(Slide6(Page: InfoCars()));
          //                   },
          //                 ),
          //                 Positioned(
          //                   bottom: 0,
          //                   right: 0,
          //                   child: Container(
          //                     width: (MediaQuery.of(context).size.width)-220,
          //                     height: 40,
          //                     color: Colors.black54,
          //                     padding: EdgeInsets.all(10),
          //                     child: MaterialButton(
          //                       onPressed: (){},
          //                       child: Center(
          //                         child: Text(
          //                           'VIP to 8 P',
          //                           style: TextStyle(
          //                             color: Colors.yellowAccent,
          //                             fontSize: 18,
          //                             fontWeight: FontWeight.w800,
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             //width: (MediaQuery.of(context).size.width)-270,
          //             //height:  (MediaQuery.of(context).size.height)-640,
          //             //fit: BoxFit.cover,
          //           ),
          //         Ink.image(
          //             image: AssetImage(
          //               'images/carv22.jpg',
          //             ),
          //             child: Stack(
          //               children: [
          //                 InkWell(
          //                   onTap: (){
          //                     Navigator.of(context).push(Slide6(Page: InfoCars()));
          //                   },
          //                 ),
          //                 Positioned(
          //                   bottom: 0,
          //                   right: 0,
          //                   child: Container(
          //                     width: (MediaQuery.of(context).size.width)-220,
          //                     height: 40,
          //                     color: Colors.black54,
          //                     padding: EdgeInsets.all(10),
          //                     child: MaterialButton(
          //                       onPressed: (){},
          //                       child: Center(
          //                         child: Text(
          //                           'Van to 8 P',
          //                           style: TextStyle(
          //                             color: Colors.yellowAccent,
          //                             fontSize: 18,
          //                             fontWeight: FontWeight.w800,
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             //width: (MediaQuery.of(context).size.width)-270,
          //             //height:  (MediaQuery.of(context).size.height)-640,
          //             //fit: BoxFit.cover,
          //           ),
          //    ],
          // ),
          // GridView.custom(
          //   gridDelegate: SliverWovenGridDelegate.count(
          //     crossAxisCount: 2,
          //     mainAxisSpacing: 10,
          //     crossAxisSpacing: 6,
          //     pattern: [
          //       WovenGridTile(1),
          //       WovenGridTile(
          //         7 / 6 ,
          //         crossAxisRatio: 0.9,
          //         alignment: AlignmentDirectional.centerEnd,
          //       ),
          //     ],
          //   ),
          //   childrenDelegate: SliverChildBuilderDelegate(
          //         (context, index) => Ink.image(
          //               image: AssetImage(
          //                   imageList[index].image,
          //         ),//Image( imageList[index].image,),
          //           child: InkWell(
          //             onTap: (){
          //               Navigator.of(context).push(SlideRight(Page: Offers()));
          //               //context.read<MainScreenBloc>().add(OfferEvent());
          //             },
          //           ),
          //   ),
          // ),
          //     MasonryGridView.count(
          //     itemCount: 4,
          // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          // // the number of columns
          // crossAxisCount: 2,
          // // vertical gap between two items
          // mainAxisSpacing: 8,
          // // horizontal gap between two items
          // crossAxisSpacing: 8,
          // itemBuilder: (context, index) {
          // // display each item with a card
          // return  Container(
          //   width: 250,
          //   height: 100,
          //   child: Ink.image(
          //                   image: AssetImage(
          //                       imageList[index].image,
          //             ),//Image( imageList[index].image,),
          //                width: 250,
          //               height: 100,
          //               child: InkWell(
          //                 onTap: (){
          //                   Navigator.of(context).push(SlideRight(Page: Offers()));
          //                   //context.read<MainScreenBloc>().add(OfferEvent());
          //                 },
          //               ),
          //       ),
          // );
          //
          //
          //
          // },
          // ),),
        ),
      ),
    );
  }
}


class Images {
  String image;
  int index;
  Images({required this.image, required this.index,});
}
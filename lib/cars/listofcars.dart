import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:safari/animation/animateroute.dart';
import 'package:safari/cars/information.dart';
import 'package:safari/models/components/car.dart';
import 'package:safari/offers/offer.dart';
import 'package:safari/register/bloc/States_Register.dart';
import 'package:safari/server/database_client.dart';

// class ListCars extends StatefulWidget {
//   const ListCars({Key? key}) : super(key: key);

//   @override
//   _ListCarsState createState() => _ListCarsState();
// }

// class _ListCarsState extends State<ListCars> {

//   List<Images> imageList = [
//     Images( image:('images/1652625125006-modified.png'),index: 0,title: "UberX",price: "5"),
//     Images( image:('images/bus101-modified.png'),index: 1,title: "UberX",price: "4"),
//     Images( image:('images/van101-modified.png'),index: 2,title: "UberX",price: "3"),
//     Images( image:('images/car101-modified.png'),index: 3,title: "UberX",price: "55"),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: (){
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back,
//           ),
//         ),
//       ),
//       extendBodyBehindAppBar: true,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.only(top: 10,left: 0,right: 0,bottom: 0),
//           child: Column(
//             children: [
//               ListOFCars(),

//             ],
//           ),
//       ),
//       ),
//     );
//   }
//   Widget ListOFCars (){
//     return Center(
//       child: SingleChildScrollView(
//         child: SizedBox(
//           width: (MediaQuery.of(context).size.width)-50,
//           height: (MediaQuery.of(context).size.height),
//           child: ListView.builder(
//             itemCount: imageList.length,
//             scrollDirection: Axis.vertical,
//             itemBuilder: (context,index)=>Padding(
//               padding: const EdgeInsets.only(bottom: 20),
//               child: Stack(
//                clipBehavior: Clip.none,
//                 children: [

//                   Container(

//                     child: Card(

//                 color: Colors.white,
//                 clipBehavior: Clip.antiAlias,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 child: Container(
//                     width: (MediaQuery.of(context).size.width),
//                     height: (MediaQuery.of(context).size.height)-705,
//                     color: Color(0xffffbf00),
//                     ),
//                     ),
//                   ),
//                   Container(

//                      child: Stack(
//                       clipBehavior: Clip.none,
//                        children: [
//                         Card(
//                          elevation: 5,
//                          color: Colors.white,
//                          clipBehavior: Clip.antiAlias,
//                          shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(25),
//                          ),
//                          child: Container(
//                             width: (MediaQuery.of(context).size.width)-68,
//                              height: (MediaQuery.of(context).size.height)-705,
//                              color: Colors.white,
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.start,
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: [
//                        Column(
//                          children: [
//                            Expanded(
//                             flex: 3,
//                              child: Padding(
//                               padding: const EdgeInsets.only(right: 100,),
//                              child: MaterialButton(
//                                onPressed: () {
//                                   Navigator.of(context).push(Slide6(Page: InfoCars()));
//                                 },
//                                child: Text(
//                                  imageList[index].title,
//                                  style: TextStyle(
//                                    color: Colors.grey[500],
//                                    fontSize: 18,
//                                  ),
//                                ),
//                              ),
//                              ),
//                            ),

//                            Expanded(
//                              child: Padding(
//                                padding: const EdgeInsets.only(right: 131,),
//                                child: Container(

//                                 width: 70,
//                                 height: 25,

//                                 child: Center(
//                                 child: Text(
//                                   imageList[index].price,
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                                               ),
//                                decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.only(topRight: Radius.circular(25.0,),
//                                    bottomLeft: Radius.circular(25.0,),
//                                  ),
//                                  color: Color(0xffffbf00),
//                                                               ),
//                                                             ),
//                              ),
//                            ),

//                          ],
//                        ),

//                         SizedBox(width: 0,),

//                                          ],
//                                        ),
//                                      ),

//                                    ),
//                        ],
//                      ),

//                 ),
//                  Padding(
//                    padding: const EdgeInsets.only(right: 15),
//                    child: Align(
//                     alignment: Alignment.centerRight,
//                      child: Image(

//                               image: AssetImage(
//                                 imageList[index].image,

//                                 ),

//                               width: (MediaQuery.of(context).size.width)-270,
//                               height: (MediaQuery.of(context).size.height)-700,
//                               fit: BoxFit.cover,
//                               ),
//                    ),
//                  ),

//                 ],
//               ),

//             ),
//           ),
//         ),
//       ),
//     );

//   }
// }

// class Images {
//   String image;
//   int index;
//   String title;
//   String price;
//   Images({required this.image, required this.index, required this.title, required this.price});
// }

class ListCars extends StatefulWidget {
  final List<String> carsId;

  const ListCars({Key? key, this.carsId = const []}) : super(key: key);

  @override
  _ListCarsState createState() => _ListCarsState();
}

class _ListCarsState extends State<ListCars> {
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final ValueNotifier<List<Car>> _cars = ValueNotifier([]);

  Future<void> _fetchCars() async {
    try {
      debugPrint("Start fetching");
      debugPrint(widget.carsId.toString());
      _loading.value = true;
      for (String carId in widget.carsId) {
        debugPrint("Fetching ${carId}");
        Car? c = await DataBaseClintServer.getCar(carId);
        debugPrint('fetching completed');
        if (c != null) {
          _cars.value.add(c);
          List<Car> temp = List.from(_cars.value);
          _cars.value = List.from(temp);
          debugPrint("adding to list completed");
        }else{
          debugPrint("adding to list canceling the value is null");
        }
        if (_cars.value.isNotEmpty) {
          debugPrint("canceling loading indicator");
          _loading.value = false;
        }
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("error in fetching cars")));
    }
  }

 @override
  initState() {
    super.initState();
    _fetchCars();
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
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListOFCars(),
            ],
          ),
        ),
      ),
    );
  }

  Widget ListOFCars() {
    return SizedBox(
      width: (MediaQuery.of(context).size.width),
      height: (MediaQuery.of(context).size.height),
      child: ValueListenableBuilder<bool>(
        valueListenable: _loading,
        builder: (c,value,child)=>value?
        const  Center(child: CircularProgressIndicator(color: Colors.orange,)):
        child!,
        child: ValueListenableBuilder<List<Car>>(
          builder: (c,cars,child)=>Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: (MediaQuery.of(context).size.width) - 50,
                height: (MediaQuery.of(context).size.height),
                child: ListView.builder(
                  itemCount: cars.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              isDismissible: true,
                              backgroundColor: Colors.lightBlueAccent,
                              isScrollControlled: true,
                              enableDrag: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(35.0),
                                ),
                              ),
                              clipBehavior: Clip.none,
                              context: context,
                              builder: (BuildContext buildContext) =>
                                  CarInfo(cars[index]));
                        },

                        //Navigator.of(context).push(Slide6(Page: InfoCars()));},
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height *0.2,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Card(
                                color: Colors.white,
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Container(
                                  width: (MediaQuery.of(context).size.width),
                                  height: (MediaQuery.of(context).size.height) *0.2,
                                  color: index.isEven
                                      ? Colors.lightBlueAccent
                                      : const Color(0xffffbf00),
                                ),
                              ),
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Container(
                                      width: (MediaQuery.of(context).size.width) - 68,
                                      height:
                                      (MediaQuery.of(context).size.height) *0.2,
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                      left: 20,
                                                      top: 40,
                                                    ),
                                                    child: Text(
                                                      "Capacity ${cars[index].capacity.toString()}",
                                                      style: TextStyle(
                                                        color: Colors.grey[500],
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                      right: 131,
                                                    ),
                                                    child: Container(
                                                      width: 130,
                                                      height: 25,
                                                      decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.only(
                                                          topRight: Radius.circular(
                                                            25.0,
                                                          ),
                                                          bottomLeft: Radius.circular(
                                                            25.0,
                                                          ),
                                                        ),
                                                        color: Color(0xffffbf00),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                         'Cost Per hour: ${cars[index].costPerHour}',
                                                          style: const TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
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
                              Positioned(
                                right: 25,
                                top: 5,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *0.3,
                                    height:MediaQuery.of(context).size.height *0.18,
                                    child: Image(
                                      image: NetworkImage(
                                        cars[index].imagePath.first,

                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          valueListenable: _cars,
        ),
      ),
    );
  }

  Widget CarInfo(Car car) {
    return Container(
      clipBehavior: Clip.none,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height ,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width ,
            width: MediaQuery.of(context).size.width  ,
            child: Positioned(
              left:0,
              top: -90,
              width: 400,
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    offset: const Offset(0, 25),
                    spreadRadius: 0.5,
                    blurRadius: 160,
                  ),
                ]),
                child: Image(
                  image: NetworkImage(
                    car.imagePath.first,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 5,
            right: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    car.capacity.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white60),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 31,
                                width: 31,
                                child: FloatingActionButton(
                                  backgroundColor: Colors.white,
                                  onPressed: () {},
                                  child: Icon(
                                    Icons.local_gas_station_rounded,
                                    color: Colors.lightBlueAccent,
                                    size: 20,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                "${car.mpg} -MPG",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: FloatingActionButton.small(
                                  backgroundColor: Colors.white,
                                  onPressed: () {},
                                  child: Icon(
                                    Icons.people_rounded,
                                    color: Colors.lightBlueAccent,
                                    size: 20,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "${car.capacity} People",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: FloatingActionButton(
                                  backgroundColor: Colors.white,
                                  onPressed: () {},
                                  child: Icon(
                                    FontAwesomeIcons.calendarDay,
                                    color: Colors.lightBlueAccent,
                                    size: 16,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Daily",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    car.description,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.2),
                              spreadRadius: 0.1,
                              blurRadius: 160,
                            )
                          ],
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(25)),
                      child: Center(
                          child: Text(
                        "Book Now !",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 26),
                      )),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Images {
  String image;
  int index;
  String title;
  String price;

  Images(
      {required this.image,
      required this.index,
      required this.title,
      required this.price});
}

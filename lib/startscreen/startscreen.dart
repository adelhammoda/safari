import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:safari/airlines/airr.dart';
import 'package:safari/cars/listofcars.dart';
import 'package:safari/models/components/landmark.dart';
import 'package:safari/models/offices/airplanes.dart';
import 'package:safari/models/offices/office.dart';
import 'package:safari/models/offices/restaurant.dart';
import 'package:safari/models/offices/transportion_office.dart';
import 'package:safari/models/offices/hotel.dart' as h;
import 'package:safari/mytrip/MyTrip.dart';
import 'package:safari/places/bloc/places_cubit.dart';
import 'package:safari/places/bloc/places_states.dart';
import 'package:safari/places/datalayer/places_model.dart';
import 'package:safari/places/places_page.dart';

import 'package:safari/restaurant/restaurant-page.dart';
import 'package:safari/server/database_client.dart';
import 'package:safari/server/query.dart';
import 'package:safari/startscreen/business_logic/startscreen_bloc.dart';
import 'package:safari/startscreen/business_logic/startscreen_states.dart';
import 'package:safari/startscreen/data_layer/datamodel.dart';
import 'package:safari/startscreen/data_layer/startscreenapi.dart';
import 'package:safari/animation/animateroute.dart';
import 'package:safari/offers/offer.dart';

class StartScreen extends StatefulWidget {
  final DateTimeRange time;
  final Country? from;
  final Country? to;
  final double passengers;

  const StartScreen(
      {Key? key,
      required this.from,
      required this.to,
      required this.passengers,
      required this.time})
      : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  List<Office> data = [];
  List<Landmark> landmarks = [];
  bool isOffice = true;

  List<DataModel> imagelist = [
    // 'images/malaysia1.jpg',
    // 'images/malaysia2.jpg',
    // 'images/malaysia6.jpg',
    // 'images/malaysia7.jpg',
    // 'images/malaysia8.jpg',
    // 'images/malaysia9.jpg',
  ];

  List<AddPlacesModel> placesm = [];

  StartApi sss = StartApi();

  List<Option> buttons = [
    Option('Hotels', Icons.home),
    Option('Flight Companies', Icons.flight_rounded),
    Option('Restaurants', Icons.restaurant_menu_rounded),
    Option('Transportations', Icons.local_taxi),
    Option('Landmarks', Icons.landscape)
  ];

  // List<Option> buttons = [
  //   Option(LocalizationCubit.get(context).localization ? 'فنادق' : 'Hotels'/*,'Hotels'*/, Icons.home),
  //   Option(LocalizationCubit.get(context).localization ? 'طيران' : 'Flight Companies',/*'Flight Companies', */Icons.flight_rounded),
  //   Option(LocalizationCubit.get(context).localization ? 'مطاعم' : 'Restaurants',/*'Restaurants',*/ Icons.restaurant_menu_rounded),
  //   Option(LocalizationCubit.get(context).localization ? 'وسائل نقل' : 'Transportations',/*'Transportations', */Icons.local_taxi),
  //   Option(LocalizationCubit.get(context).localization ? 'الاماكن' : 'Landmarks',/*'Landmarks', */Icons.landscape)
  // ];

  @override
  void initState() {
    BlocProvider.of<TripCubit>(context).getImages("Hotels", 0);
    _loadHotels();
    super.initState();
  }

  Future<void> _loadHotels() async {
    List<Office> temp = await _fetchOffice(DataBaseClintServer.getAllHotels);
    _query<h.Hotel>(temp as List<h.Hotel>, "Hotels",
        passengersNumber: widget.passengers,
        citySource: widget.from?.Name ?? '',
        cityDestination: widget.to?.Name ?? '',
        from: widget.time.start,
        to: widget.time.end);
  }

  void _query<T extends Office>(
    List<T> source,
    String listType, {
    required String citySource,
    required String cityDestination,
    required DateTime from,
    required DateTime to,
    List<Landmark>? l,
    double? passengersNumber,
  }) {
    if(source.isEmpty && isOffice){
      _loading.value = false;
      data.clear();
      return;
    }else if(landmarks.isEmpty && !isOffice){
      _loading.value = false;
      landmarks.clear();
      return;
    }
    isOffice = true;
    landmarks.clear();
    switch (listType) {
      case "Hotels":
        {
          data = Query.queryOnHotels(
              source: source as List<h.Hotel>, city: cityDestination);
          break;
        }
      case "Flight Companies":
        {
          data = Query.queryOnAirPlanes(
              source: source as List<Airplanes>, city: citySource);
          break;
        }
      case "Restaurants":
        {
          data = Query.queryOnRestaurant(
              source: source as List<Restaurant>, city: cityDestination);
          break;
        }
      case "Transportations":
        {
          data = Query.queryOnTransportations(
              source: source as List<TransportationOffice>,
              city: cityDestination);
          break;
        }
      case "Landmarks":
        {
          if (l != null) {
            landmarks =
                Query.queryOnLandmark(source: l, country: cityDestination);
          } else {
            landmarks = [];
          }
          isOffice = false;
          data.clear();
          break;
        }
      default:
        {
          landmarks.clear();
          data.clear();
          _loading.value = false;
          break;
        }
    }
    _loading.value = false;
  }

  Future<List<T>> _fetchOffice<T extends Office>(
      Future<List<T>?> Function() f) async {
    try {
      debugPrint("Fetching office");
      _loading.value = true;
      isOffice = true;
      landmarks.clear();
      List<T> res = [];
      res = await f() ?? [];
      debugPrint("fetching completed ");
      return res;
    } catch (e) {
      _loading.value = false;
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<Landmark>> _fetchLandmarks(
      Future<List<Landmark>?> Function() f) async {
    try {
      if (_loading.value) {
        data.clear();
        landmarks.clear();
      }
      _loading.value = true;
      isOffice = false;
      data.clear();
      return await f.call() ?? [];
    } catch (e) {
      _loading.value = false;
      return [];
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child:
                  BlocBuilder<TripCubit, TripStates>(builder: (context, state) {
                return _CarouselSlider();
              }),
            ),
            SliverToBoxAdapter(
                child: SizedBox(
              height: 30,
            )),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 70,
                // height:  (MediaQuery.of(context).size.height)-800,
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: buttons.length,
                    itemBuilder: (context, index) {
                      return _buildlist(context, index);
                    }),
              ),
            ),
            SliverToBoxAdapter(
              child: ValueListenableBuilder<bool>(
                  valueListenable: _loading,
                  builder: (c, value, child) => value
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.orange,
                            ),
                          ),
                        )
                      : PlacesList()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _CarouselSlider() {
    return CarouselSlider(
      items: imagelist
          .map(
            (e) => ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(45),
                  bottomLeft: Radius.circular(45),
                ),
                child: InteractiveViewer(
                  maxScale: 4,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(e.image.toString()),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(22),
                            bottomRight: Radius.circular(22))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    const Color((0x00000000)),
                                    const Color((0xCC000000)).withOpacity(0.3),
                                    const Color((0xCC000000)).withOpacity(0.5),
                                    const Color((0xCC000000)).withOpacity(0.7),
                                    const Color((0xCC000000)).withOpacity(0.9),
                                    const Color((0xCC000000))
                                  ]),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(22),
                                  bottomRight: Radius.circular(22))),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0,
                                      left: 16,
                                      right: 16,
                                      bottom: 3),
                                  child: Text(e.name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 35,
                                          fontWeight: FontWeight.w800)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8, left: 16),
                                  child: Text("Subtitile Here",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          )
          .toList(),
      options: CarouselOptions(
        viewportFraction: 1,
        autoPlayInterval: Duration(seconds: 4),
        autoPlay: true,
        enableInfiniteScroll: true,
        height: (MediaQuery.of(context).size.height) - 500,
      ),
    );
  }

  Widget _buildlist(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<TripCubit, TripStates>(builder: (context, state) {
      return GestureDetector(
        onTap: () async {
          if (buttons[index].Name == "Landmarks") {
            // BlocProvider.of<TripCubit>(context).Choice2;
            BlocProvider.of<TripCubit>(context)
                .GetPlacesRequest('Cairo', index);
          } else {
            BlocProvider.of<TripCubit>(context)
                .getImages(buttons[index].Name, index);
          }
          print(buttons[index].Name);
          List<Office> temp = [];
          switch (buttons[index].Name) {
            case "Hotels":
              {
                _query<h.Hotel>(
                    await _fetchOffice<h.Hotel>(
                        DataBaseClintServer.getAllHotels),
                    "Hotels",
                    passengersNumber: widget.passengers,
                    citySource: widget.from?.Name ?? '',
                    cityDestination: widget.to?.Name ?? '',
                    from: widget.time.start,
                    to: widget.time.end);
                break;
              }

            case "Flight Companies":
              {
                _query<Airplanes>(
                    await _fetchOffice<Airplanes>(
                        DataBaseClintServer.getAllAirplanes),
                    "Flight Companies",
                    passengersNumber: widget.passengers,
                    citySource: widget.from?.Name ?? '',
                    cityDestination: widget.to?.Name ?? '',
                    from: widget.time.start,
                    to: widget.time.end);
                break;
              }
            case "Restaurants":
              {
                _query<Restaurant>(
                    await _fetchOffice<Restaurant>(
                        DataBaseClintServer.getAllRestaurant),
                    "Restaurants",
                    passengersNumber: widget.passengers,
                    citySource: widget.from?.Name ?? '',
                    cityDestination: widget.to?.Name ?? '',
                    from: widget.time.start,
                    to: widget.time.end);
                break;
              }
            case "Transportations":
              {
                _query<TransportationOffice>(
                    await _fetchOffice<TransportationOffice>(
                        DataBaseClintServer.getAllTransportations),
                    "Transportations",
                    passengersNumber: widget.passengers,
                    citySource: widget.from?.Name ?? '',
                    cityDestination: widget.to?.Name ?? '',
                    from: widget.time.start,
                    to: widget.time.end);
                break;
              }
            case "Landmarks":
              {
                List<Landmark> l =
                    await _fetchLandmarks(DataBaseClintServer.getAllLandMarks);
                _query(temp, "Landmarks",
                    l: l,
                    passengersNumber: widget.passengers,
                    citySource: widget.from?.Name ?? '',
                    cityDestination: widget.to?.Name ?? '',
                    from: widget.time.start,
                    to: widget.time.end);
                break;
              }
            default:
              debugPrint("There is no cases here");
              break;
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            decoration: BoxDecoration(
                color:
                    BlocProvider.of<TripCubit>(context).selectedindex == index
                        ? Colors.pink
                        : Colors.white70,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black12, width: 2)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Icon(buttons[index].icon,
                      color:
                          BlocProvider.of<TripCubit>(context).selectedindex ==
                                  index
                              ? Colors.white
                              : Colors.grey),
                  SizedBox(width: 5),
                  Text(
                    buttons[index].Name,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color:
                          BlocProvider.of<TripCubit>(context).selectedindex ==
                                  index
                              ? Colors.white
                              : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget PlacesList() {
    if (isOffice && data.isEmpty) {
      return const Center(child: const Text("No data"));
    } else if (!isOffice && landmarks.isEmpty) {
      return const Center(child: const Text("No data"));
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 25, left: 16, right: 16),
        child: StaggeredGridView.countBuilder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          crossAxisCount: 2,
          itemCount: isOffice ? data.length : landmarks.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              if (!isOffice) {
                Navigator.of(context).push(SlideRight(
                  Page:  PlacesScreen(
                    landmark: landmarks[index],
                  ),
                ));
                return;
              } else if (data.isEmpty) {
                return;
              } else {
                if (data[index] is h.Hotel) {
                  Navigator.of(context).push(SlideRight(
                      Page: Hotel(
                    isOffer: false,
                    hotel: data[index] as h.Hotel,
                  )));
                } else if (data[index] is Airplanes) {
                  Navigator.of(context).push(SlideRight(
                    Page: Flight(
                        airplanes: data[index] as Airplanes,
                        to: widget.to?.Name ?? '',
                        from: widget.from?.Name ?? ''),
                  ));
                } else if (data[index] is Restaurant) {
                  Navigator.of(context).push(SlideRight(
                    Page: RestaurantScreen(
                      restaurant: data[index] as Restaurant,
                    ),
                  ));
                } else if (data[index] is TransportationOffice) {
                  print('data is transportation ');
                  Navigator.of(context).push(SlideRight(
                    Page: ListCars(
                      carsId: (data[index] as TransportationOffice).carsId,
                    ),
                  ));
                } else {
                  //do nothing
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(isOffice
                          ? data[index].imagesPath.first
                          : landmarks[index].images.first),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.grey,
                  )),
              child: Stack(
                children: [
                  Positioned(
                      top: 20,
                      left: 16,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white70.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.black,
                              size: 22,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 3, top: 8, right: 8, bottom: 8),
                              child: Text(
                                (isOffice
                                        ? data[index].rateAverage()
                                        : landmarks[index].rateAavarage())
                                    .toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ]))),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color((0x00000000)),
                                  Color((0xCC000000)),
                                  Color((0xCC000000)),
                                  Color((0xCC000000)),
                                  Color((0xCC000000)),
                                  Color((0xCC000000))
                                ]),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(22),
                                bottomRight: Radius.circular(22))),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0,
                                      left: 16,
                                      right: 16,
                                      bottom: 3),
                                  child: SizedBox(
                                    width: 130,
                                    child: Text(
                                        isOffice
                                            ? data[index].name
                                            : landmarks[index].name,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8, left: 16),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    child: Text(
                                        isOffice
                                            ? data[index].description
                                            : landmarks[index].description,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          staggeredTileBuilder: (index) =>
              StaggeredTile.count(1, index.isEven ? 1.5 : 1.0),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
      );
    }
  }
}

class Option {
  final String Name;
  final IconData icon;

  Option(this.Name, this.icon);
}

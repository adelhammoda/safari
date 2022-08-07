import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safari/animation/animateroute.dart';
import 'package:safari/generated/l10n.dart';
import 'package:safari/localization/localization_bloc.dart';
import 'package:safari/models/components/tour.dart';
import 'package:safari/models/offices/office.dart';
import 'package:safari/offers/offer.dart';
import 'package:safari/register/bloc/States_Register.dart';
import 'package:safari/server/database_client.dart';
import 'package:safari/theme/colors/color.dart';
import 'package:safari/homelayout/bloc/home_bloc.dart';
import 'package:safari/homelayout/bloc/home_state.dart';
import 'package:safari/tours/tour.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/components/offers.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {

  //
  List<Office> favoriteOffices = [];
  List<Tour> favoriteTours = [];
  List<Offer> favoriteOffers = [];
  Map<String,List> favorite =   {};

  //




  Future<void> _loadFavoriteFromDB()async{
    try{
      debugPrint("start from storage");
      List<String> f = await _loadFavoriteFromDevice();
      debugPrint("loading favorite from DB ...");
     favorite = await DataBaseClintServer.getUserFavorite(f)??{};
     if(favorite.isNotEmpty){
       favoriteOffices = (favorite['offices']??[]) as List<Office>;
       favoriteTours = (favorite['tours']??[]) as List<Tour>;
       favoriteOffers = (favorite['offers']??[]) as List<Offer>;
     }
     setState((){});
      debugPrint("loading complete and the result is $favorite ");
    }catch(e){
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Some error happened")));
    }

  }

  Future<List<String>> _loadFavoriteFromDevice()async{
    debugPrint("getting storage ");
    SharedPreferences shared =await SharedPreferences.getInstance();
    debugPrint("loading string from storage...");
    String s =shared.getString('favorite')??'';
    debugPrint("loading successfully and the string is $s ");
    debugPrint("starting decoding ");
    var decodedList =jsonDecode(s==""?'{}':s);
    debugPrint("decoding completed and the result is $decodedList with type ${decodedList.runtimeType} ");
    List<String> ref = decodedList is List?Office.convertListOfString(decodedList):[];
    print(ref);
    return ref;
  }




  @override
  initState(){
    super.initState();
    _loadFavoriteFromDB();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: LocalizationCubit.get(context).localization ? Alignment.topRight : Alignment.topLeft,
          child: Text(
            LocalizationCubit.get(context).localization ? 'المفضلة' : 'Favorite',
            // S.of(context).pageFavorite,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(2),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:  SizedBox(
            height: (MediaQuery.of(context).size.height),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 110),
              child: ListView.builder(
                itemCount: favoriteOffices.length+favoriteTours.length+favoriteOffers.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context,index){
                  print(favoriteOffers.length);
                  print(index);
                  return Padding(
                    padding: const EdgeInsets.only(right: 4,left: 4,bottom: 10),
                    child:  Center(
                      child: Card(
                        elevation: 2,
                        shadowColor: Colors.white,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              child: Ink.image(
                                image: NetworkImage(
                                  favoriteOffices.length>=index+1?favoriteOffices[index].imagesPath.first:
                                  favoriteOffers.length>=index+1?favoriteOffers[index].images.first:
                                  favoriteTours.length>=index+1?favoriteTours[index].images.first:'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcST6KOSQzygEsYrzjJ6qXUmjOnO2XLQCRXrng&usqp=CAU',
                                ),
                                child: InkWell(
                                  onTap: (){
                                    // Navigator.push(
                                    //   context ,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => Hotel(),
                                    //   ),
                                    // );
                                    // Navigator.of(context).push(Slide3(Page: Hotel()));
                                    //context.read<MainScreenBloc>().add(OfferEvent());
                                  },
                                ),
                                width: (MediaQuery.of(context).size.width),
                                height:  (MediaQuery.of(context).size.height)-550,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              alignment: LocalizationCubit.get(context).localization ? Alignment.topRight : Alignment.topLeft,
                              child: IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: Theme.of(context).appBarTheme.iconTheme!.color,
                                ),
                                onPressed: (){
                                  // Navigator.of(context).push(SlideRight(Page: Tours()));
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                width: (MediaQuery.of(context).size.width),
                                height: (MediaQuery.of(context).size.height)-550,
                                color: Colors.black12,
                                padding: EdgeInsets.all(10),
                                child: MaterialButton(
                                  onPressed: (){
                                    // Navigator.of(context).push(SlideRight(Page: Tours()));
                                  },
                                  child: Align(
                                    alignment: LocalizationCubit.get(context).localization ? Alignment.bottomRight : Alignment.bottomLeft,
                                    child: Text(
                                      favoriteOffices.length>=index+1?favoriteOffices[index].name:
                                      favoriteOffers.length>=index+1?favoriteOffers[index].name:
                                      favoriteTours.length>=index+1?favoriteTours[index].name:'name',
                                      style:  Theme.of(context).textTheme.headline2,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // SizedBox(width: 5,),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

  }
}




//
// Card(
// elevation: 2,
// shadowColor: Colors.white,
// clipBehavior: Clip.antiAlias,
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(20),
// ),
// child: Stack(
// children: [
// Ink.image(
// image: AssetImage(
// favor[index].image,
// ),
// child: InkWell(
// onTap: (){
// Navigator.of(context).push(SlideRight(Page: Offers()));
// //context.read<MainScreenBloc>().add(OfferEvent());
// },
// ),
// width: (MediaQuery.of(context).size.width),
// height:  (MediaQuery.of(context).size.height)-600,
// fit: BoxFit.cover,
// ),
// Positioned(
// bottom: 10,
// right: 0,
// child: Container(
// width: (MediaQuery.of(context).size.width),
// height: 40,
// // color: Colors.black54,
// padding: EdgeInsets.all(10),
// child: MaterialButton(
// onPressed: (){},
// child: Row(
// children: [
// Text(
// favor[index].text,
// style: Theme.of(context).textTheme.headline2,
// ),
// Align(
// alignment: Alignment.topLeft,
// child: IconButton(
// onPressed: () {
// },
// icon: Icon(
// Icons.favorite,
// ),
// ),
// ),
// ],
// ),
// ),
// ),
// ),
// ],
// ),
// ),
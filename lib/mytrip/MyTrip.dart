
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safari/localization/localization_bloc.dart';
import 'package:safari/startscreen/business_logic/startscreen_bloc.dart';
import 'package:safari/startscreen/business_logic/startscreen_states.dart';
import 'package:safari/startscreen/startscreen.dart';
import 'package:safari/mytrip/mytripp/businesslogic/Cubit_MyTrip.dart';
import 'package:safari/mytrip/mytripp/businesslogic/States_MyTrip.dart';
import 'package:safari/theme/colors/color.dart';

import '../theme/colors/color_bloc.dart';



class MyTrip extends StatefulWidget {
  const MyTrip({Key? key}) : super(key: key);

  @override
  State<MyTrip> createState() => _MyTripState();
}

class _MyTripState extends State<MyTrip> {

  final items = [Country("Riyadh", "sa"),Country("Damascus", "sy"), Country("Cairo", "eg")]; //just add the name and code(in small letters) of the Country

  Country? Choice;     // to save the choice of the "From"  DropDownButton
  Country? Helper;     // to help swap the values of "From" and "To" DropDownButtons
  Country? Choice2;    // to save the choice of the "To"  DropDownButton
  bool Chosen= false;  // to Chnage the color of the date when the user chooses a new date
  int Adults=1;
  int Kids=0;
  int Infants=0;
  int X=0;


  var FormKey = GlobalKey<FormState>();



  DateTimeRange dateTimeRange= DateTimeRange(start: DateTime.now(),
      end: (DateTime.now()).add(new Duration(days: 7))); // the date that will be displayed before the user choose a new date range

  @override
  Widget build(BuildContext context) {
    //double Height= (MediaQuery.of(context).size.height)+MediaQuery.of(context).size.height *0.2;
    double Height = (MediaQuery.of(context).size.height) + X;
    return BlocProvider(
      create: (BuildContext context)=>TripCubit(initialTripState()),
      child: Scaffold(
          body: CustomScrollView(
            slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: Height,
                color:BlocProvider.of<ColorCubit>(context).isDark?
                Color.fromRGBO(104, 111, 129,1):Colors.lightBlueAccent,
                child: Stack(
                  children: [
                    Positioned(top:0,left: 0,right: 0,
                        child: BlocProvider.of<ColorCubit>(context).isDark?Image.asset("images/Trip Planning 2.gif"):Image.asset("images/Trip Planning 1.gif")),
                    Positioned(top:10,child:SizedBox(
                      width:MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            LocalizationCubit.get(context).localization ? '?????? ??????????' : 'Plan Your Journey',
                            // "Plan Your Journey",
                            style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                        ],
                      ),
                    )),
                    Positioned(top:250,left:0,right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: BlocProvider.of<ColorCubit>(context).isDark? Colors.blueGrey[300]:Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 50),
                            child: Form(
                              key: FormKey,
                              child: Column(mainAxisSize: MainAxisSize.min,children: [
                                Row(
                                  children:[
                                    Column(
                                      children: [
                                        Icon(Icons.flight_takeoff,color: BlocProvider.of<ColorCubit>(context).isDark?Colors.white:Colors.grey,),
                                        Padding(
                                          padding: const EdgeInsets.only(top:8.0),
                                          child: Text(
                                            // "From",
                                            LocalizationCubit.get(context).localization ? '????' : 'From',
                                            textAlign: TextAlign.center, style: TextStyle(fontSize: 12,color:  BlocProvider.of<ColorCubit>(context).isDark?Colors.white: Colors.grey),),
                                        )
                                      ],
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: DropdownButtonFormField2<Country>(
                                        isExpanded: true,
                                        isDense:false,
                                        decoration: InputDecoration.collapsed(
                                          hintText: LocalizationCubit.get(context).localization ? '???????? ??????????????' : 'Pick A City',//"Pick A City",
                                          hintStyle: TextStyle(fontWeight: FontWeight.w400)),
                                        iconSize: 0,
                                        dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: BlocProvider.of<ColorCubit>(context).isDark? Colors.blueGrey[300]:Colors.white),
                                        value: Choice,
                                        onChanged: (value){
                                          setState(() {
                                            Choice=value;
                                          });},
                                        items: items.map((item) => DropdownMenuItem<Country>(value:item,child: CountryWidget(item))).toList(),
                                        validator:(value) {
                                          if(value==null)
                                            return LocalizationCubit.get(context).localization ? ' ?????? ?????????? ????????????' : 'please select where your journey starts';//" please select where your journey starts";
                                          else
                                            return null;
                                        },
                                      ),
                                    ),],
                                ), //The "From" DropDownButton
                                Row(children: [
                                  Expanded(flex:10,child: Divider(color:BlocProvider.of<ColorCubit>(context).isDark?Colors.white:Colors.grey,height: 5)),
                                  Container(height: 45,width: 45,
                                      child: FloatingActionButton(onPressed: (){setState(() {
                                        Helper=Choice;
                                        Choice=Choice2;
                                        Choice2=Helper;
                                      });},
                                        backgroundColor: Colors.amber,
                                        child: Icon(Icons.swap_vert,color: Colors.white,),
                                        foregroundColor: Colors.black45,)),
                                  Expanded(child: Divider(color: Colors.grey,height: 5)),

                                ],), // divider with swap values
                                Row(
                                  children:[
                                    Column(
                                      children: [
                                        Icon(Icons.flight_land_outlined, color:BlocProvider.of<ColorCubit>(context).isDark?Colors.white:Colors.grey),
                                        Padding(
                                          padding: const EdgeInsets.only(top:8.0),
                                          child: Text(
                                            // "To",
                                             LocalizationCubit.get(context).localization ? '?????? ' : 'To',
                                            textAlign: TextAlign.center, style: TextStyle(fontSize: 12,color: BlocProvider.of<ColorCubit>(context).isDark?Colors.white:Colors.grey),),
                                        )
                                      ],
                                    ),
                                    SizedBox(width:20),
                                    Expanded(
                                      child: DropdownButtonFormField2<Country>(
                                        isExpanded: true,
                                        isDense: false,
                                        decoration: InputDecoration.collapsed(
                                          hintText: LocalizationCubit.get(context).localization ? '???????? ??????????????' : 'Pick A City',//"Pick A City",
                                          hintStyle: TextStyle(fontWeight: FontWeight.w400)),
                                        iconSize: 5,
                                        dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: BlocProvider.of<ColorCubit>(context).isDark? Colors.blueGrey[300]: Colors.white),
                                        value: Choice2,
                                        onChanged: (value){
                                          setState(() {
                                            Choice2=value;

                                          });},
                                        items: items.map((item) => DropdownMenuItem<Country>(value:item,child: CountryWidget(item))).toList(),
                                        validator:(value) {
                                          if(value==null)
                                            return LocalizationCubit.get(context).localization ? '?????? ???????????? ????????????' : 'please select the destination of your journey';//" please select the destination of your journey";
                                          else
                                            return null;
                                        },

                                      ),
                                    ),],
                                ),// The "To" DropDownButton
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: Divider(color: BlocProvider.of<ColorCubit>(context).isDark?Colors.white:Colors.grey,height: 5),
                                ), //simple divider
                                InkWell(
                                    child: Container(height: 60,
                                      child: Row(children: [
                                        Icon(Icons.date_range,color: BlocProvider.of<ColorCubit>(context).isDark?Colors.white:Colors.grey),
                                        SizedBox(width: 40),
                                        Column(children: [
                                          Text(
                                            LocalizationCubit.get(context).localization ? '?????? ????????????????' : 'Leaving Date',
                                            // "Leaving Date",
                                            style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black54),),
                                          Spacer(),
                                          Text(dateTimeRange.start.toString().split(' ')[0],style: TextStyle(fontWeight:FontWeight.w400,color: Chosen?BlocProvider.of<ColorCubit>(context).isDark?Colors.white:Colors.lightBlue:Colors.black45),)
                                        ],),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: VerticalDivider(width: 20,thickness: 2,),
                                        ),
                                        Column(children: [
                                          Text(
                                            // "Return Date",
                                            LocalizationCubit.get(context).localization ? '?????? ????????????' : 'Return Date',
                                            style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black54),),
                                          Spacer(),
                                          Text(dateTimeRange.end.toString().split(' ')[0],style: TextStyle(fontWeight: FontWeight.w400,color:Chosen? BlocProvider.of<ColorCubit>(context).isDark?Colors.white:Colors.lightBlue:Colors.black45))
                                        ]),

                                      ],),
                                    ),
                                    onTap: PickDateRange
                                ),
                                // the container is necessary for the vertical divider
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: Divider(color: BlocProvider.of<ColorCubit>(context).isDark?Colors.white:Colors.grey,height: 5),
                                ), //simple divider
                                Row(
                                  children: [
                                    Icon(Icons.people,color:BlocProvider.of<ColorCubit>(context).isDark?Colors.white:Colors.grey),
                                    Expanded(child: Theme( data: ThemeData(dividerColor: Colors.transparent),
                                      child: ExpansionTile(onExpansionChanged: (value){
                                        setState(() {
                                          if(value==true)
                                            X+=250;
                                          else
                                            X-=250;

                                        });
                                      },textColor: Colors.green,iconColor: Colors.green,title: Text(
                                       LocalizationCubit.get(context).localization ? ' ?????? ??????????????????' : 'Number Of Travellers',// "Number Of Travellers",
                                        style: TextStyle(color: Colors.black45,fontWeight: FontWeight.w400),),childrenPadding:EdgeInsets.all(8),children: [
                                        Row(
                                          children: [

                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.man),
                                                  Text(
                                                    LocalizationCubit.get(context).localization ? '????????????????' : 'Adults',
                                                    // "Adults"
                                                    ),
                                                  Text(
                                                    LocalizationCubit.get(context).localization ? '???????? ???? 12 ??????' : 'older than 12 Year old',
                                                    // "(older than 12 Year old)"
                                                     style: TextStyle(color:BlocProvider.of<ColorCubit>(context).isDark?Colors.white:Colors.lightBlue,fontSize: 10 ),)
                                                ],
                                              ),
                                            ),
                                            Spacer(),
                                            Row(mainAxisAlignment: MainAxisAlignment.end,children: [SizedBox(width: 30, height: 30,
                                              child: FloatingActionButton(heroTag: LocalizationCubit.get(context).localization ? '????????????????++' : 'Adults++',//"Adults++",
                                              backgroundColor: Colors.amber,child: Icon(Icons.add),onPressed: (){
                                                setState(() {
                                                  Adults++;
                                                });}),
                                            ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("$Adults"),
                                              ),
                                              SizedBox( width: 30,height: 30,
                                                child: FloatingActionButton(heroTag:  LocalizationCubit.get(context).localization ? '????????????????--' : 'Adults--',//"Adults--",
                                                backgroundColor: Colors.amber,child: Icon(Icons.remove),onPressed: (){setState(() {
                                                  if(Adults>1)
                                                    Adults--;
                                                });}),
                                              )])

                                          ],),
                                        Row(
                                          children: [

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8,bottom: 8),
                                              child: Column(
                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.boy),
                                                  Text(
                                                     LocalizationCubit.get(context).localization ? '??????????' : 'Kids',
                                                    // "Kids"
                                                    ),
                                                  Text(
                                                  //"(2 - 12 year old)",
                                                   LocalizationCubit.get(context).localization ? '2-12 ??????' : '2-12 year old',
                                                  style: TextStyle(color: BlocProvider.of<ColorCubit>(context).isDark?Colors.white:Colors.lightBlue,fontSize: 10 ),)
                                                ],
                                              ),
                                            ),
                                            Spacer(),
                                            Row(mainAxisAlignment: MainAxisAlignment.end,children: [SizedBox(width: 30, height: 30,
                                              child: FloatingActionButton(heroTag:  LocalizationCubit.get(context).localization ? '??????????++' : 'Kida++',//"Kids++",
                                              backgroundColor: Colors.amber,child: Icon(Icons.add),onPressed: (){
                                                setState(() {
                                                  Kids++;
                                                });}),
                                            ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("$Kids"),
                                              ),
                                              SizedBox( width: 30,height: 30,
                                                child: FloatingActionButton(heroTag:  LocalizationCubit.get(context).localization ? '??????????--' : 'Kids--',//"Kids--",
                                                backgroundColor: Colors.amber,child: Icon(Icons.remove),onPressed: (){setState(() {
                                                  if(Kids>0)
                                                    Kids--;
                                                });}),
                                              )])

                                          ],),
                                        Row(
                                          children: [

                                            Padding(
                                              padding: const EdgeInsets.only(top:8.0),
                                              child: Column(
                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.child_friendly),
                                                  Text(
                                                     LocalizationCubit.get(context).localization ? '?????????? ????????' : 'Infants',),//"Infants"),
                                                  Text(
                                                     LocalizationCubit.get(context).localization ? '???????? ???? ??????????' : 'younger than 2 year olda',
                                                    // "(younger than 2 Year olds)",
                                                   style: TextStyle(color: BlocProvider.of<ColorCubit>(context).isDark?Colors.white:Colors.lightBlue,fontSize: 10 ))
                                                ],
                                              ),
                                            ),

                                            Spacer(),
                                            Row(mainAxisAlignment: MainAxisAlignment.end,children: [SizedBox(width: 30, height: 30,
                                              child: FloatingActionButton(heroTag:  LocalizationCubit.get(context).localization ? '??????????++' : 'Infants++',//"Infants++"
                                              backgroundColor: Colors.amber,child: Icon(Icons.add),onPressed: (){
                                                setState(() {
                                                  Infants++;
                                                });}),
                                            ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("$Infants"),
                                              ),
                                              SizedBox( width: 30,height: 30,
                                                child: FloatingActionButton(heroTag:  LocalizationCubit.get(context).localization ? '??????????--' : 'Infants--',//"Infants--",
                                                backgroundColor: Colors.amber,child: Icon(Icons.remove),onPressed: (){setState(() {
                                                  if(Infants>0)
                                                    Infants--;
                                                });}),
                                              )])

                                          ],),

                                      ],),
                                    )),


                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 30),
                                  child: Divider(color: BlocProvider.of<ColorCubit>(context).isDark?Colors.white:Colors.grey,height: 5),
                                ),

                                BlocConsumer<TripCubit,TripStates>(
                                    listener:(context, state){
                                      if(state is FromMyTripToStart) {
                                        Navigator.push(context , MaterialPageRoute(builder: (newContext) => BlocProvider.value(value: BlocProvider.of<TripCubit>(context),child: StartScreen(
                                          to:Choice2 ,
                                          from: Choice,
                                          passengers: (Adults + Kids + Infants).toDouble(),
                                          time: dateTimeRange,
                                        ))));
                                      }
                                    },
                                    builder:(context , state) {
                                      return MaterialButton(
                                        onPressed: () {

                                        if (FormKey.currentState!.validate())
                                          BlocProvider.of<TripCubit>(context)
                                              .SavePreferences(
                                              Choice!,
                                              Choice2!,
                                              dateTimeRange,
                                              Adults,
                                              Kids,
                                              Infants);
                                      },
                                        child: Container(height: 60,
                                          decoration: BoxDecoration(
                                              color: Colors.amberAccent,
                                              borderRadius: BorderRadius.circular(25)),
                                          child: Center(child: Text(
                                             LocalizationCubit.get(context).localization ? '! ??????????' : 'Let\'s Go !',
                                            // "Let's Go !",
                                            style: TextStyle(color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 26),)),),);
                                    }
                                ),
                              ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            )],)
      ),
    );

  }

  Widget CountryWidget(Country country)
  {
    return Row(children: [
      CircleAvatar(backgroundImage: AssetImage("icons/flags/png/${country.Code}.png",package: 'country_icons')),
      SizedBox(width: 10,) ,
      Text(country.Name)],

    );
  }


  Future PickDateRange()async{
    DateTimeRange? newDateTimeRange= await showDateRangePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(2025),
        saveText: "Choose"
    );
    if(newDateTimeRange== null)
      return ;

    setState(() {
      dateTimeRange= newDateTimeRange;
      Chosen=true;

    });

  }

}





class Country{

  final String Name;
  final String Code;

  Country( this.Name,this.Code);

}


import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:safari/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class IntroScreen extends StatelessWidget {
  IntroScreen({Key? key}) : super(key: key);

  final List<PageViewModel> pages = [
    //hotel
    PageViewModel(
        useRowInLandscape:true,
        title: '\n \n Book cheap hotels online on Safrni',
        body:
        '   Real customer reviews & ratings',
        image: Center(
          child: Image.asset(
            'images/14521-hotel-booking.gif',
            fit: BoxFit.fill,
          ),
        ),
        decoration: PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(
              fontSize: 20.0,
            ))),
   // flight
    PageViewModel(
      // PageDecoration decoration = const PageDecoration(),
        title: ' \n \n  Flight Booking ',
        body:
        'Cheap Flights,& Airline Tickets Online\n Find the lowest price ✓ \n Fast & easy booking ✓\nFind out more now.',
        image: Center(
          child: Image.asset(
            'images/54972-world-map-tallinn.gif',
            fit: BoxFit.fitWidth,
          ),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 27.0,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(
              fontSize: 20.0,
            ))),
    //tours
    PageViewModel(
        title: ' \n \n Book your dream trip  \n',
        body:
        'Read the Latest Reviews, Search for the Lowest Prices & Save Money on Tripadvisor',
        image: Center(
          child: Image.asset('images/89588-tourists-by-car.gif', fit: BoxFit.fill),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 27.0,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(
              fontSize: 20.0,
            ))),
//oferrs
    PageViewModel(
        title: ' \n \n Offers & Discounts \n',
        body:
        ' Grab Offers & Discounts on Flight Booking & Hotel Booking & Tourist trips',
        image: Center(
          child: Image.asset('images/111537-offer-coupons.gif', fit: BoxFit.fill),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 27.0,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(
              fontSize: 20.0,
            ))),
    //landmarks
    PageViewModel(
        title: ' \n \nSafrni \nYour travel guide \nLandmarks',
        body:
        ' our Travel Guide wants to inspire you to slow down in life, to travel slower, to use a different way of traveling and to gain special experiences',
        image: Center(
          child: Image.asset('images/animation_500_l6o4uerv.gif', fit: BoxFit.fill),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 27.0,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(
              fontSize: 20.0,
            ))),

    //chatting
    PageViewModel(
        title: ' \n \nChat Posts are Becoming Available on Safrni ',
        body:
        'For the collective benefit\nAsk a question and answer',
        image: Center(
          child: Image.asset('images/91065-personal-use-only.gif', fit: BoxFit.fill),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 27.0,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(
              fontSize: 20.0,
            ))),
    //restuarant and transporation
    PageViewModel(
        title: ' \n \ntransportation & restaurant ',
        body:
        '',
        image: Center(
          child: Image.asset('images/93387-car-insurance-offers-loading-page.gif', fit: BoxFit.fill),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 27.0,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(
              fontSize: 20.0,
            ))),

 //welcome
    PageViewModel(
        title: ' \n \nYour right destination on the Safarni app ',
        body:
        'Welcome',
        image: Center(
          child: Image.asset('images/115467-man-standing-at-destination-point.gif', fit: BoxFit.fill),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 27.0,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(
              fontSize: 20.0,
            ))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 70, 0, 4),
            child: IntroductionScreen(
              pages: pages,
              dotsDecorator: DotsDecorator(
                size: const Size(2,5),
                color:Colors.orange,
                activeSize: const Size.square(5),
                activeColor: Colors.orange
              ),
              showDoneButton: true,
              done: Text(
                'Done',
                style: TextStyle(fontSize: 15, color: Colors.orange),
              ),
              showSkipButton: true,
              skip: Text(
                'Skip',
                style: TextStyle(fontSize: 15, color: Colors.orange),
              ),
              showNextButton: true,
              next: Text(
                'Next',
                style: TextStyle(fontSize: 15, color: Colors.orange),
              ),
              onDone: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (c)=>SplashScreen()
                )
              ),
              curve: Curves.bounceOut,
            ),
          ),
        ));
  }

  void onDone(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ON_BOARDING', false);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => Login()));
  }
}
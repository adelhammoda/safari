// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//  return Scaffold(
//       appBar: AppBar(
//        title: Text(widget.title),
//       ),
//       body: Center(
//        child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }


import 'dart:ui';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:safari/generated/l10n.dart';
import 'package:safari/localization/localization_bloc.dart';
import 'package:safari/localization/localization_state.dart';
import 'package:safari/localization/preferences_loc.dart';
import 'package:safari/models/components/car.dart';
import 'package:safari/models/components/comments.dart';

import 'package:safari/models/offices/restaurant.dart';
import 'package:safari/models/offices/transportion_office.dart';
import 'package:safari/onboarding.dart';

import 'package:safari/server/database_client.dart';
import 'package:safari/server/database_server.dart';
import 'package:safari/server/query.dart';
import 'package:safari/splashscreen.dart';
import 'package:safari/theme/colors/color_bloc.dart';
import 'package:safari/theme/preferences.dart';
import 'package:safari/theme/theme.dart';
import 'models/components/flight.dart';
import 'models/components/landmark.dart';
import 'models/offices/airplanes.dart';
import 'models/offices/hotel.dart';
import 'theme/colors/color_state.dart';
import 'models/components/comments.dart' as c;

// import 'package:flutter_gen/gen_l10n/app_localization.dart';
// import 'package:flutter_gen/gen_l10n/app_localization.dart';




void main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey ='pk_test_51KyxOBKdQHHlIDs4ETU4I8vOoP1j0pLE4maKl2IQoUbJDyW64kfcAyuV4tHJFVajel0KHhdewtynqTIINzUgm4kp00Df4cqho5';
  await CacheHelper.init();
  var isDark = CacheHelper.getBoolean(key: 'isDark');
  await Preferences.init();
  var localization = Preferences.getBooleanLan(key: 'localization');

  runApp(MyApp(isDark, localization));
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);

  final isDark;
  final localization;

  MyApp(this.isDark, this.localization);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
      ColorCubit()
        ..changeAppMode(fromShared: isDark),
      child: BlocConsumer<ColorCubit, ColorState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocProvider(
            create: (BuildContext context) =>
            LocalizationCubit()
              ..changeAppLan(fromSharedLan: localization),
            child: BlocConsumer<LocalizationCubit, LocalizationState>(
              listener: (context, state) {},
              builder: (context, state) {
                return MaterialApp(
                  title: 'Flutter Demo',
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: ColorCubit
                      .get(context)
                      .isDark
                      ? ThemeMode.dark
                      : ThemeMode.light,
                  // supportedLocales: l10n.all,
                  localizationsDelegates: [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  // supportedLocales: [
                  //   const Locale('en' , ''),
                  //   const Locale('ar' , ''),
                  // ],
                  supportedLocales: S.delegate.supportedLocales,
                  debugShowCheckedModeBanner: false,
                  home: IntroScreen(),
                   //const MyHomePage(title: 'Flutter Demo Home Page'),
                );
              },
            ),
          );
        },
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safari/forums/businesslogic/Forums_Cubit.dart';
import 'package:safari/forums/businesslogic/Forums_States.dart';
import 'package:safari/forums/datalayer/Comment_Repository.dart';
import 'package:safari/forums/datalayer/CommentsAPI.dart';
import 'package:safari/login/bloc/Cubit_Login.dart';
import 'package:safari/login/bloc/States_Login.dart';
import 'package:safari/login/datalayer/Login_Repository.dart';
import 'package:safari/register/bloc/Cubit_Register.dart';
import 'package:safari/register/bloc/States_Register.dart';
import 'package:safari/register/datalayer/Regitser_Repository.dart';
import 'package:safari/register/datalayer/WebServices(API).dart';
import 'package:safari/splashscreen.dart';
// import 'package:trip/MyTrip/Business%20Logic/Cubit_MyTrip.dart';
// import 'package:trip/MyTrip/Business%20Logic/States_MyTrip.dart';

class AppRouter{
  late LoginRepository loginRepository;
  late LoginCubit loginCubit;

  late RegisterRepository registerRepository;
  late RegisterCubit registerCubit;

  late ForumsCubit forumsCubit;
  late CommentsRepository commentsRepository;


  // late MyTripCubit myTripCubit;


  AppRouter(){
    loginRepository= LoginRepository(AuthAPI());
    loginCubit = LoginCubit(LoginInitState());

    registerRepository = RegisterRepository(AuthAPI());
    registerCubit = RegisterCubit(initialState());

    commentsRepository= CommentsRepository(CommentsAPI());
    forumsCubit= ForumsCubit(ForumsInitialState(), commentsRepository);

    // myTripCubit= MyTripCubit(MyTripInitialState());


  }

  Route? generateRoute(RouteSettings Settings){
    switch(Settings.name)
    {
      case '/':
        return MaterialPageRoute(builder: (_)=>MultiBlocProvider(providers: [BlocProvider(create:(BuildContext context)=>loginCubit),
          BlocProvider(create: (BuildContext context)=>registerCubit),
          // BlocProvider(create:(BuildContext context)=>myTripCubit),],
          BlocProvider(create: (BuildContext contex)=>forumsCubit),
        ],

            child: SplashScreen()
        )
        );

      case '/Existing_Cards':
        return MaterialPageRoute(builder: (_)=>MultiBlocProvider(providers: [BlocProvider(create:(BuildContext context)=>loginCubit),
          BlocProvider(create: (BuildContext context)=>registerCubit),
          // BlocProvider(create:(BuildContext context)=>myTripCubit),],
          BlocProvider(create: (BuildContext contex)=>forumsCubit),
        ],

            child: SplashScreen()
        )
        );




    }
  }
}
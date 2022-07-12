import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safari/register/bloc/Cubit_Register.dart';
import 'package:safari/register/bloc/States_Register.dart';
import 'package:safari/register/datalayer/Regitser_Repository.dart';
import 'package:safari/register/datalayer/WebServices(API).dart';
import 'Register_Screen.dart';

class AppRouter{
  late RegisterRepository registerRepository;
  late RegisterCubit registerCubit;

  AppRouter(){
    registerRepository= RegisterRepository(AuthAPI());
    registerCubit= RegisterCubit(initialState());
  }

  Route? generateRoute(RouteSettings Settings){
    switch(Settings.name)
    {
      case "/":
        return MaterialPageRoute(builder: (_)=>BlocProvider(
            create:(BuildContext context)=>registerCubit ,
            child:Register()
        )
        );

    }
  }
}
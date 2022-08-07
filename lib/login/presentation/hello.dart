import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safari/animation/animateroute.dart';
import 'package:safari/drawer/drawer.dart';
import 'package:safari/generated/l10n.dart';
import 'package:safari/login/bloc/Cubit_Login.dart';
import 'package:safari/login/bloc/States_Login.dart';
import 'package:safari/login/datalayer/Login_Model.dart';
import 'package:safari/login/datalayer/Login_Repository.dart';
import 'package:safari/register/presentation/Register_Screen.dart';
import 'package:safari/register/presentation/widget/Loading_State.dart';
import 'package:safari/server/authintacation.dart' as database;

import '../../homelayout/homelayout.dart';

class myLogin extends StatefulWidget {
  @override
  State<myLogin> createState() => _myLoginState();
}

class _myLoginState extends State<myLogin> {
  final formKey = GlobalKey<FormState>();

  var passoredcontroller = TextEditingController();

  var emailcontroller = TextEditingController();

  bool obscureText = true;

  LoginModel loginModel = LoginModel();

  late final LoginRepository loginRepository;
  //
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(LoginInitState()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: DrawerWidget(),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(90),
                        ),
                        color: Color(0xffef5422),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('images/airplane - Copy.gif'))),
                  ),
                  Container(
                    child: BlocConsumer<LoginCubit, LoginState>(
                        listener: (context, state) {
                          if (state is AdminLoadingSucceccState)
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeLayout()));

                          if (state is LoadingErrorState)
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)));
                        }, builder: (context, state) {
                      if (state is LoginLoading)
                        return LoadingWidget();

                      // if (state is LoadingErrorState)

                      //    return Center(child: Text(state.message));

                      else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              S.of(context).pageLogin,
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Email(),
                            SizedBox(
                              height: 10,
                            ),
                            password(),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              margin:
                              EdgeInsets.only(left: 20, right: 20, top: 10),

                              padding: EdgeInsets.only(left: 20, right: 20),

                              alignment: Alignment.center,

                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      (new Color(0xffF5591F)),
                                      new Color(0xffF2861E)
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight),
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 10),
                                      blurRadius: 50,
                                      color: Color(0xffEEEEEE)),
                                ],
                              ),

                              //width: double.infinity,

                              child: ValueListenableBuilder<bool>(
                                valueListenable: _loading,
                                builder: (c, value, widget) => value
                                    ? const CircularProgressIndicator(
                                  color: Colors.orange,
                                )
                                    : widget!,
                                child: MaterialButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      debugPrint(
                                          "Button Clicked.login started");
                                      try {
                                        _loading.value = true;
                                        await database.Login.login(
                                            emailcontroller.text,
                                            passoredcontroller.text)
                                            .then((value) {
                                          _loading.value = false;
                                          debugPrint("logged in successfully");
                                          if (Navigator.canPop(context)) {
                                            Navigator.of(context).pop();
                                          } else {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (c) =>
                                                    const Home()));
                                          }
                                        });
                                      } on FirebaseException catch (e) {
                                        _loading.value = false;
                                        ScaffoldMessenger.of(context).clearSnackBars();
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text(e.message ??
                                                "some Error happened")));
                                      } on Exception catch (e) {
                                        _loading.value = false;
                                        debugPrint(e.toString());
                                        ScaffoldMessenger.of(context).clearSnackBars();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                            content:
                                            Text("Error happened")));
                                      }
                                    }
                                  },
                                  child: Text(
                                    S.of(context).pageLogin,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin:
                              EdgeInsets.only(left: 20, right: 20, top: 10),

                              padding: EdgeInsets.only(left: 20, right: 20),

                              alignment: Alignment.center,

                              //width: double.infinity,

                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(SlideRight(Page: Register()));
                                },
                                child: Text(
                                  S.of(context).pageRegister,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _outlineBorder({Color? borderColor}) {
    if (borderColor == null)
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
      );
    else
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: borderColor),
      );
  }

  Widget Email() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      padding: EdgeInsets.only(left: 20, right: 20),
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 10), blurRadius: 50, color: Color(0xffEEEEEE)),
        ],
      ),
      child: TextFormField(
        controller: emailcontroller,
        keyboardType: TextInputType.emailAddress,
        cursorColor: Color(0xffF5591F),
        onFieldSubmitted: (value) {
          print(value);
        },
        validator: (value) {
          if (value!.isEmpty ||
              !value.contains('@') ||
              !value.contains('.com')) {
            return S.of(context).pageEmailAddress;
          }
          return null;
        },
        decoration: InputDecoration(
          icon: Icon(
            Icons.email,
            color: Color(0xffF5591F),
          ),
          hintText: S.of(context).pageEnterEmail,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget password() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      padding: EdgeInsets.only(left: 20, right: 20),
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Color(0xffEEEEEE),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 20), blurRadius: 100, color: Color(0xffEEEEEE)),
        ],
      ),
      child: TextFormField(
        controller: passoredcontroller,
        obscureText: obscureText,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: Color(0xffF5591F),
        decoration: InputDecoration(
          focusColor: Color(0xffF5591F),
          icon: Icon(
            Icons.vpn_key,
            color: Color(0xffF5591F),
          ),
          hintText: S.of(context).pageEnterPassword,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Color(0xffF5591F),
            ),
          ),
        ),
        onFieldSubmitted: (value) {
          print(value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            return S.of(context).pagePasswordAddress;
          }
          return null;
        },
      ),
      // enabledBorder: InputBorder.none,
      //   focusedBorder: InputBorder.none,
    );
  }
}

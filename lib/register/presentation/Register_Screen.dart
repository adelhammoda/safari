import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safari/drawer/drawer.dart';
import 'package:safari/generated/l10n.dart';
import 'package:safari/register/bloc/Cubit_Register.dart';
import 'package:safari/register/bloc/States_Register.dart';
import 'package:safari/register/datalayer/Register_Model.dart';
import 'package:safari/register/datalayer/Regitser_Repository.dart';
import 'package:safari/register/presentation/widget/DisplayPicture.dart';
import 'package:safari/register/presentation/widget/Loading_State.dart';
import 'package:safari/server/authintacation.dart' as auth;
import 'package:safari/models/components/user.dart' as u;
import 'package:safari/tours/tour.dart';

/////
class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();

  var passoredcontroler = TextEditingController();

  var emailcontroler = TextEditingController();

  var ImageControler = TextEditingController();

  var namecontroler = TextEditingController();

  var phonecontroler = TextEditingController();

  bool obscureText = true;
  bool isPassword = true;
  bool isPassword2 = true;

  late RegisterRepository registerRepository;

  File? UserImage;

  final Picker = ImagePicker();

  RegisterModel registerModel = RegisterModel();
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  Future getImage(ImageSource src) async {
    final PickedFile = await Picker.pickImage(source: src);
    setState(() {
      if (PickedFile != null) {
        UserImage = File(PickedFile.path);
        BlocProvider.of<RegisterCubit>(context).UpdateImage(UserImage!);
        this.registerModel.Image = UserImage!;
        print("image loaded");
      }
      else
        print("Could not get photo");
    });
  }

  @override
  void initState() {
    //BlocProvider.of<RegisterCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(initialState()),
      child: Scaffold(
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
        body: SafeArea(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(

                        /// اللون للخلفية الببضاء مع شفافية 10%
                        color: Colors.white.withOpacity(0.10),

                        /// تدوير الحواف
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),

                      child: BlocBuilder<RegisterCubit, RegisterState>(
                          builder: (context, state) {
                            if (state is LoadingState)
                              return LoadingWidget();

                            if (state is SuccessState)
                              return DisplayPicture(
                                  DisplayPhoto: state.profileImage);

                            else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    S
                                        .of(context)
                                        .pageRegister,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .headline1,
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  InkWell(child: ClipOval(
                                      child: Container(width: 100, height: 100,
                                        child: BlocBuilder<
                                            RegisterCubit,
                                            RegisterState>(
                                            builder: (context, state) {
                                              if (state is ImageLoaded)
                                                return Image.file(
                                                  state.ProfileImage,
                                                  fit: BoxFit.fill,);

                                              return Image.asset(
                                                  "images/plane.jpg",
                                                  fit: BoxFit.fill);
                                            }),
                                      )), onTap: () {
                                    showDialog(context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Choose Picture From"),
                                            content: Container(height: 150,
                                                color: Colors.white,
                                                child:
                                                Column(children: [
                                                  Container(
                                                    color: Colors.orange,
                                                    child: ListTile(
                                                      leading: Icon(
                                                          Icons.image),
                                                      title: Text('Gallery'),
                                                      onTap: () {
                                                        getImage(ImageSource
                                                            .gallery);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },),),
                                                  const SizedBox(height: 30,),
                                                  Container(
                                                    color: Colors.orange,
                                                    child: ListTile(
                                                      leading: Icon(
                                                          Icons.add_a_photo),
                                                      title: Text('Camera'),
                                                      onTap: () {
                                                        getImage(
                                                            ImageSource.camera);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },),),
                                                ],)),);
                                        });
                                  },),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  TextFormField(
                                    controller: namecontroler,
                                    keyboardType: TextInputType.name,
                                    onFieldSubmitted: (String value) {
                                      print(value);
                                    },
                                    onChanged: (String value) {
                                      print(value);
                                    },
                                    decoration: InputDecoration(
                                      focusColor: Colors.purple,
                                      labelText: S
                                          .of(context)
                                          .pageName,
                                      prefixIcon:
                                      Icon(Icons
                                          .drive_file_rename_outline_rounded),
                                      border: _outlineBorder(),

                                      /// دالة الborder يلي بتخلي مدور بس استدعيا
                                      /// في حال بدي الborder بغير لون بس  جواتا borderColor
                                      /// الError لونو أحمر مثلا
                                      enabledBorder: _outlineBorder(),
                                      focusedBorder: _outlineBorder(
                                        // borderColor: AppColors.darkBlue,
                                      ),
                                      disabledBorder: _outlineBorder(),
                                    ),

                                    /// تحت مشان ايمت نطلع الرسالة الحمرا
                                    /// وشو الرسالة لبدنا نطلعا
                                    validator: (value) {
                                      /// اذا فاضية بترجع رسالة عبي الداتا
                                      if ((value ?? '').isEmpty) return S
                                          .of(context)
                                          .pageFillValue;
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.phone,
                                    controller: phonecontroler,
                                    decoration: InputDecoration(
                                      labelText: S
                                          .of(context)
                                          .pageYourPhone,
                                      prefixIcon: Icon(Icons.phone),
                                      border: _outlineBorder(),
                                      enabledBorder: _outlineBorder(),
                                      focusedBorder: _outlineBorder(
                                        // borderColor: AppColors.darkBlue,
                                      ),
                                      disabledBorder: _outlineBorder(),
                                    ),
                                    validator: (value) {
                                      /// اذا فاضية بترجع رسالة عبي الداتا
                                      if ((value ?? '').isEmpty) return S
                                          .of(context)
                                          .pageFillValue;
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: emailcontroler,
                                    decoration: InputDecoration(
                                      labelText: S
                                          .of(context)
                                          .pageEnterEmail,
                                      prefixIcon: Icon(Icons.email),
                                      border: _outlineBorder(),
                                      enabledBorder: _outlineBorder(),
                                      focusedBorder: _outlineBorder(
                                        // borderColor: AppColors.darkBlue,
                                      ),
                                      disabledBorder: _outlineBorder(),
                                    ),
                                    validator: (value) {
                                      /// اذا فاضية بترجع رسالة عبي الداتا
                                      if ((value ?? '').isEmpty) return S
                                          .of(context)
                                          .pageFillValue;
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: passoredcontroler,
                                    obscureText: isPassword,
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                      labelText: S
                                          .of(context)
                                          .pageEnterPassword,
                                      prefixIcon: Icon(Icons.lock),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isPassword = !isPassword;
                                            });
                                          },
                                          icon: Icon(isPassword
                                              ? Icons.visibility_off
                                              : Icons.visibility)),
                                      border: _outlineBorder(),

                                      /// دالة الborder يلي بتخلي مدور بس استدعيا
                                      /// في حال بدك الborder بغير لون بس  جواتا borderColor
                                      /// الError لونو أحمر مثلا
                                      enabledBorder: _outlineBorder(),
                                      focusedBorder: _outlineBorder(
                                        // borderColor: AppColors.darkBlue,
                                      ),
                                      disabledBorder: _outlineBorder(),
                                    ),
                                    validator: (value) {
                                      /// اذا فاضية بترجع رسالة عبي الداتا
                                      if ((value ?? '').isEmpty) return S
                                          .of(context)
                                          .pageFillValue;
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    obscureText: isPassword2,
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                      labelText: S
                                          .of(context)
                                          .pageConfirmpass,
                                      prefixIcon: Icon(Icons.lock),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isPassword2 = !isPassword2;
                                            });
                                          },
                                          icon: Icon(isPassword2
                                              ? Icons.visibility_off
                                              : Icons.visibility)),
                                      border: _outlineBorder(),

                                      /// دالة الborder يلي بتخلي مدور بس استدعيا
                                      /// في حال بدك الborder بغير لون بس  جواتا borderColor
                                      /// الError لونو أحمر مثلا
                                      enabledBorder: _outlineBorder(),
                                      focusedBorder: _outlineBorder(
                                        // borderColor: AppColors.darkBlue,
                                      ),
                                      disabledBorder: _outlineBorder(),
                                    ),
                                    validator: (value) {
                                      /// اذا فاضية بترجع رسالة عبي الداتا
                                      if ((value ?? '').isEmpty) return S
                                          .of(context)
                                          .pageFillValue;

                                      if (value == passoredcontroler.text)
                                        return null;
                                      return "Password and confirm password do not match";
                                    },
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 20, right: 20, top: 10),

                                    padding: EdgeInsets.only(
                                        left: 20, right: 20),

                                    alignment: Alignment.center,

                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        (new Color(0xffF5591F)),
                                        new Color(0xffF2861E)
                                      ],

                                          begin: Alignment.centerLeft,

                                          end: Alignment.centerRight

                                      ),
                                      borderRadius: BorderRadius.circular(50),

                                      boxShadow: const [

                                        BoxShadow(

                                            offset: Offset(0, 10),

                                            blurRadius: 50,

                                            color: Color(0xffEEEEEE)

                                        ),

                                      ],

                                    ),

                                    child: ValueListenableBuilder<bool>(
                                      valueListenable: _loading,
                                      builder: (c, value, widget) =>
                                      value ?
                                      const CircularProgressIndicator(
                                        color: Colors.orange,)
                                          : widget!,
                                      child: MaterialButton(
                                        onPressed: () async {
                                          if (UserImage == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'You must upload photo')));
                                            return ;
                                          }
                                          if (formKey.currentState!
                                              .validate() ) {
                                            try {
                                              _loading.value = true;
                                              await auth.Register.createAccount(
                                                user:  u.User(
                                                  isVerification: false,
                                                  isOwner:false,
                                                    photoUrl: '',
                                                    phoneNumber: phonecontroler.text,
                                                    email:emailcontroler.text,
                                                    name: namecontroler.text
                                                ),
                                                image: UserImage!, password: passoredcontroler.text, ).then((
                                                  value) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            "Your account is created successfully"))
                                                );
                                                if(Navigator.of(context).canPop()){
                                                  Navigator.of(context).pop();
                                                }else{
                                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (c)=>HomeScreen()));
                                                }
                                              });

                                              _loading.value = false;
                                            } on Exception catch (e) {
                                              _loading.value = false;
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                  const SnackBar(content: Text(
                                                      "Some error happened"))
                                              );
                                              print(e.toString());
                                            }
                                          }
                                        },
                                        child: Text(
                                          S
                                              .of(context)
                                              .pageRegister,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

    );
  }

  /// هاد التابع يلي بخلي الحواف مدورة
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
}
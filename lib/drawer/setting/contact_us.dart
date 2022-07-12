import 'package:flutter/material.dart';
import 'package:safari/drawer/drawer.dart';
import 'package:safari/drawer/setting/callus.dart';
import 'package:safari/generated/l10n.dart';
import 'package:safari/localization/localization_bloc.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: LocalizationCubit.get(context).localization ? Alignment.topRight : Alignment.topLeft,
          child: Text(
            S.of(context).pageContactus,
          ),
        ),
        leading: DrawerWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20,right: 10,left: 15,bottom: 20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.call,
                  size: 25,
                  color: Theme.of(context).bottomAppBarColor,
                ),
                SizedBox(width: 10,),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20,),
                      child: Text(
                        S.of(context).pageCallus,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.only(left: 20,),
                      child: Text(
                        S.of(context).pageWeAre,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 150,),
                  child: IconButton(
                    onPressed: (){
                      Navigator.push(
                        context ,
                        MaterialPageRoute(
                          builder: (context) => Numbers(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: Theme.of(context).bottomAppBarColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



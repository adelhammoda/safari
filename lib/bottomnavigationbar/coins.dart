import 'package:flutter/material.dart';
import 'package:safari/generated/l10n.dart';
import 'package:safari/localization/localization_bloc.dart';
class Coins extends StatelessWidget {
  const Coins({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Align(
            alignment: LocalizationCubit.get(context).localization ? Alignment.topRight : Alignment.topLeft,
            child: Text(
              S.of(context).pageCoin,
            ),
          ),
        ),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(
        //         Icons.favorite,
        //
        //     ),
        //     onPressed: (){
        //     },
        //   ),
        // ],
      ),
      body: Center(
        child: Text(
          'coins',
        ),
      ),
    );
  }
}

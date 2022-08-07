import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:safari/Payment/Services/Payment-Services.dart';
import 'package:safari/models/components/booking.dart';
import 'package:safari/register/presentation/widget/Loading_State.dart';
import 'package:safari/server/database_client.dart';
import 'package:safari/server/database_server.dart';

import '../models/components/user.dart';

class PaymentHome extends StatefulWidget {
  final double cost;
  final String uid;
  final String name;
  final String reservedId, reservedPath;
  final DateTime? reservedFrom, reservedTo;
  final String imageUrl;

  const PaymentHome({Key? key,
    required this.cost,
    required this.imageUrl,
    required this.name,
    required this.reservedId,
    required this.reservedPath,
    required this.uid,
    this.reservedFrom,
    this.reservedTo})
      : super(key: key);

  @override
  State<PaymentHome> createState() => _PaymentHomeState();
}

class _PaymentHomeState extends State<PaymentHome> {
  static String ApiBase = 'https://api.stripe.com//v1';

  //static String secret= '';
  Dio dio = Dio(BaseOptions(baseUrl: ApiBase));

  static Map<String, dynamic>? paymentIntentData;

  onItemPress(BuildContext context, int index) async {
    switch (index) {
      case 0:
        await makePayment();
        break;
      case 1:
        print("case 1 ");
    }
  }



  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
            itemBuilder: (context, index) {
              Icon icon = const Icon(Icons.add_circle);
              Text text = const Text("Pay via new Card");
              icon = Icon(
                Icons.add_circle,
                color: theme.primaryColor,
              );
              text = const Text("Pay Via New Card");
              return InkWell(
                child: ListTile(
                  title: text,
                  leading: icon,
                ),
                onTap: () {
                  onItemPress(context, index);
                },
              );
            },
            separatorBuilder: (context, index) =>
                Divider(
                  color: theme.primaryColor,
                ),
            itemCount: 1),
      ),
    );
  }

  makePayment() async {
    try {
      paymentIntentData = await createPaymentIntent(widget.cost.toInt(), 'USD');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData!['client_secret'],
            googlePay: true,
            style: ThemeMode.dark,
            merchantCountryCode: 'US',
            merchantDisplayName: "Hotel"),
      );

      displayPaymentSheet();
    } catch (e) {
      print(e.toString());
    }
  }


  showIndicator() {
    showDialog(context: context,
        builder: (c) =>
            Dialog(
              backgroundColor: Colors.black26.withOpacity(0),
              elevation: 0,
              child: const LoadingWidget(),
            ),
        barrierDismissible: false,
        barrierColor: Colors.amber.withOpacity(0.3));
  }

  hideIndicator() {
    Navigator.of(context).pop();
  }

  displayPaymentSheet() async {
    try {
      Stripe.instance
          .presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
              clientSecret: paymentIntentData!['client_secret'],
              confirmPayment: true))
          .then((_) async {
        debugPrint("adding booking to database...");
        showIndicator();
        Booking booking = Booking(
            id: 'id',
            name: widget.name,
            image: widget.imageUrl,
            cost: widget.cost,
            reservedFrom: widget.reservedFrom,
            bookingPath: widget.reservedPath,
            bookingType: 'card',
            date: DateTime.now(),
            reservedId: widget.reservedId,
            reservedUntil: widget.reservedTo,
            userId: widget.uid);
        await DataBaseServer.booking(booking: booking).then((value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Paid Successfully")));
          debugPrint("adding booking to database completed successfully");
        });
        hideIndicator();
      });
      setState(() {
        paymentIntentData = null;
      });
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Paid Failed")));
    }
  }

  createPaymentIntent(int price, String Currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': (price * 100).toString(),
        'currency': Currency,
        'payment_method_types[]': 'card'
      };

      var response = await dio.post('/payment_intents',
          data: body,
          options: Options(headers: {
            'Authorization':
            'Bearer sk_test_51KyxOBKdQHHlIDs49nbLTSBn1nkPjuRBYjR3l0zD9aaxOlfyvHz02fnRblOlBTfpIUvKvaP2HzUlhqBCmfLvazpj00gDgrgO8h',
            'Content-Type': 'application/x-www-form-urlencoded'
          }));

      print(response.data.toString());

      return response.data;
    } catch (e) {
      print("Dio Error 666");
      print(e.toString());
    }
  }
}

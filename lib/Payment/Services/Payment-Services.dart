
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeTransactionResponse{
  late String message;
  late bool success;

 StripeTransactionResponse({required this.message, required this.success});
}

class StripeService {
  static String ApiBase = 'https://api.stripe.com//v1';
  static String secret= '';
  static Dio dio= Dio(BaseOptions(baseUrl:ApiBase));

  static Map<String, dynamic>? paymentIntentData;

  static init(){
   // Stripe.publishableKey="pk_test_51KyxOBKdQHHlIDs4ETU4I8vOoP1j0pLE4maKl2IQoUbJDyW64kfcAyuV4tHJFVajel0KHhdewtynqTIINzUgm4kp00Df4cqho5";
  }

  static payViaExistingCard(String amount, String Currency,card){
    return StripeTransactionResponse(message: "successful", success: true);
  }

  static payWithNewCard(String amount, String Currency){
    return StripeTransactionResponse(message: "successful", success: true);
  }

  // static makePaymen()async {
  //   try{
  //     paymentIntentData= await createPaymentIntent('20','USD');
  //     await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: paymentIntentData!['client_secret']
  //         ,googlePay: true,style: ThemeMode.dark,
  //          merchantCountryCode: 'US',
  //          merchantDisplayName:"Hotel" ));
  //
  //     displayPaymentSheet();
  //
  //   }catch(e)
  //   {
  //     print(e.toString());
  //   }
  // }
  //
  // static displayPaymentSheet()async{
  //   try {
  //     Stripe.instance.presentPaymentSheet(parameters: PresentPaymentSheetParameters(clientSecret:paymentIntentData!['client_secret'],
  //     confirmPayment: true)
  //     );
  //
  //    // setState((){paymentIntentData= null;});
  //
  //     //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Paid Successfully")));
  //
  //
  //
  //   }
  //   on StripeException catch(e)
  //   {
  //     print(e.toString());
  //    // showDialog(context: context, builder: (_)=>AlertDialog(content: Text("Failed"),));
  //
  //
  //
  //
  //   }
  //
  // }
  //
  // static createPaymentIntent(String amount, String Currency)async {
  //   try{
  //    Map<String, dynamic> body = {
  //      'amount':calculateAmount(amount),
  //      'currency':Currency,
  //      'payment_method_types[]':'card'
  //
  //    };
  //
  //    var response=await dio.post('/payment_intents',data: body,
  //        options: Options(
  //            headers: {
  //              'Authorization':'Bearer sk_test_51KyxOBKdQHHlIDs49nbLTSBn1nkPjuRBYjR3l0zD9aaxOlfyvHz02fnRblOlBTfpIUvKvaP2HzUlhqBCmfLvazpj00gDgrgO8h',
  //              'Content-Type':'application/x-www-form-urlencoded'}));
  //
  //    return response.data;
  //
  //   }catch(e)
  //   {
  //     print(e.toString());
  //   }
  // }
  //
  // static calculateAmount(String amount){
  //   final price = int.parse(amount)*100;
  //   return price;
  //
  // }

}


import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

import 'Services/Payment-Services.dart';

class ExistingCradsPage extends StatefulWidget {
  const ExistingCradsPage({Key? key}) : super(key: key);

  @override
  State<ExistingCradsPage> createState() => _ExistingCradsPageState();
}

class _ExistingCradsPageState extends State<ExistingCradsPage> {

  List cards= [{
    'cardNumber':'4242424242424242',
    'expiryDate':'04/24',
    'cardHolderName':'Yamen AN',
    'cvvCode':'424',
    'showBackView':false,
  },
    {
      'cardNumber':'4000000000009995',
      'expiryDate':'04/23',
      'cardHolderName':'Moira O;deorain',
      'cvvCode':'123',
      'showBackView':false,
    },
    ];

  payViaExistingCard(BuildContext context,card){
    StripeTransactionResponse response = StripeService.payViaExistingCard('150', 'USD',card);
    if(response.success)
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(response.message),duration: Duration(microseconds: 5000))).closed.then((value) { Navigator.pop(context);});


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose Existing Crad"),),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(itemCount: cards.length,itemBuilder: (BuildContext context,int index){
            var card = cards[index];
            return InkWell(child:
            CreditCardWidget(cardNumber:card['cardNumber'],
                expiryDate: card['expiryDate'] ,
                cardHolderName: card['cardHolderName'],
                cvvCode: card['cvvCode'],
                showBackView: card['showBackView'],
                onCreditCardWidgetChange: (CreditCardBrand ) {  }
                ),
            onTap: (){
              payViaExistingCard(context, card);
            },);
          }),
        ),
      ),
    );
  }
}

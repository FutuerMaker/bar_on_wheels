import 'dart:async';
import 'dart:convert';

import 'package:bar_on_wheels/providers/app_provider.dart';
import 'package:bar_on_wheels/widgets/nav_bar/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../constants/routes.dart';
import '../firebase_helper/firebase_firestore_helper/firebase_firestore_helper.dart';

class StripeHelper {
  static StripeHelper instance = StripeHelper();

  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment(String amount, BuildContext context) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'GBP');

      var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "GB", currencyCode: "GBP", testEnv: true);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
            customerId: paymentIntent!['customer'],
            paymentIntentClientSecret:
                paymentIntent!['client_secret'], //Gotten from payment intent
            style: ThemeMode.light,
            merchantDisplayName: 'Bar On Wheels',
            googlePay: gpay,
          ))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet(context);
    } catch (err) {
      showMessage(err.toString());
    }
  }
}

displayPaymentSheet(BuildContext context) async {
  AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
  try {
    await Stripe.instance.presentPaymentSheet().then((value) async {
      bool value = await FirebaseFirestoreHelper.instance
          .uploadOrderedProductFirebase(
              appProvider.getBuyProductList, context, "Card");

      appProvider.clearBuyProduct();
      if (value) {
        Future.delayed(const Duration(seconds: 2), () {
          Routes.instance.push(const CustomNavigationBar(), context);
        });
      }
    });
  } catch (e) {
    showMessage(e.toString());
  }
}

createPaymentIntent(String amount, String currency) async {
  try {
    Map<String, dynamic> body = {
      "amount": amount,
      "currency": currency,
    };
    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization':
            'Bearer sk_test_51NsRk2BOiYiTDmax9tB0SWLe1wO4ZDuKnicImHZrhpp2RZak8mvWB7hGZGDEVTbGxNWvIpT9ollvqh9EihNWifzd00ekw0boOO',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body,
    );
    return jsonDecode(response.body);
  } catch (err) {
    throw Exception(err.toString());
  }
}

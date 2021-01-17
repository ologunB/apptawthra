import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class Server{
  Future<String> createCheckout(isLoading, setState) async {
    final auth = 'Basic ' +
        base64Encode(utf8.encode(
            'sk_test_51HjsXiD2Y81WySxcSYZQxWqgom4mPTou65NDgdWwJ8PECjIT98CwUU4vyudP4BpSrZDjp4elhfPXcakUcHQia3bg00zX1RDDdo'));
    final body = {
      'payment_method_types': ['card'],
      'line_items': [
        {
          'price': "price_1Hoo4kD2Y81WySxcmTKgXsw4",
          'quantity': 1,
        }
      ],
      'mode': 'payment',
      'success_url': 'https://success.com/{CHECKOUT_SESSION_ID}',
      'cancel_url': 'https://cancel.com/',
    };

    try {
      isLoading = true;
      setState(() {});
      final result = await Dio().post(
        "https://api.stripe.com/v1/checkout/sessions",
        data: body,
        options: Options(
          headers: {HttpHeaders.authorizationHeader: auth},
          contentType: "application/x-www-form-urlencoded",
        ),
      );
      print(result);
      isLoading = false;
      setState(() {});
      return result.data['id'];
    } on DioError catch (e) {
      isLoading = false;
      setState(() {});
      print(e.response);
      throw e;
    }
  }
}
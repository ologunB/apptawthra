import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckoutPage extends StatefulWidget {
  final Widget successView;
  final String sessionId;

  const CheckoutPage({Key key, @required this.sessionId, @required this.successView})
      : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  WebViewController _controller;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      progressIndicator: CupertinoActivityIndicator(radius: 15),
      isLoading: isLoading,
      color: Colors.grey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: WebView(
            initialUrl: initialUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (String url) {
              //<---- add this
              if (url == initialUrl) {
                _redirectToStripe();
              }
              isLoading = false;
              setState(() {});
            },
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://success.com')) {
                setState(() {});
                Navigator.of(context).pop('success');
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => widget.successView,
                        settings: RouteSettings(arguments: {
                          "message": "Payment Made successfully, Create a tweet now",
                        })));

                // <-- Handle success case
              } else if (request.url.startsWith('https://cancel.com')) {
                Navigator.of(context).pop('cancel'); // <-- Handle cancel case
                print("Problem occurred when paying");
              }
              return NavigationDecision.navigate;
            },
            onWebViewCreated: (controller) => _controller = controller,
          ),
        ),
      ),
    );
  }

  String get initialUrl =>
      'data:text/html;base64,${base64Encode(Utf8Encoder().convert(kStripeHtmlPage))}';

  void _redirectToStripe() {
    //<--- prepare the JS in a normal string
    final redirectToCheckoutJs = '''
var stripe = Stripe("pk_test_51Hzo6FLaLQ9qavQZGmpnR9hhM526DTWZ4FwGDV3zSkyqUpUYZO59naUPDImFt4Nt3hriCb3voQxteQNENWeB0BxQ00r3DrQLSS");
    
stripe.redirectToCheckout({
  sessionId: '${widget.sessionId}'
}).then(function (result) {
  result.error.message = 'Error'
});

  
''';
    _controller
        .evaluateJavascript(redirectToCheckoutJs)
        .then((value) {}); //<--- call the JS function on controller
  }
}

const kStripeHtmlPage = '''
<!DOCTYPE html>
<html>
<script src="https://js.stripe.com/v3/"></script>
<head><title>Stripe checkout</title></head>
<body>
<h3> Redirecting... <h3>
<h3> إعادة توجيه... <h3>
</body>
</html>
''';

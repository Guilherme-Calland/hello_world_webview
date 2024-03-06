import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(WebViewExample());
}

class WebViewExample extends StatelessWidget {
  WebViewExample({super.key, this.controller});

  WebViewController? controller;

  @override
  Widget build(BuildContext context) {
    controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },

      // onPageStarted: (String url) {},
      onPageFinished: (String url) async{
        // // Execute JavaScript code to send a message
        // final result = await controller?.evalJavascript('''
        //   window.postMessage("Hello from JavaScript");
        // ''');

        // // Handle the result in Flutter
        // print('Result from JavaScript: $result');
      },
      // onWebResourceError: (WebResourceError error) {},
      // onNavigationRequest: (NavigationRequest request) {
      //   if (request.url.startsWith('https://www.youtube.com/')) {
      //     return NavigationDecision.prevent;
      //   }
      //   return NavigationDecision.navigate;
      // },
    ),
  )
  ..addJavaScriptChannel('messageHandler', onMessageReceived: (val){
    if (kDebugMode) {
      print(val.message);
    }
  })
  ..loadHtmlString(

    '''
      <head>
          <script>
              function encryptCreditCard(){
                  console.log("hello world from test")
                  // window.postMessage("Hello from JavaScript");
                  window.messageHandler.postMessage("hello from javascript");
              }
          </script>
          <style>
              /* Center the content horizontally and vertically */
              body {
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh; /* Full height of the viewport */
                margin: 0; /* Remove default margin */
                background-color: #e0f2f1;
              }
          
              /* Style for the "HELLO WORLD" message */
              .hello-world {
                font-size: 48px; /* Adjust font size as needed */
                font-weight: bold;
              }
            </style>
      </head>
      <body onload="encryptCreditCard()">
          <div class="hello-world">HELLO WORLD</div>
      </body>
    '''

  )
  
  ;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Simple Example')),
        body: WebViewWidget(controller: controller!),
      ),
    );
  }
}

// class WebViewPlusExample extends StatelessWidget {
//   const WebViewPlusExample({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: MainPage(),
//     );
//   }
// }

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   late WebViewControllerPlus _controler;

//   @override
//   void initState() {
//     _controler = WebViewControllerPlus()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(),
//       )
//       ..loadFlutterAssetServer('assets/index.html');
      
      
//     super.initState();
//   }

//   final double _height = 300;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: 
//       ListView(
//         children: [
//           Text("Height of Webview: $_height",
//               style: const TextStyle(fontWeight: FontWeight.bold)),
//           SizedBox(
//             height: _height,
//             child: WebViewWidget(
//               controller: _controler,
//             ),
//           ),
//           const Text("End of Webview",
//               style: TextStyle(fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controler.server.close();
//     super.dispose();
//   }
// }
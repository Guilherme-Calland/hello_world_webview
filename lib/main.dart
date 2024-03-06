import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

void main() {
  runApp(const WebViewPlusExample());
}

class WebViewPlusExample extends StatelessWidget {
  const WebViewPlusExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late WebViewControllerPlus _controler;

  @override
  void initState() {
    _controler = WebViewControllerPlus()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel('name', onMessageReceived: (msg){
        if (kDebugMode) {
          print(msg.message);
        }
      })
      
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            _controler.onLoaded((msg) {
              _controler.getWebViewHeight().then((value) {
                var height = int.parse(value.toString()).toDouble();
                if (height != _height) {
                  
                  setState(() {
                    _height = height;
                  });
                }
              });
            } 
            
            );
            
          },
        ),
      )
      ..loadFlutterAssetServer('assets/index.html');
      
    super.initState();
  }

  double _height = 300;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      ListView(
        children: [
          Text("Height of Webview: $_height",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(
            height: _height,
            child: WebViewWidget(
              controller: _controler,
            ),
          ),
          const Text("End of Webview",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controler.server.close();
    super.dispose();
  }
}
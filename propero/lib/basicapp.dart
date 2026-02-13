import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

void main() {
  // Customize the system UI overlay style to set status bar color
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.black),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // SplashScreen as home screen
    );
  }
}

// SplashScreen Widget
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to WebView after a delay of 3 seconds
    _navigateToWebView();
  }

  Future<void> _navigateToWebView() async {
    await Future.delayed(const Duration(seconds: 3));
    // Push WebView screen after the delay
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const WebViewPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}

// WebViewPage Widget
class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    // Initialize WebView
    _initializeWebView();
  }

  // Initialize WebView and its settings
  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(
          JavaScriptMode.unrestricted) // Allow unrestricted JavaScript
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Handle page load progress here (e.g., update a loading bar)
            print('Page loading progress: $progress%');
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          onNavigationRequest: (NavigationRequest request) {
            // Check if the URL uses 'http' or 'https' protocol
            if (request.url.startsWith('http://') ||
                request.url.startsWith('https://')) {
              // Block navigation to specific domains (e.g., YouTube)
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent; // Prevent loading YouTube
              }
              return NavigationDecision
                  .navigate; // Allow all other HTTP/HTTPS URLs
            } else {
              // Block any non-HTTP(S) URLs
              print('Blocked non-HTTP/HTTPS URL: ${request.url}');
              return NavigationDecision.prevent;
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://speed.propero.in/webapp')); // Load the Flutter website initially
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: _webViewController),
      ),
    );
  }
}

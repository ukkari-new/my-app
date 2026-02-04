import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    title: 'Enzeiverse Engine',
    debugShowCheckedModeBanner: false,
    home: WebViewApp(),
  ));
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) {
            debugPrint("Web Error: ${error.description}");
          },
        ),
      )
      // GANTI LINK DI BAWAH INI DENGAN LINK PANEL PTERO KAMU
      ..loadRequest(Uri.parse('http://UBAH_LINK_DISINI.com'));

    // Optimasi Cache untuk Android agar tidak "Cache Miss"
    final platform = controller.platform;
    if (platform is AndroidWebViewController) {
      platform.setGeolocationEnabled(true);
      // Mengizinkan penyimpanan database web lokal
      platform.setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // WillPopScope agar tombol 'Back' di HP kembali ke halaman web sebelumnya, bukan keluar app
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          if (await controller.canGoBack()) {
            controller.goBack();
          } else {
            if (context.mounted) Navigator.of(context).pop();
          }
        },
        child: SafeArea(
          child: WebViewWidget(controller: controller),
        ),
      ),
    );
  }
}

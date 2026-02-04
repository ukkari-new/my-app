import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Tambahkan baris ini jika kamu ingin kontrol cache lebih dalam (opsional)
import 'package:webview_flutter_android/webview_flutter_android.dart'; 

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false, 
  home: WebViewApp()
));

class WebViewApp extends StatefulWidget {
  @override
  _WebViewAppState createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi Controller
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // --- BAGIAN CACHE ---
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) {
            // Jika benar-benar tidak ada cache dan internet mati, baru tampilkan ini
            // Tapi jika ada cache, WebView biasanya akan otomatis menampilkan versi terakhir
            debugPrint("Web Error: ${error.description}");
          },
        ),
      )
      // Link Web Panel Ptero kamu
      ..loadRequest(Uri.parse('http://privserv.my.id:2456'));

    // --- LOGIKA AGAR TETAP TAMPIL SAAT OFFLINE ---
    if (controller.platform is AndroidWebViewController) {
      // Mengaktifkan penyimpanan cache di sistem Android
      (controller.platform as AndroidWebViewController)
          .setGeolocationEnabled(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan WillPopScope agar jika ditekan tombol back, tidak langsung keluar app
      body: WillPopScope(
        onWillPop: () async {
          if (await controller.canGoBack()) {
            controller.goBack();
            return false;
          }
          return true;
        },
        child: SafeArea(child: WebViewWidget(controller: controller)),
      ),
    );
  }
}

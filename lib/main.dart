import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_admob_tutorial_1/my_home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdMob Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<void>(
        future: _initGoogleMobileAds(),
        builder: (context, snapshot) {
          return const MyHomePage(title: 'AdMob Flutter Demo');
        },
      ),
    );
  }
}

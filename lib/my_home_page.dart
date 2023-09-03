import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'ad_helper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    if (_counter % 10 == 5 && _interstitialAd == null) {
      _loadInterstitialAd();
    }

    if (_counter % 10 == 0) {
      _rewardedAd?.show(
        onUserEarnedReward: (ad, reward) {
          _counter += 100;
        },
      );

      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       title: const Text('Need extra counter?'),
      //       actions: [
      //         TextButton(
      //           child: const Text('cancel'),
      //           onPressed: () {
      //             Navigator.pop(context);
      //           },
      //         ),
      //         TextButton(
      //           child: const Text('Ok'),
      //           onPressed: () {
      //             Navigator.pop(context);
      //           },
      //         ),
      //       ],
      //     );
      //   },
      // );
    }
  }

  void _loadBannerAd() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _interstitialAd = null;
              ad.dispose();
            },
          );

          setState(() {
            _interstitialAd = ad;
          });

          _interstitialAd?.show();
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a interstitial ad: ${err.message}');
        },
      ),
    );
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback =
              FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
            setState(() {
              ad.dispose();
              _rewardedAd = null;
            });
            _loadRewardedAd();
          });

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _loadRewardedAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_bannerAd != null)
                SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(
                    ad: _bannerAd!,
                  ),
                ),
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

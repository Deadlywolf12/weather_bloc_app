import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_bloc_app/screens/Theme/app_colors.dart';
import 'package:weather_bloc_app/services/location_service.dart';
import 'home_screen.dart'; // your home screen import
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // add this package for dots

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final pages = [
    {
      "title": "Welcome to Weatherly App",
      "body": "Get accurate weather updates anytime, anywhere.",
      "image": "assets/logo.png",
    },
    {
      "title": "Real-time Location",
      "body": "Automatically detect your location for local weather.",
      "image": "assets/location.png",
    },
  ];

  void _onDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    _getCurrentLocationWeather(context);
  }

  void _skip() {
    _onDone();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildPage(Map<String, String> page) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // center all vertically
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Center(
              child: Image.asset(page["image"]!, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            page["title"]!,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page["body"]!,
            style: const TextStyle(fontSize: 16, color: AppColors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentIndex == pages.length - 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _skip,
            child: const Text('Skip',
                style: TextStyle(color: AppColors.primaryColor1)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, index) {
                return buildPage(pages[index]);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: pages.length,
                  effect: const WormEffect(
                    activeDotColor: AppColors.primaryColor1,
                    dotHeight: 12,
                    dotWidth: 12,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (isLastPage) {
                      _onDone();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(isLastPage ? "Enable Location" : "Next"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor1,
                    foregroundColor: AppColors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    textStyle:
                        const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _getCurrentLocationWeather(BuildContext context) async {
    try {
      final position = await LocationService().determinePosition();
      final lat = position.latitude;
      final lon = position.longitude;

      print("Lat: $lat, Lon: $lon");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lat: $lat, Lon: $lon")),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}

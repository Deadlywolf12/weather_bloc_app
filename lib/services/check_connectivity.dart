import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> hasRealInternet() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (e) {
    return false;
  }
}

Future<bool> checkConnectivity() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  final hasInternet = await hasRealInternet();

  final isConnected =
      connectivityResult != ConnectivityResult.none && hasInternet;

  return isConnected;
}

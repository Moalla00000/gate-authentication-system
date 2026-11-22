import 'package:flutter/material.dart';

class AuthListenable extends ChangeNotifier {
  AuthListenable(List<Stream<dynamic>> streams) {
    for (final stream in streams) {
      stream.listen((_) => notifyListeners());
    }
  }
}

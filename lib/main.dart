import 'package:flutter/material.dart';
import 'package:bpulsa/di/dependency_injection.dart';
import 'package:bpulsa/myapp.dart';

void main() {
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Injector.configure(Flavor.MOCK);
  runApp(MyApp());
}

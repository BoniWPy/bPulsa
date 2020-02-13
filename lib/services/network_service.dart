import 'package:bpulsa/services/restclient.dart';

abstract class NetworkService {
  RestClient rest;
  NetworkService(this.rest);
}

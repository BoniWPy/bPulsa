import 'package:flutter/material.dart';

class TukarPointModel {
  String id_trade_point;
  String name;
  String image;
  String rating;
  String price;
  String brand;
  String description;
  int quantity = 0;

  TukarPointModel(
      {
      this.id_trade_point,
      this.name,
      this.image,
      this.brand,
      this.price,
      this.rating,
      this.description,
      this.quantity});

  
}



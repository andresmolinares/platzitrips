import 'package:platzi_trips_app/User/model/user.dart';
import 'package:flutter/material.dart';
class Place {
  String? id;
  String name;
  String description;
  String urlImage;
  int likes;
  bool liked;
  //User? userOwner;

  Place({
    Key? key,
    this.id,
    required this.name,
    required this.description,
    this.urlImage="https://imgur.com/gallery/r374R",
    this.likes = 0,
    this.liked = false,
    //this.userOwner
});
}
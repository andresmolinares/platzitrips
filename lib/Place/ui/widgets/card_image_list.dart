import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/Place/model/place.dart';
import 'package:platzi_trips_app/User/bloc/bloc_user.dart';
import 'package:platzi_trips_app/User/model/user.dart';
import 'card_image.dart';

class CardImageList extends StatefulWidget {
  final User user;

  CardImageList({Key? key, required this.user});

  @override
  State<StatefulWidget> createState() {
    return _CardImageList();
  }
}

class _CardImageList extends State<CardImageList> {
  UserBloc? userBloc;
  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);

    return Container(
      //margin: EdgeInsets.only(top: 10.0),
        height: 350.0,
        child: StreamBuilder(
            stream: userBloc!.placesStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return CircularProgressIndicator();
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                case ConnectionState.active:
                  print("PLACESLIST: ACTIVE");
                  return listViewPlaces(userBloc!.buildPlaces(snapshot.data!.docs, widget.user));
                case ConnectionState.done:
                  print("PLACESLIST: DONE");
                  return listViewPlaces(userBloc!.buildPlaces(snapshot.data!.docs, widget.user));
              }
            }));
  }

  Widget listViewPlaces(List<Place> places) {
    //Metodo para desencadenar las acciones al dar like o dislike con el boton del Heart
    void setLiked(Place place){
      setState(() {
        place.liked = !place.liked;
        userBloc!.likePlace(place, widget.user.uid!);
      });
    }

    IconData iconDataLiked = Icons.favorite;
    IconData iconDataLike = Icons.favorite_border;
    return ListView(
      padding: EdgeInsets.all(25.0),
      scrollDirection: Axis.horizontal,
      children: places.map((place){
        return CardImageWithFabIcon(
          pathImage: place.urlImage,
          width: 300.0,
          height: 250.0,
          left: 20.0,
          iconData: place.liked?iconDataLiked:iconDataLike,
          onPressedFabIcon: (){
            setLiked(place);
          },
          internet: true,
        );
      }).toList(),
    );
  }
}



  //Widget listViewPlaces(List<Place> places){}

      /*ListView(
        padding: EdgeInsets.all(25.0),
        scrollDirection: Axis.horizontal,
        children:
      ),*/

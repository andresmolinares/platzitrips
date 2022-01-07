import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:platzi_trips_app/Place/model/place.dart';
import 'package:platzi_trips_app/Place/ui/widgets/card_image.dart';
import 'package:platzi_trips_app/User/model/user.dart' as modelUser;
import 'package:platzi_trips_app/User/ui/widgets/profile_place.dart';

class CloudFirestoreAPI{
  final String USERS = "users";
  final String PLACES = "places";

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void updateUserData(modelUser.User user) async {
    DocumentReference ref = _db.collection(USERS).doc(user.uid);
    return await ref.set({
      'uid': user.uid,
      'name': user.name,
      'email': user.email,
      'photoURL': user.photoURL,
      'myPlaces': user.myPlaces,
      'myFavoritePlaces': user.myFavoritePlaces,
      'lastSignIn': DateTime.now()
    }, SetOptions(merge: true));
  }

  Future<void> updatePlaceData(Place place) async {
    CollectionReference refPlaces = _db.collection(PLACES);

    String uid = (await _auth.currentUser!).uid;
    await refPlaces.add({
      'name': place.name,
      'description': place.description,
      'likes': place.likes,
      'userOwner': _db.doc("$USERS/$uid"),
      'photoURL': place.urlImage,
      'usersLiked': FieldValue.arrayUnion([])
    }).then((DocumentReference dr){
      dr.get().then((snapshot){
        snapshot.reference;
        DocumentReference refUsers = _db.collection(USERS).doc(uid);
        refUsers.update({
          'myPlaces': FieldValue.arrayUnion([_db.doc("$PLACES/${snapshot.id}")])
        });
      });
    });
  }

  List<ProfilePlace> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot) {
    List<ProfilePlace> profilePlaces = [];
    placesListSnapshot.forEach((p) {
      //Map<String, dynamic> data = place.data()! as Map<String, dynamic>;
      profilePlaces.add(ProfilePlace(Place(
          name: p['name'],
          description: p['description'],
          urlImage: p['photoURL'],
          likes: p['likes'])));
    });
    return profilePlaces;
  }
  List <Place> buildPlaces(List<DocumentSnapshot> placesListSnapshot, modelUser.User user){
    List <Place> places = [];

    placesListSnapshot.forEach((p)  {
      Place place = Place(id: p.id, name: p["name"], description: p["description"],
          urlImage: p["photoURL"] ,likes: p["likes"]
      );
      List<dynamic>? usersLikedRefs =  p["usersLiked"];
      place.liked = false;
      usersLikedRefs?.forEach((drUL){
        if(user.uid == drUL.id){
          place.liked = true;
        }
      });
      places.add(place);
    });
    return places;
  }

  Future likePlace(Place place, String uid) async {
    await _db.collection(PLACES).doc(place.id).get()
        .then((DocumentSnapshot ds){
          int likes = ds["likes"];

          _db.collection(PLACES).doc(place.id)
              .update({
            'likes': place.liked?likes+1:likes-1,
            'usersLiked':  place.liked?
            FieldValue.arrayUnion([_db.doc("${USERS}/${uid}")]):
            FieldValue.arrayRemove([_db.doc("${USERS}/${uid}")])
          });
    });
  }
/*await _auth.currentUser!.then((User user){
      refPlaces.add(
          {
            'name': place.name,
            'description': place.description,
            'likes': place.likes,
            'userOwner': "${USERS}/ ${user.uid}",
          }
      );
    });*/

}
import 'package:flutter/material.dart';
import 'package:platzi_trips_app/widgets/gradient_back.dart';
import 'package:platzi_trips_app/widgets/button_green.dart';
import 'package:platzi_trips_app/User/bloc/bloc_user.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/platzi_trips_cupertino.dart';
import 'package:platzi_trips_app/User/model/user.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInScreen();
  }

}

class _SignInScreen extends State<SignInScreen>{
  UserBloc? userBloc;
  double? screenWidth;
  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    screenWidth = MediaQuery.of(context).size.width;
    return _handleCurrentSession();
  }

  Widget _handleCurrentSession(){
  return StreamBuilder(
      stream: userBloc!.authStatus,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return signInGoogleUI(); //Si no hay datos en User pide que se autentique
        } else {
          return PlatziTripsCupertino(); //Si hay datos de Usuario autenticado pasa a la pantalla principal de la app de viajes
        }
      },

  );
  }

  Widget signInGoogleUI(){
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget> [
          Flexible(
            child: Container(
              width: screenWidth,
              child: Text("Welcome \n This is yout Travel App",
                style: TextStyle(
                    fontSize: 37.0,
                    fontFamily: "Lato",
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          GradientBack(height: null),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              ButtonGreen(text: "Login with Gmail",
                  onPressed: (){
                  userBloc!.signOut();
                    userBloc!.signIn().then((value) {
                      userBloc!.updateUserData(User(
                        uid: value.user!.uid.toString(),
                        name: value.user!.displayName.toString(),
                        email: value.user!.email.toString(),
                        photoURL: value.user!.photoURL.toString()


                      ));
                    });
              },
              width: 300.0,
              height: 50.0,
              ),
            ],
          ),
        ],

      ),
    );
  }

}
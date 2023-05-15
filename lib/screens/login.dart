// ignore_for_file: unnecessary_null_comparison

import 'package:ati/models/user.dart';
import 'package:ati/screens/home_screen.dart';
import 'package:ati/utils/utilsGoogle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart'
    show GoogleAuthButton, AuthButtonStyle, AuthButtonType;
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _accesToken;
  String? _displayName;
  String? close;
  String? name;
  String? email;
  var file;

  @override
  void initState() {
    recuperaToken();
    recuperaDisplayName();
    recuperaEmail();
    super.initState();
  }

  void recuperaToken() async {
    _accesToken = await UserData.leeToken();
    setState(() {
      close = _accesToken;
    });
  }

  void recuperaDisplayName() async {
    _displayName = await UserData.leeDisplayName();
    setState(() {
      name = _displayName;
    });
  }

  void recuperaEmail() async {
    _displayName = await UserData.leeDisplayEmail();
    setState(() {
      email = _displayName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _accesToken != null
        ? HomeScreen(
            key: widget.key,
            user: name,
            email: email,
          )
        : Scaffold(
            body: btnSignIn(),
          );
  }

  Widget btnSignIn() {
    var media = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: GradientColors.mirage,
        ),
      ),
      child: Center(
        child: SizedBox(
          height: media.height < 700 ? 610 : 500,
          width: media.width < 600 ? 350 : 500,
          child: Card(
            elevation: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DelayedDisplay(
                    delay: const Duration(milliseconds: 500),
                    child: Column(
                      children: [
                        Text(
                          "BIENVENIDO A",
                          style: TextStyle(
                            letterSpacing: media.width < 600 ? 8 : 15,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                            color: const Color.fromARGB(255, 45, 100, 182),
                          ),
                        ),
                        CachedNetworkImage(
                          imageUrl:
                              'https://i.postimg.cc/g0St7K7T/buscador-y-comparador.jpg',
                          width: 601.0,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.image_not_supported),
                        ),
                      ],
                    ),
                  ),
                ),
                DelayedDisplay(
                  delay: const Duration(milliseconds: 100),
                  child: GoogleAuthButton(
                    style: const AuthButtonStyle(
                      textStyle:
                          TextStyle(color: Color.fromARGB(255, 253, 253, 253)),
                      iconBackground: Color.fromRGBO(243, 241, 241, 1),
                      buttonColor: Color.fromRGBO(33, 150, 243, 1),
                      buttonType: AuthButtonType.secondary,
                    ),
                    text: 'Iniciar Sesión',
                    onPressed: () async {
                      await Utils().signInWhithGoogle().then((user) {
                        if (user != null) {
                          setState(() {
                            file = user;
                            Navigator.pushAndRemoveUntil(
                                context,
                                SwipeablePageRoute(
                                  title: 'ATI TECNOLOÍA INTEGRADA',
                                  transitionDuration:
                                      const Duration(milliseconds: 500),
                                  builder: (context) => HomeScreen(
                                    key: widget.key,
                                    user: user.user.displayName,
                                    email: user.user.email,
                                  ),
                                ),
                                (route) => false);
                          });
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

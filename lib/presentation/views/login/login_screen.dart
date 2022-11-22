import 'package:autobaires/core/constants.dart';
import 'package:autobaires/presentation/views/widgets/custom_elevated_button.dart';
import 'package:autobaires/presentation/views/widgets/custom_progress.dart';
import 'package:autobaires/presentation/views/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = ROUTE_LOGIN_SCREEN;

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const LoginScreen(),
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isShowingAlert = false;
  bool isShowingLogin = false;
  String email = "";
  String password = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      signIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          if (!isShowingLogin) ...[
            const CustomProgress(),
          ],
          if (isShowingLogin) ...[
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(IMAGE_LOGIN, fit: BoxFit.cover),
            ),
            SingleChildScrollView(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: const [
                              BoxShadow(
                                color: COLOR_MAGENTA,
                                spreadRadius: SHADOW_SPREAD_RADIUS,
                                blurRadius: SHADOW_BLUR_RADIUS,
                                offset:
                                    Offset(SHADOW_OFFSET_X, SHADOW_OFFSET_Y),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(IMAGE_LOGO, fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        CustomTextField(
                          title: "Email",
                          hint: "Ingresá el email",
                          icon: Icons.email_rounded,
                          onChanged: (value) {
                            setState(() {
                              email = value;
                              isShowingAlert = false;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          title: "Contraseña",
                          hint: "Ingresá la contraseña",
                          icon: Icons.password_rounded,
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              password = value;
                              isShowingAlert = false;
                            });
                          },
                        ),
                        AnimatedOpacity(
                          opacity: isShowingAlert ? 1 : 0,
                          duration: const Duration(milliseconds: 500),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                TEXT_ALERT,
                                style: GoogleFonts.roboto(
                                    fontWeight: WEIGHT_TEXT_THREE,
                                    fontSize: SIZE_TEXT_THREE,
                                    color: COLOR_RED),
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            CustomElevatedButton(
                              text: "Ingresar",
                              icon: Icons.arrow_forward_rounded,
                              isSelected: true,
                              onPressed: (() async {
                                setState(() {
                                  signInWithEmailAndPassword();
                                });
                              }),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ],
      ),
    );
  }

  void signIn() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      startLogin();
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(TEXT_SHARED, true);
    startHome();
  }

  void signInWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(TEXT_SHARED, true);
      startHome();
    } on FirebaseAuthException catch (_) {
      setState(() {
        isShowingAlert = true;
      });
    }
  }

  void startLogin() {
    setState(() {
      isShowingLogin = true;
    });
  }

  void startHome() {
    Navigator.pushNamedAndRemoveUntil(
        context, ROUTE_HOME_SCREEN, (route) => false);
  }
}

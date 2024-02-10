// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:finnotes/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

Future hanldeLogin(username, gender) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('username', username);
  prefs.setString('gender', gender == 0 ? 'Male' : 'Female');
  Get.offAllNamed(AppRoute.HOME);
}

class _LoginState extends State<Login> {
  final _UserNameController = TextEditingController();
  bool _validateUserName = false;
  int selectedGender = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializePreferences();
  }

  //Nav to home page if is logined
  Future<void> initializePreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('username') != null) {
      Get.offAllNamed(AppRoute.HOME);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget customRadio(String text, FaIcon icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() => selectedGender = index);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: Container(
            width: 120,
            height: 50,
            decoration: BoxDecoration(
              color: (selectedGender == index) ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: selectedGender == index ? Colors.grey : Colors.white,
                  blurRadius: 4,
                  offset: const Offset(4, 8), // Shadow position
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 5),
                Text(
                  text,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: (selectedGender == index)
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
                child: Padding(
              padding: EdgeInsets.all(screenSize.width * 0.1),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 65,
                      height: 65,
                    ),
                    SizedBox(height: screenSize.height * 0.05),
                    Text(
                      'Fin',
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 60,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Notes',
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 60,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.05),
                    TextField(
                      controller: _UserNameController,
                      decoration: InputDecoration(
                        labelText: 'Enter your name',
                        errorText:
                            _validateUserName ? "Name can't be null" : null,
                        fillColor: Colors.grey[400],
                        border: const UnderlineInputBorder(),
                        hintText: 'Name',
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.04),
                    Text(
                      "Gender",
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    Row(
                      children: [
                        customRadio(
                            "Male",
                            const FaIcon(FontAwesomeIcons.marsStroke,
                                color: Colors.blueAccent),
                            0),
                        customRadio(
                            "Female",
                            const FaIcon(FontAwesomeIcons.venus,
                                color: Colors.pinkAccent),
                            1),
                      ],
                    ),
                    SizedBox(height: screenSize.height * 0.1),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Let's Go",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.black,
                            child: IconButton(
                              iconSize: 35,
                              color: Colors.white,
                              onPressed: () async {
                                setState(() {
                                  _UserNameController.text.isEmpty
                                      ? _validateUserName = true
                                      : _validateUserName = false;
                                });
                                if (_UserNameController.text.isNotEmpty) {
                                  await hanldeLogin(
                                      _UserNameController.text, selectedGender);
                                  //
                                }
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.chevronRight,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            )),
          ),
        ),
        if (isLoading)
          const Opacity(
            opacity: 1,
            child: ModalBarrier(dismissible: false, color: Colors.white),
          ),
        if (isLoading)
          const Center(
            child: Image(
              image: AssetImage('assets/images/loading.gif'),
            ),
          ),
      ],
    );
  }
}

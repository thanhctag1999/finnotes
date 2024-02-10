import 'package:finnotes/controllers/note_controller.dart';
import 'package:finnotes/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/colors.dart';
import '../widgets/alert_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(NoteController());
  var name = '';
  var gender = '';
  bool isLoading = false;

  @override
  void initState() {
    initializePreferences();
    super.initState();
  }

  Future<void> initializePreferences() async {
    setState(() {
      isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('username') != null) {
      setState(() {
        name = prefs.getString('username')!;
        gender = prefs.getString('gender')!;
        isLoading = false;
      });
    } else {
      Get.offAllNamed(AppRoute.LOGIN);
    }
  }

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Get.offAllNamed(AppRoute.LOGIN);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: Image.asset(
              'assets/images/loading.gif',
              width: 200,
              height: 200,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: gender == 'Male'
                        ? const AssetImage(
                            'assets/images/male.jpg',
                          )
                        : const AssetImage('assets/images/female.jpg'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Hi, $name",
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              actions: [
                IconButton(
                  padding: const EdgeInsets.all(10),
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.black),
                  ),
                  icon: const Icon(
                    Icons.delete_rounded,
                    color: Colors.white,
                  ), // Change the icon to a menu icon
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialogWidget(
                          headingText:
                              "Are you sure you want to delete all notes?",
                          contentText:
                              "This will delete all notes permanently. You cannot undo this action.",
                          confirmFunction: () {
                            controller.deleteAllNotes();
                            Get.back();
                          },
                          declineFunction: () {
                            Get.back();
                          },
                        );
                      },
                    );
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  padding: const EdgeInsets.all(10),
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.black),
                  ),
                  icon: const Icon(
                    Icons.logout_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    logout();
                  },
                ),
              ],
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            body: GetBuilder<NoteController>(
              builder: (_) => Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fin',
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 74,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Notes',
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 74,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        controller.isEmpty() ? emptyNotes() : viewNotes()
                      ],
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButton: Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 1,
                  ),
                ],
                shape: BoxShape.circle, // ensures the container is circular
              ),
              child: IconButton(
                padding: const EdgeInsets.all(10),
                onPressed: () {
                  Get.toNamed(AppRoute.ADD_NEW_NOTE);
                },
                icon: const Icon(
                  Icons.add,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          );
  }

  Widget viewNotes() {
    return Scrollbar(
      child: Container(
        padding: const EdgeInsets.only(
          top: 10,
          right: 10,
          left: 10,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.notes.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Get.toNamed(AppRoute.EDIT_NOTE, arguments: index);
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialogWidget(
                      headingText: "Are you sure you want to delete this note?",
                      contentText:
                          "This will delete the note permanently. You cannot undo this action.",
                      confirmFunction: () {
                        controller.deleteNote(controller.notes[index].id!);
                        Get.back();
                      },
                      declineFunction: () {
                        Get.back();
                      },
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.notes[index].title!,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        controller.notes[index].content!,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            controller.notes[index].dateTimeEdited!,
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color.fromARGB(255, 80, 80, 80)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 1,
                                ),
                              ],
                              shape: BoxShape
                                  .circle, // ensures the container is circular
                            ),
                            child: IconButton(
                              padding: const EdgeInsets.all(10),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: controller.notes[index].content!));
                              },
                              icon: const Icon(
                                Icons.copy,
                                size: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 1,
                                ),
                              ],
                              shape: BoxShape
                                  .circle, // ensures the container is circular
                            ),
                            child: IconButton(
                              padding: const EdgeInsets.all(10),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialogWidget(
                                      headingText:
                                          "Are you sure you want to delete this note?",
                                      contentText:
                                          "This will delete the note permanently. You cannot undo this action.",
                                      confirmFunction: () {
                                        controller.deleteNote(
                                            controller.notes[index].id!);
                                        Get.offAllNamed(AppRoute.HOME);
                                      },
                                      declineFunction: () {
                                        Get.back();
                                      },
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                                size: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget emptyNotes() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Image(
            height: 300,
            width: 300,
            image: AssetImage('assets/images/empty.jpg'),
          ),
          Text(
            'Empty notes, add the first note to list',
            style: GoogleFonts.poppins(
                fontSize: 20, color: const Color.fromARGB(255, 80, 80, 80)),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

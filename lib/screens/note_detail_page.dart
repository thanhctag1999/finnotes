import 'package:finnotes/controllers/note_controller.dart';
import 'package:finnotes/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/alert_dialog.dart';

class NoteDetailPage extends StatelessWidget {
  final NoteController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final int i = ModalRoute.of(context)?.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: const EdgeInsets.all(12),
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
          ),
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
          ), // Change the icon to a menu icon
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.all(10),
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
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
                    headingText: "Are you sure you want to delete this notes?",
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
        ],
      ),
      body: GetBuilder<NoteController>(
        builder: (_) => Scrollbar(
          child: Container(
            padding: const EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  SelectableText(
                    controller.notes[i].title!,
                    style: GoogleFonts.poppins(
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Last Edited : ${controller.notes[i].dateTimeEdited}",
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SelectableText(
                    controller.notes[i].content!,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void editNote(int i) async {
    Get.toNamed(AppRoute.EDIT_NOTE, arguments: i);
  }

  void deleteNote(BuildContext context, int i) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialogWidget(
          headingText: "Are you sure you want to delete this note?",
          contentText:
              "This will delete the note permanently. You cannot undo this action.",
          confirmFunction: () {
            controller.deleteNote(controller.notes[i].id!);
            Get.offAllNamed(AppRoute.HOME);
          },
          declineFunction: () {
            Get.back();
          },
        );
      },
    );
  }
}

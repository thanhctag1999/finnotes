import 'package:finnotes/controllers/note_controller.dart';
import 'package:finnotes/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EditNotePage extends StatefulWidget {
  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final NoteController controller = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int i = ModalRoute.of(context)?.settings.arguments as int;
    controller.titleController.text = controller.notes[i].title!;
    controller.contentController.text = controller.notes[i].content!;
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
          ),
          child: Column(
            children: [
              TextField(
                controller: controller.titleController,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
                cursorColor: Colors.black,
                enableInteractiveSelection: true,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    letterSpacing: 1,
                  ),
                  border: InputBorder.none,
                ),
              ),
              TextField(
                style: const TextStyle(
                  fontSize: 22,
                ),
                cursorColor: Colors.black,
                enableInteractiveSelection: true,
                controller: controller.contentController,
                decoration: InputDecoration(
                  hintText: "Content",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 17,
                  ),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ],
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
            controller.updateNote(
                controller.notes[i].id!, controller.notes[i].dateTimeCreated!);
          },
          icon: const Icon(
            Icons.save,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

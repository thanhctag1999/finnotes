import 'package:finnotes/controllers/note_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finnotes/constants/colors.dart';
import 'package:finnotes/widgets/toast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddNewNotePage extends StatelessWidget {
  final NoteController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    controller.titleController.text = "";
    controller.contentController.text = "";
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
                autofocus: true,
                controller: controller.titleController,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
                cursorColor: Colors.black,
                enableInteractiveSelection:
                    true, // Set to true to enable cursor movement
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: GoogleFonts.poppins(
                    color: AppColor.hintColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                  border: InputBorder.none,
                ),
              ),
              TextField(
                autofocus: true,
                style: const TextStyle(
                  fontSize: 22,
                ),
                controller: controller.contentController,
                decoration: InputDecoration(
                  hintText: "Type note here...",
                  hintStyle: GoogleFonts.poppins(
                    color: AppColor.hintColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                ),
                cursorColor: Colors.black,
                enableInteractiveSelection: true,
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
            if (controller.titleController.text.isEmpty) {
              showToast(message: "Note title is empty");
            } else if (controller.contentController.text.isEmpty) {
              showToast(message: "Note description is empty");
            } else {
              controller.addNoteToDatabase();
            }
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
}

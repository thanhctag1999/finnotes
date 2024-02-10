import 'package:finnotes/widgets/alert_dialog.dart';
import 'package:finnotes/controllers/note_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Todo extends StatefulWidget {
  const Todo(
      {super.key, this.text, this.title, this.date, this.index, this.pin});

  final index;
  final title;
  final text;
  final date;
  final pin;

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final controller = Get.put(NoteController());

  bool status = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 280,
          decoration: BoxDecoration(
              color: Colors.green.shade300,
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Aligns children to the start (left)
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  widget.title,
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  widget.text,
                  textAlign: TextAlign.left,
                  maxLines: 3,
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.date,
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.bodySmall,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        padding: const EdgeInsets.all(10),
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.black),
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: widget.text));
                        },
                        icon: const Icon(
                          Icons.copy_outlined,
                          color: Colors.white,
                        )),
                    IconButton(
                        padding: const EdgeInsets.all(10),
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.black),
                        ),
                        onPressed: () => {},
                        icon: !status
                            ? const Icon(
                                Icons.star_border_outlined,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.star_outlined,
                                color: Colors.amberAccent,
                              )),
                    IconButton(
                        padding: const EdgeInsets.all(10),
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.black),
                        ),
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
                                      controller.notes[widget.index].id!);
                                  Get.back();
                                },
                                declineFunction: () {
                                  Get.back();
                                },
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: Colors.white,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

import 'dart:io';

import 'package:capybara/user_promt_bubble.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class Capybara extends StatefulWidget {
  const Capybara({super.key});
  @override
  State<Capybara> createState() {
    return _CapybaraState();
  }
}

class _CapybaraState extends State<Capybara> {
  List<PromtVarient> promtdata = [];
  final TextEditingController msgController = TextEditingController();
  File? searchImage;
  bool isPromting = false;

  void checkimage() {
    final pickedImage = ImagePicker();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Choose Image from gallery or camera?"),
          actions: [
            ElevatedButton.icon(
              onPressed: () async {
                final image =
                    await pickedImage.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    searchImage = File(image.path);
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Something went wrong while getting image from gallery"),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.image),
              label: const Text("Gallery"),
            ),
            ElevatedButton.icon(
                onPressed: () async {
                  final image =
                      await pickedImage.pickImage(source: ImageSource.camera);

                  if (image != null) {
                    setState(() {
                      searchImage = File(image.path);
                    });
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            "Something went wrong while getting image from camera"),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.camera),
                label: const Text("Camera")),
          ],
        );
      },
    );
  }

  void send() async {
    if (msgController.text.isNotEmpty) {
      final String promt = msgController.text;
      setState(() {
        isPromting = true;
        promtdata.add(PromtVarient(msg: promt, bubble: Bubble.user));
      });

      print(promt);

      ///dont use api key like this
      /// write a secure backend or add it to envirment variable

      const apiKey = "******************************";
      // if (apiKey == null) {
      //   print('No \$API_KEY environment variable');
      //   return;
      // }
      // For text-only input, use the gemini-pro model
      final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

      final content = [
        Content.text(
            "$promt and answer like as a capybara whose name is Alisha and maker name is Som")
      ];
      model.generateContent(content).then((response) {
        if (response.text != null) {
          setState(() {
            isPromting = false;
            promtdata.add(
              PromtVarient(
                msg: response.text!,
                bubble: Bubble.gemini,
              ),
            );
          });
        }
      }).onError((error, stackTrace) {
        setState(() {
          isPromting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Something went wrong with api")));
      });

      msgController.clear();
      Focus.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Center(
            child: Text("Capybara"),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: ListView.builder(
                itemCount: promtdata.length,
                itemBuilder: (context, index) {
                  return PromtBubble(
                    msg: promtdata[index].msg,
                    bubble: promtdata[index].bubble,
                  );
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          controller: msgController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                              hintText: "Enter some promt",
                              hintStyle: TextStyle(
                                color: Color.fromARGB(194, 255, 255, 255),
                              )),
                        ),
                      ),
                      isPromting == false
                          ? IconButton(
                              onPressed: send,
                              icon: const Icon(
                                Icons.send,
                                color: Colors.pink,
                              ),
                            )
                          : const SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(
                                color: Colors.pink,
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

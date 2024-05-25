import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leaf_lens/controllers/gemini_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'species_list_page.dart';

class VisionPage extends StatefulWidget {
  const VisionPage({Key? key}) : super(key: key);

  @override
  State<VisionPage> createState() => _VisionPageState();
}

class _VisionPageState extends State<VisionPage> {
  List<CoolDropdownItem<String>> dropdownItemList = [];
  List<String> models = ['Plants', 'Animal'];
  String? _selectedModel = 'Animal';
  XFile? image;
  GeminiChatController controller = Get.find();
  TextEditingController textController = TextEditingController();
  bool isIdentified = false;

  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final img = await picker.pickImage(source: source);
      setState(() {
        image = img;
        isIdentified = false;
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> saveSpeciesData(String prompt, XFile image) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
    final imageFile = File(image.path);
    await imageFile.copy(imagePath);

    final prefs = await SharedPreferences.getInstance();
    final speciesList = prefs.getStringList('species_list') ?? [];
    speciesList.add('$prompt|$imagePath');
    await prefs.setStringList('species_list', speciesList);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      height: 812.h,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20, top: 20),
              width: 300.w,
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.w),
                color: Colors.black, // Setting a black background color
              ),
              child: Center(
                child: Row(
                  children: [
                    Text('Select Model', style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)), // Changed text here
                    Container(
                      width: 100.w, // Adjust width as needed
                      child: PopupMenuButton<String>(
                        color: Colors.white, // Set dropdown menu background color
                        elevation: 8, // Add elevation for better visibility
                        onSelected: (value) {
                          setState(() {
                            _selectedModel = value;
                          });
                        },
                        itemBuilder: (BuildContext context) {
                          return models.map((String model) {
                            return PopupMenuItem<String>(
                              value: model,
                              child: Text(
                                model,
                                style: TextStyle(color: Colors.black), // Text color of menu items
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50.h,),
            Container(
              width: 200.w,
              height: 300.w,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 0, 0),
                borderRadius: BorderRadius.circular(15.w),
              ),
              child: image != null
                  ? ClipRRect(
                child: Image(image: FileImage(File(image!.path)), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(10.w),
              )
                  : ClipRRect(
                child: Image(image: AssetImage('assets/imgsearch.png')),
                borderRadius: BorderRadius.circular(50.w),
              ),
            ),
            SizedBox(height: 150.h,),
            Obx(() {
              if (controller.isLoading.value) {
                return LoadingAnimationWidget.staggeredDotsWave(color: Colors.blueAccent, size: 50);
              } else {
                return Container(
                    width: 300.w,
                    height: 70.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.w),
                        color: const Color.fromARGB(255, 34, 34, 34),
                        boxShadow: [BoxShadow(blurRadius: 1, spreadRadius: 1, offset: Offset(1, 2))]
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Select Image Source'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        pickImage(ImageSource.camera);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Camera'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        pickImage(ImageSource.gallery);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Gallery'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.image, color: Colors.blueAccent),
                        ),
                        IconButton(
                          onPressed: () {
                            if (image != null) {
                              controller.geminiVisionResponse(textController.text, image!, _selectedModel);
                              setState(() {
                                isIdentified = true;
                              });
                            } else {
                              Get.snackbar(
                                  'Error', 'Image cannot be empty!',
                                  backgroundColor: Colors.amberAccent,
                                  titleText: Text('Invalid Input', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                              );
                            }
                          },
                          icon: Icon(Icons.send),
                          color: Colors.greenAccent,
                        ),
                      ],
                    )
                );
              }
            }),
            Obx(() {
              if (controller.isLoading.value) {
                return Container();
              } else {
                return Container(
                  padding: EdgeInsets.all(8.w),
                  width: 300.w,
                  child: Text(
                    controller.streamAnswer.toString(),
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                );
              }
            }),
            if (isIdentified)
              ElevatedButton(
                onPressed: () async {
                  await saveSpeciesData(controller.streamAnswer.toString(), image!);
                  Get.snackbar(
                      'Success', 'Species saved successfully!',
                      backgroundColor: Colors.greenAccent,
                      titleText: Text('Saved', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                  );
                },
                child: Text('Save Species'),
              ),
            ElevatedButton(
              onPressed: () {
                Get.to(SpeciesListPage());
              },
              child: Text('View Saved Species'),
            ),
          ],
        ),
      ),
    );
  }
}

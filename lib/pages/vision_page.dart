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
  List<String> models = ['Plant🪴', 'Animal🐮'];
  String? _selectedModel = 'Animal🐮';
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.w),
                color: Colors.green[100],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$_selectedModel',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PopupMenuButton<String>(
                    color: Colors.white,
                    elevation: 8,
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
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 50.h),
                    Container(
                      width: 300.w,
                      height: 300.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15.w),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: image != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(15.w),
                        child: Image.file(
                          File(image!.path),
                          fit: BoxFit.cover,
                        ),
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(15.w),
                        child: Image.asset('assets/imgsearch.png'),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.green,
                          size: 50,
                        );
                      } else {
                        return Container(
                          padding: EdgeInsets.all(16.w),
                          width: 300.w,
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(15.w),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            controller.streamAnswer.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                    }),
                    if (isIdentified)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: ElevatedButton(
                          onPressed: () async {
                            await saveSpeciesData(
                                controller.streamAnswer.toString(), image!);
                            Get.snackbar(
                              'Success',
                              'Species saved successfully!',
                              backgroundColor: Colors.green,
                              titleText: Text(
                                'Saved',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            // primary: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 24.0,
                            ),
                          ),
                          child: Text(
                            'Save Species',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    icon: Icon(Icons.add_a_photo_rounded, color: Colors.green, size: 30),
                  ),
                  IconButton(
                    onPressed: () {
                      if (image != null) {
                        controller.geminiVisionResponse(
                            textController.text, image!, _selectedModel);
                        setState(() {
                          isIdentified = true;
                        });
                      } else {
                        Get.snackbar(
                          'Error',
                          'Image cannot be empty!',
                          backgroundColor: Colors.amberAccent,
                          titleText: Text(
                            'Invalid Input',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.send, color: Colors.green, size: 30),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h)
          ],
        ),
      ),
    );
  }
}

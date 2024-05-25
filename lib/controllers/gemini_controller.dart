
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GeminiChatController extends GetxController{
  final gemini=Gemini.instance;
  RxString streamAnswer=''.obs;
  RxList<String> outputs=<String>[].obs;
  RxBool isLoading=false.obs;
  RxBool isGenerating=false.obs;


    void geminiVisionResponse(String text,XFile file,String? model)async{
      try{
        isLoading.value=true;
        streamAnswer.value='';
        String quary;

        if (model=='Free'){
          quary=text;
        }else{
          quary='Can you please fill the following information in the given format regarding the $model in the image, Name :   , Species :    , Habitat :    , Interesting Trait :    ,and also please rate the species on the basis of rarity in 1 to 10 where 10 is very rare. And please leave a space of 2 lines between each parameter';

        }
        //final ByteData data = await rootBundle.load('assets/leaf.png');
        final File data = File(file.path);
        final Uint8List bytes=data.readAsBytesSync();
          print(bytes);
        await gemini.textAndImage(text: quary, images: [bytes]).then((value){
          streamAnswer.value=value!.content!.parts!.last.text.toString();
        });
        isLoading.value=false;
        print(streamAnswer);
      }catch(error){
        streamAnswer.value='SOMETHING WENT WRONG TRY AGAIN WITH A DIFFERENT IMAGE';
        print(error);
                isLoading.value=false;

      }
    }




  void geminiStream(String text,VoidCallback scrollToBottom)async{
    try{
      isLoading.value=true;
      isGenerating.value=true;
      outputs.clear();

      await gemini.streamGenerateContent(text).forEach((event) {
        streamAnswer.value=event.output.toString();
        outputs.add(streamAnswer.value);
        isLoading.value=false;
        
      });
      scrollToBottom();
      isGenerating.value=false;
      isLoading.value=false;
    }catch(error){
      streamAnswer.value=error.toString();
      isLoading.value=false;
    }
  }

  
}
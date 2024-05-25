import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leaf_lens/controllers/gemini_controller.dart';
import 'package:get/get.dart';
import 'package:leaf_lens/pages/chat_page.dart';
import 'package:leaf_lens/pages/vision_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

int item=1;
GeminiChatController geminiChatController=Get.find();
void handleClick(int newItem){
    
    setState(() {
      item=newItem;
      geminiChatController.streamAnswer.value="";
    }
    );
      
}

PageController controller=PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(children: [Image(image: AssetImage('assets/leaf.png'),width: 40.w,),SizedBox(width: 10.w,), Text('Bio Bounty',style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold),)],),
        actions:<Widget>[
          PopupMenuButton<int>(
            onSelected: (item)=>handleClick(item),
            itemBuilder:(BuildContext context)=>[
              PopupMenuItem<int>(value: 1, child: Text('Chat')),
              PopupMenuItem(child: Text('Vision'),value: 2,)
            ]
           )
        ],
      ),

      body:
          
          _page(item)
      
    
    );
  }

  Widget _page(index){
    switch(index){
      case 1:
        return ChatPage();
      case 2:
        return VisionPage();
      default:
      return VisionPage();
          
    }
    
  }

}
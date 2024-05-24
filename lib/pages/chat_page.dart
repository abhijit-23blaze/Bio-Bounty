import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leaf_lens/controllers/gemini_controller.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

GeminiChatController chatController=Get.find();
TextEditingController inputController=TextEditingController();
ScrollController _scrollController=ScrollController();

void _scrollToBottom(){
  _scrollController.animateTo(
    _scrollController.position.extentTotal,
    duration: Duration(milliseconds: 300),
    curve: Curves.easeOut,
  );
}

void handleClick(int item){
  switch (item){
    case 0:
      break;
    case 1:
      break;  
  }
}

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 640.h,
              width: 375.w,
              child: Obx((){

                          if(chatController.isLoading.value){
                            return Center(child: Container(
                              width: 200.w,
                              height: 200.w,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/Animation.gif'),fit: BoxFit.cover
                                  )
                                  ),
                            ));
                          }
                          else if(chatController.outputs.isEmpty){
                              return Center(
                                child: Column(
                                  children: [
                                    Container(
                                    height: 250.w,
                                    width: 250.w,
                                    
                                    child: Image(image: AssetImage('assets/robot.png'),fit: BoxFit.cover,),
                                  ),
                                    Container(
                                      width: 300.w,
                                      //height: 200.h,
                                      //color: Colors.amber,
                                      child: Column(
                                        children: [
                                          suggestContainer('Explore the Mystique of Black Panthers',Colors.purpleAccent),
                                          suggestContainer('Craft an Engaging YouTube Script about Elephants',Colors.orangeAccent),
                                          suggestContainer('Unravel the Secrets of Enchanted Caves',Colors.greenAccent),
                                          suggestContainer('A Symphony of Birds: Morning Serenade',Colors.blueAccent)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                          }
                          else{
                            return outPuts();
                          }
                        }),
              
            ),
            
                   
                
            Container(
                margin: EdgeInsets.only(top: 20.h,bottom: 5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.w),
                  color: Color.fromARGB(255, 26, 25, 25),
                ),
                width: 350.w,
                height: 60.h,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                          child: Obx((){
                            if(chatController.isGenerating.value){
                              return LoadingAnimationWidget.staggeredDotsWave(color: Colors.blueAccent, size: 40.h);
                            }else{
                              return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 280.w,
                                height: 60.h,
                                child: TextField(
                                  style: TextStyle(
                                    overflow: TextOverflow.fade,
                                    
                                  
                                    color: Color.fromARGB(255, 196, 195, 195)
                                  ),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.w),
                                      borderSide: BorderSide(color: Colors.transparent)
                                      
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.w),
                                      borderSide: BorderSide(color: Colors.transparent)
                                      
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.w),
                                      borderSide: BorderSide(color: Colors.transparent)
                                      
                                    ),
                                    
                                    hintText: 'Ask anything here',
                                    hintStyle: TextStyle(
                                      
                                      color: Colors.white38
                                    )
                                  ),
                                                      controller: inputController,
                                                    ),
                              ),
                          IconButton(onPressed: (){
                            chatController.geminiStream(inputController.text,(){_scrollToBottom();});
                            inputController.text='';
                          },icon: Icon(Icons.send,color: Colors.blueAccent,),)
                            ],
                          );
                            }
                          })
                        ),
                ),
              ),
            
          ],
        ),
      
    
    );
  }

  Widget outPuts(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: chatController.outputs.length,
        itemBuilder: (
    
        BuildContext context,index){
          return Container(
            
           // margin: EdgeInsets.only(bottom: 10.h),
            width: 250.w,

            decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(10.w),
              //color: Colors.amberAccent  
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(chatController.outputs[index],style: TextStyle(color: Colors.grey),),
            ),
          );
      }),
    );
  }

  Widget suggestContainer(String text,Color color){
    return GestureDetector(
      onTap: () {
        chatController.geminiStream(text,(){_scrollToBottom();});
      },
      child: Container(
        margin: EdgeInsets.only(top: 10.h),
                              width: 250.w,
                              
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [color,Colors.amberAccent]),
                                borderRadius: BorderRadius.circular(15.w),
                                boxShadow: [BoxShadow(
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                  offset: Offset(1, 2)
                                )]
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(text,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),),
                                ),
                              ),
                            ),
    );
  }
}
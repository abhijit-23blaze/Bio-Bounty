import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leaf_lens/controllers/gemini_controller.dart';
import 'package:get/get.dart';
import 'package:leaf_lens/pages/chat_page.dart';
import 'package:leaf_lens/pages/species_list_page.dart';
import 'package:leaf_lens/pages/vision_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  GeminiChatController geminiChatController = Get.find();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      geminiChatController.streamAnswer.value = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: Row(
          children: [
            Image(
              image: AssetImage('assets/leaf.png'),
              width: 40,
            ),
            SizedBox(width: 10),
            Text(
              'Bio Bounty',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      title: Text("BioBounty is a collaborative project made by\nRitovan Dasgupta\nAbhijit Patil\nNaman Goyal"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Love it!",
                            style: TextStyle(color: Colors.green)),

                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: _page(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green[200],
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.green,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _page(int index) {
    switch (index) {
      case 0:
        return VisionPage();
      case 1:
        return LeaderboardPage();
      case 2:
        return SpeciesListPage();
      default:
        return VisionPage();
    }
  }
}

class DefaultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Default Page'),
    );
  }
}

class LeaderboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Leaderboard Page'),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Page'),
    );
  }
}
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
        backgroundColor: Colors.green[300],
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
        backgroundColor: Colors.green[300],
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.black,
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








class LeaderboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [Color(0xFF91EAE4), Color(0xFF86A8E7)],
          // ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              '🏁Leaderboard🏁',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 20),
            _buildLeaderboardItem(1, 'Abhijit', 500, 'assets/john_doe.jpg', gradientColors: [Color(0xFFFFAFBD), Color(0xFFC9FFBF)]),
            _buildLeaderboardItem(2, 'Ritovan', 450, 'assets/jane_smith.jpg', gradientColors: [Color(0xFF74EBD5), Color(0xFFACB6E5)]),
            _buildLeaderboardItem(3, 'Naman', 400, 'assets/alice_johnson.jpg', gradientColors: [Color(0xFFFFE3E3), Color(0xFFDBE7FC)]),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardItem(int rank, String username, int score, String photoPath, {List<Color>? gradientColors}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: gradientColors ?? [Color(0xFF74EBD5), Color(0xFFACB6E5)],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(photoPath),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rank $rank',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      '$username',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              'Bio Points: $score',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

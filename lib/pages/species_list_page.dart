import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpeciesListPage extends StatefulWidget {
  @override
  _SpeciesListPageState createState() => _SpeciesListPageState();
}

class _SpeciesListPageState extends State<SpeciesListPage> {
  List<Map<String, String>> speciesList = [];

  @override
  void initState() {
    super.initState();
    loadSpeciesData();
  }

  Future<void> loadSpeciesData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('species_list') ?? [];
    final List<Map<String, String>> loadedList = [];

    for (var item in savedList) {
      final splitItem = item.split('|');
      loadedList.add({'prompt': splitItem[0], 'imagePath': splitItem[1]});
    }

    setState(() {
      speciesList = loadedList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/profile_picture.png'),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Abhijit Patil',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Skill Level 1',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  LinearProgressIndicator(
                    value: 0.7,
                    backgroundColor: Colors.grey[300],
                    minHeight: 10,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  SizedBox(height: 16.0),
                  Divider(thickness: 2, color: Colors.white),
                  SizedBox(height: 16.0),
                  Text(
                    'Discovered Species: ${speciesList.length}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            // Species list items divided into two groups
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: speciesList
                        .sublist(0, (speciesList.length / 2).ceil())
                        .map((species) {
                      final imagePath = species['imagePath']!;
                      final prompt = species['prompt']!;
                      return _buildSpeciesCard(imagePath, prompt);
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: speciesList
                        .sublist((speciesList.length / 2).ceil())
                        .map((species) {
                      final imagePath = species['imagePath']!;
                      final prompt = species['prompt']!;
                      return _buildSpeciesCard(imagePath, prompt);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeciesCard(String imagePath, String prompt) {
    return Card(
      color: Colors.lightGreen[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
                height: 120,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              prompt,
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}

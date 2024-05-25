import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
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
      appBar: AppBar(
        title: Text('Saved Species'),
      ),
      body: ListView.builder(
        itemCount: speciesList.length,
        itemBuilder: (context, index) {
          final species = speciesList[index];
          final imagePath = species['imagePath']!;
          final prompt = species['prompt']!;

          return ListTile(
            leading: Image.file(File(imagePath)),
            title: Text(prompt),
          );
        },
      ),
    );
  }
}

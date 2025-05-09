import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_detection_protein/Services/api_ninja_service.dart'; //API

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: MyApp(),
));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? _image;
  bool _loading = false;
  String _nutritionInfo = ''; // To hold the nutrition info

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Food Recognition",
            style: TextStyle(fontSize: 19),
          ),
        ),
        backgroundColor: Colors.grey.shade800,
      ),
      body: _loading
          ? const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.red,
        ),
      )
          : SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              _image == null
                  ? MyAlert()
                  : CircleAvatar(
                radius: 75,
                backgroundImage: FileImage(_image!),
              ),
              const SizedBox(height: 20),
              // Display nutritional info after picking an image
              if (_nutritionInfo.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _nutritionInfo,
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        backgroundColor: Colors.amber.shade700,
        child: const Icon(Icons.fastfood_rounded),
      ),
    );
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final image = File(pickedFile.path);

    setState(() {
      _loading = true;
      _image = image;
    });

    // Send the food name from classification or manually entered
    fetchNutritionInfo("Food Name"); // Use actual name from classification here
  }

  // Function to fetch nutrition info based on the food name
  Future<void> fetchNutritionInfo(String foodName) async {
    try {
      final foodInfo = await ApiNinjaService.getFoodInfo(foodName);
      setState(() {
        // Format the nutrition information
        _nutritionInfo = "Calories: ${foodInfo['calories']}\n"
            "Protein: ${foodInfo['protein_g']}g\n"
            "Fat: ${foodInfo['fat_g']}g\n"
            "Carbs: ${foodInfo['carbohydrates_g']}g\n"
            "Serving Size: ${foodInfo['serving_size_g']}g";
      });
    } catch (e) {
      setState(() {
        _nutritionInfo = "Nutrition info could not be fetched.";
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class MyAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          padding: const EdgeInsets.all(12.0),
        ),
        onPressed: () => showAlertDialog(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
            ),
            SizedBox(height: 8),
            Text(
              "Press if you don't know what to do",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Info"),
        content: SingleChildScrollView(
          child: Column(
            children: const [
              Text(
                "This app allows you to upload an image of food. It will show its nutritional information such as calories, protein, fat, carbs, and serving size.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "Instructions:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("1. Press the 'camera' icon to pick an image of food."),
              Text("2. Wait for the nutritional information."),
              Text("3. View the results."),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}

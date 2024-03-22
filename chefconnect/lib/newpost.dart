import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cooking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewPostPage(),
    );
  }
}

class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  TextEditingController _recipeTitleController = TextEditingController();
  TextEditingController _ingredientsController = TextEditingController();
  TextEditingController _instructionsController = TextEditingController();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 244, 206, 54),
       title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          
            Text('New post'),
            
            IconButton(
              icon: Icon(Icons.post_add_outlined),
              onPressed: () {
                // Add logic to edit profile
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              '../assets/ch.jpg', // Assurez-vous que le chemin d'accès est correct
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _recipeTitleController,
              decoration: InputDecoration(
                labelText: 'Recipe Title',
                prefixIcon: Icon(Icons.restaurant_menu),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _ingredientsController,
              decoration: InputDecoration(
                labelText: 'Ingredients',
                prefixIcon: Icon(Icons.shopping_basket),
              ),
              maxLines: null, // Allow multiple lines
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _instructionsController,
              decoration: InputDecoration(
                labelText: 'Instructions',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: null, // Allow multiple lines
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                // Save the post logic goes here
                String title = _recipeTitleController.text;
                String ingredients = _ingredientsController.text;
                String instructions = _instructionsController.text;

                // Perform validation if needed
                // Save the post to database or perform other actions

                // Reset controllers
                _recipeTitleController.clear();
                _ingredientsController.clear();
                _instructionsController.clear();

                // Show a confirmation dialog or navigate to another screen
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Post Created'),
                      content: Text('Your recipe "$title" has been posted!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.post_add),
              label: Text('Post Recipe'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                // Afficher la boîte de dialogue pour sélectionner une image
                _showImageSourceSelectionDialog();
              },
              icon: Icon(Icons.add_a_photo),
              label: Text('Add Image'),
            ),
            SizedBox(height: 16.0),
            if (_image != null)
              Image.file(
                File(_image!.path),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showImageSourceSelectionDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }
}

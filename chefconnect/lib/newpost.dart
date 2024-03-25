import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';






class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final TextEditingController _recipeTitleController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 244, 206, 54),
       title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          
            const Text('New post'),
            
            IconButton(
              icon: const Icon(Icons.post_add_outlined),
              onPressed: () {
                // Add logic to edit profile
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/1.png', // Assurez-vous que le chemin d'accès est correct
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _recipeTitleController,
              decoration: const InputDecoration(
                labelText: 'Recipe Title',
                prefixIcon: Icon(Icons.restaurant_menu),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _ingredientsController,
              decoration: const InputDecoration(
                labelText: 'Ingredients',
                prefixIcon: Icon(Icons.shopping_basket),
              ),
              maxLines: null, // Allow multiple lines
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _instructionsController,
              decoration: const InputDecoration(
                labelText: 'Instructions',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: null, // Allow multiple lines
            ),
            const SizedBox(height: 16.0),
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
                      title: const Text('Post Created'),
                      content: Text('Your recipe "$title" has been posted!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.post_add),
              label: const Text('Post Recipe'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                // Afficher la boîte de dialogue pour sélectionner une image
                _showImageSourceSelectionDialog();
              },
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Add Image'),
            ),
            const SizedBox(height: 16.0),
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
          title: const Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
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

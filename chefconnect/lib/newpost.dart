import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final TextEditingController _recipeTitleController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 244, 206, 54),
        title: const Text('New post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_image != null)
              Image.file(
                File(_image!.path),
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
              maxLines: null,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _instructionsController,
              decoration: const InputDecoration(
                labelText: 'Instructions',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
                prefixIcon: Icon(Icons.image),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: _showImageSourceSelectionDialog,
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Add Image'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _postRecipe,
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showImageSourceSelectionDialog() async {
    final source = await showDialog<ImageSource>(
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
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (source != null) {
      _pickImage(source);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Future<void> _postRecipe() async {
    final title = _recipeTitleController.text;
    final ingredients = _ingredientsController.text;
    final instructions = _instructionsController.text;
    final imageUrl = _imageUrlController.text;

    if (title.isEmpty || ingredients.isEmpty || instructions.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill in all fields'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      final postRef = await FirebaseFirestore.instance.collection('posts').add({
        'title': title,
        'ingredients': ingredients,
        'instructions': instructions,
        'imageUrl': imageUrl,
      });

      print('Recipe posted successfully. Document ID: ${postRef.id}');

      if (_image != null) {
        await _uploadImageToFirebaseStorage(postRef.id);
      }

      _recipeTitleController.clear();
      _ingredientsController.clear();
      _instructionsController.clear();
      _imageUrlController.clear();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Post Created'),
            content: Text('Your recipe "$title" has been posted!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Error posting recipe: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to post recipe: $error'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _uploadImageToFirebaseStorage(String documentId) async {
    final storageReference = FirebaseStorage.instance.ref().child('images/$documentId.png');
    final uploadTask = storageReference.putFile(File(_image!.path));
    await uploadTask.whenComplete(() => print('Image uploaded'));
  }
}

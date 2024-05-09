import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

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
            Container(
              height: 200.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('../../assets/1.png'), // Ajout de l'image
                  fit: BoxFit.cover,
                ),
              ),
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
            SizedBox(height: 20.0), // Ajustement de l'espacement
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                readOnly: true,
                controller: _imageUrlController,
                onTap: () async {
                  final pickedImage = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedImage != null) {
                    setState(() {
                      _imageUrlController.text = pickedImage.path;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Recipe image',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintText: 'Tap to take a picture',
                  filled: true,
                  fillColor: _imageUrlController.text.isEmpty
                      ? Colors.white.withOpacity(0.13)
                      : Color.fromARGB(255, 55, 201, 29).withOpacity(0.13),
                  prefixIcon: Icon(Icons.camera_alt, color: Colors.black),
                  hintStyle: TextStyle(color: Colors.black),
                ),
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: _postRecipe,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.green],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _postRecipe() async {
    final title = _recipeTitleController.text;
    final ingredients = _ingredientsController.text;
    final instructions = _instructionsController.text;
    final imageUrl = _imageUrlController.text;

    if (title.isEmpty || ingredients.isEmpty || instructions.isEmpty || imageUrl.isEmpty) {
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

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('User not authenticated'),
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
      final authorImageUrl = await _getAuthorImageUrl(user.email!);

      final postRef = await FirebaseFirestore.instance.collection('posts').add({
        'title': title,
        'ingredients': ingredients,
        'instructions': instructions,
        'imageUrl': imageUrl,
        'authorImageUrl': authorImageUrl,
        'email': user.email,
      });

      print('Recipe posted successfully. Document ID: ${postRef.id}');

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

  Future<String> _getAuthorImageUrl(String email) async {
    final registrationSnapshot = await FirebaseFirestore.instance.collection('registration').doc(email).get();
    final data = registrationSnapshot.data();
  
    if (registrationSnapshot.exists && data?['imageUrl'] != null) {
      return data!['imageUrl'];
    } else {
      return ''; // Retourne une chaîne vide si l'URL de l'image n'est pas trouvée
    }
  }
}

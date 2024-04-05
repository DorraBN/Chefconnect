import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
                labelText: 'Recipe Image URL',
                prefixIcon: Icon(Icons.image),
              ),
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

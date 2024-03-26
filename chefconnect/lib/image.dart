import 'dart:io' show File;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart'; // Importer la page de connexion

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final picker = ImagePicker();
  late String _imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
              _buildImageWidget(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Enregistrer l'image dans Firebase Storage et la référence dans Firestore
                if (_image != null) {
                  _uploadImageToFirebaseStorage();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select an image first')),
                  );
                }
              },
              child: Text('Save Image'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        backgroundColor: Colors.green, // Couleur du bouton
        child: Icon(Icons.arrow_forward), // Icône du bouton
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Position du bouton
    );
  }

  Widget _buildImageWidget() {
    if (kIsWeb) {
      return Image.network(
        _image!.path,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        _image!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
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
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImageToFirebaseStorage() async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('profile_pictures/${DateTime.now()}.png');
    UploadTask uploadTask = storageReference.putFile(_image!);
    await uploadTask.whenComplete(() => print('Image uploaded'));
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _imageUrl = fileURL;
        // Enregistrer l'URL de l'image dans Firestore
        _saveImageUrlToFirestore();
      });
    });
  }

  Future<void> _saveImageUrlToFirestore() async {
    // Ajouter le document avec un ID généré automatiquement par Firestore
    await FirebaseFirestore.instance.collection('registration').add({
      'image_url': _imageUrl,
    }).then((value) {
      print('Document ID: ${value.id}');
    }).catchError((error) {
      print('Failed to add document: $error');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image saved to Firestore')),
    );
  }
}

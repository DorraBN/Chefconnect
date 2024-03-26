import 'package:flutter/material.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Color.fromARGB(255, 244, 206, 54),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          
            Text('Edit Profile'),
            
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Add logic to edit profile
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.black, // Colorer l'image en noir
                  backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150'), // Replace with user's profile image
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add logic to change profile image here
                      // For example, you can open an image picker dialog
                      // and update the image accordingly
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text('make a photo'),
                  ),
                  SizedBox(width: 16.0),
                  Icon(Icons.photo_library, color: Colors.black), // Ajout de l'icône d'édition
                  Text('see gallery', style: TextStyle(color: Colors.blue)), // Ajout du texte "Edit Profile"
                ],
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person,color: Colors.black), // Ajout de l'icône de personne
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email,color: Colors.black), // Ajout de l'icône d'email
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone,color: Colors.black), // Ajout de l'icône de téléphone
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _bioController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  prefixIcon: Icon(Icons.description,color: Colors.black), // Ajout de l'icône de description
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                // Centrer le bouton
                child: ElevatedButton(
                  onPressed: () {
                    // Add logic to update profile here
                    String fullName = _fullNameController.text;
                    String email = _emailController.text;
                    String bio = _bioController.text;

                    // Perform actions to update the profile
                    // For example, you can send data to an API or update local storage

                    // Show a snackbar to indicate success
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Profile updated successfully'),
                      ),
                    );
                  },
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Couleur verte
                    minimumSize: Size(200, 50), // Taille du bouton plus large
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfileEditPage(),
  ));
}

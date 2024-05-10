import 'package:flutter/material.dart';

import 'package:chefconnect/profile.dart';
// Importez la page ProfilePage2

class HeroListPage extends StatelessWidget {
  const HeroListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 244, 206, 54),
       title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          
            Text('Friends'),
            
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                // Add logic to edit profile
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: ListView.builder(
            itemCount: _images.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfilePage2())); // Rediriger vers ProfilePage2
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 50, // Ajustez selon vos besoins
                        backgroundImage: NetworkImage(_images[index]),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _names[index], // Utilisez le nom de la personne à partir de la liste _names
                                    style: Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    height: 50, // Hauteur augmentée du bouton
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Handle Follow
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                      ),
                                      child: Text('Friend'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

final List<String> _images = [
  'https://thumbs.dreamstime.com/b/verticale-de-femme-de-chef-dans-la-cuisine-23037212.jpg',
  'https://th.bing.com/th/id/OIP.OqgcKqx97M8vVbuX1ZmjDQHaHW?rs=1&pid=ImgDetMain'
  '../../assets/justin.png'
];

final List<String> _names = [
  'jane austen',
  'mark doe',
  'justin jill',
  
];

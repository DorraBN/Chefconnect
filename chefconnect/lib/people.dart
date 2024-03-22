import 'package:flutter/material.dart';
import 'package:chefconnect/myprofile.dart';
import 'package:chefconnect/profile.dart';
import 'package:chefconnect/profile1.dart'; // Importez la page ProfilePage2

class HeroListPage extends StatelessWidget {
  const HeroListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 244, 206, 54),
       title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          
            Text('People'),
            
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
                                      child: Text('Follow'),
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
  'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
  'https://th.bing.com/th/id/OIP.FkjJIndgbxyQfVJTRbwJ6wHaHa?rs=1&pid=ImgDetMain',
  'https://th.bing.com/th/id/OIP.OIFJfeW8fJlpCXuaQubTgwAAAA?w=440&h=661&rs=1&pid=ImgDetMain',
  'https://th.bing.com/th/id/OIP.32f9nJbOSCIrZ1r8d_uuDwHaJ4?rs=1&pid=ImgDetMain',
  'https://th.bing.com/th/id/OIP.68Vh73rymoLkudcERv9EJgHaIE?rs=1&pid=ImgDetMain',
];

final List<String> _names = [
  'Jill Doe',
  'Jane Doe',
  'Alice Smith',
  'Bob Johnson',
  'Emily Brown',
];

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() {
    String message = messageController.text.trim();
    if (message.isNotEmpty) {
      FirebaseFirestore.instance.collection('chat').add({
        'text': message,
        'timestamp': DateTime.now(),
        'senderId': 'user_id', // Remplacez 'user_id' par l'ID de l'utilisateur authentifié
      });
      messageController.clear(); // Effacer le champ de texte après l'envoi du message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Padding(
        padding: EdgeInsets.only(left: 14.0, right: 14),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: Image.asset('../../assets/chat111.png').image,
                  ),
                  const SizedBox(width: 15,),
                  const Text(
                    'Danny Hopkins',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Quicksand',
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.search_rounded,
                    color: Colors.white70,
                    size: 40,
                  )
                ],
              ),
              SizedBox(height: 30,),
              // Utilisez un StreamBuilder pour afficher les messages en temps réel
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('chat').orderBy('timestamp', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Erreur: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    // Affichez les messages à partir de Firestore
                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot message = snapshot.data!.docs[index];
                        DateTime timestamp = message['timestamp'].toDate();
                        String formattedTime = DateFormat.Hm().format(timestamp);
                        bool isMyMessage = message['senderId'] == 'user_id'; // Votre logique pour déterminer si le message est à vous

                        return Row(
                          mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 4.0),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: isMyMessage ? Colors.red : Colors.blue, // Fond rouge pour vos messages, bleu pour les autres
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    message['text'],
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.right,
                                  ),
                                  Text(
                                    formattedTime,
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color(0xff3D4354),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height:40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white30,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(Icons.camera_alt_outlined),
                        ),
                      ),
                      SizedBox(width: 15,),
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Message',
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: sendMessage,
                        icon: Icon(Icons.send, color: Colors.white54),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

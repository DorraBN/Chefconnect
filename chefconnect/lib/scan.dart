// Importation des paquets nécessaires
import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Fonction pour analyser l'image et obtenir l'ingrédient
Future<String> detectIngredient(FirebaseVisionImage visionImage) async {
  final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
  final List<ImageLabel> labels = await labeler.processImage(visionImage);
  String ingredient = "";
  for (ImageLabel label in labels) {
    if (label.confidence! > 0.75) { // Filtre de confiance
      ingredient = label.text!;
      break;
    }
  }
  await labeler.close();
  return ingredient;
}

// Fonction pour récupérer les informations sur l'ingrédient depuis Firestore
Future<Object?> getIngredientInfo(String ingredientName) async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('ingredients')
      .doc(ingredientName)
      .get();
  return snapshot.data();
}

// Utilisation dans votre code Flutter
void main() {
  // Capture de l'image depuis la caméra
  File imageFile;
  FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);

  // Analyse de l'image pour obtenir l'ingrédient
  detectIngredient(visionImage).then((ingredient) {
    if (ingredient.isNotEmpty) {
      // Récupération des informations sur l'ingrédient depuis Firestore
      getIngredientInfo(ingredient).then((info) {
        print(info);
        // Affichage des informations à l'utilisateur
      }).catchError((error) {
        // Gestion des erreurs lors de la récupération des informations
      });
    } else {
      // Gestion des cas où aucun ingrédient n'est trouvé
    }
  }).catchError((error) {
    // Gestion des erreurs lors de la reconnaissance d'objet
  });
}

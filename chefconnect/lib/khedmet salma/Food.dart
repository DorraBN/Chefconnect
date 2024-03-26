class Food {
  String name;
  String image;
  double cal;
  double time;
  double rate;
  int reviews;
  bool isLiked;
  Map<String, String> intolerances; // Add intolerances field
  String description;
  Map<String, String> ingredients;

  Food({
    required this.name,
    required this.image,
    required this.cal,
    required this.time,
    required this.rate,
    required this.reviews,
    required this.isLiked,
    required this.intolerances,
    required this.description,
    required this.ingredients,
  });
}

class FoodList {
  static final List<Food> foods = [
    Food(
      name: "Spicy Ramen Noodles",
      image: "../../assets/spicyramen.jpg",
      cal: 120,
      time: 15,
      rate: 4.4,
      reviews: 23,
      isLiked: true,
      intolerances: {
        "Gluten": "https://example.com/gluten.jpg",
        "Lactose": "https://example.com/lactose.jpg",
      },
      description:
          "Spicy Ramen is a flavorful and hearty noodle soup that originates from Japan. It's known for its rich broth, chewy noodles, and a variety of toppings.",
      ingredients: {
        "2 cups  olive oil": "../../assets/Rectangle 219.png",
        "4 cups milk": "../../assets/Rectangle 219.png",
        "1 tbsp sugar": "../../assets/Rectangle 219.png",
        "1 tbsp": "../../assets/Rectangle 219.png",
        "1 tsp": "../../assets/Rectangle 219.png",
        "1": "../../assets/Rectangle 219.png",
      },
    ),
    Food(
      name: "Spicy Ramen Noodles",
      image: "../../assets/spicyramen.jpg",
      cal: 120,
      time: 15,
      rate: 4.4,
      reviews: 23,
      isLiked: false,
      intolerances: {
        "Gluten": "https://example.com/gluten.jpg",
        "Lactose": "https://example.com/lactose.jpg",
      },
      description:
          "Spicy Ramen is a flavorful and hearty noodle soup that originates from Japan. It's known for its rich broth, chewy noodles, and a variety of toppings.",
      ingredients: {
        "2 cups  olive oil": "../../assets/Rectangle 219.png",
        "4 cups milk": "../../assets/Rectangle 219.png",
        "1 tbsp sugar": "../../assets/Rectangle 219.png",
        "1 tbsp": "../../assets/Rectangle 219.png",
        "1 tsp": "../../assets/Rectangle 219.png",
        "1": "../../assets/Rectangle 219.png",
      },
    ),
    Food(
      name: "Spicy Ramen Noodles",
      image: "../../assets/spicyramen.jpg",
      cal: 120,
      time: 15,
      rate: 4.4,
      reviews: 23,
      isLiked: false,
      intolerances: {
        "Gluten": "https://example.com/gluten.jpg",
        "Lactose": "https://example.com/lactose.jpg",
      },
      description:
          "Spicy Ramen is a flavorful and hearty noodle soup that originates from Japan. It's known for its rich broth, chewy noodles, and a variety of toppings.",
      ingredients: {
        "2 cups  olive oil": "../../assets/Rectangle 219.png",
        "4 cups milk": "../../assets/Rectangle 219.png",
        "1 tbsp sugar": "../../assets/Rectangle 219.png",
        "1 tbsp": "../../assets/Rectangle 219.png",
        "1 tsp": "../../assets/Rectangle 219.png",
        "1": "../../assets/Rectangle 219.png",
      },
    ),
    Food(
      name: "Spicy Ramen Noodles",
      image: "../../assets/spicyramen.jpg",
      cal: 120,
      time: 15,
      rate: 4.4,
      reviews: 23,
      isLiked: true,
      intolerances: {
        "Gluten": "https://example.com/gluten.jpg",
        "Lactose": "https://example.com/lactose.jpg",
      },
      description:
          "Spicy Ramen is a flavorful and hearty noodle soup that originates from Japan. It's known for its rich broth, chewy noodles, and a variety of toppings.",
      ingredients: {
        "2 cups  olive oil": "../../assets/Rectangle 219.png",
        "4 cups milk": "../../assets/Rectangle 219.png",
        "1 tbsp sugar": "../../assets/Rectangle 219.png",
        "1 tbsp": "../../assets/Rectangle 219.png",
        "1 tsp": "../../assets/Rectangle 219.png",
        "1": "../../assets/Rectangle 219.png",
      },
    ),
    Food(
      name: "Spicy Ramen Noodles",
      image: "../../assets/spicyramen.jpg",
      cal: 120,
      time: 15,
      rate: 4.4,
      reviews: 23,
      isLiked: false,
      intolerances: {
        "Gluten": "https://example.com/gluten.jpg",
        "Lactose": "https://example.com/lactose.jpg",
      },
      description:
          "Spicy Ramen is a flavorful and hearty noodle soup that originates from Japan. It's known for its rich broth, chewy noodles, and a variety of toppings.",
      ingredients: {
        "2 cups  olive oil": "../../assets/Rectangle 219.png",
        "4 cups milk": "../../assets/Rectangle 219.png",
        "1 tbsp sugar": "../../assets/Rectangle 219.png",
        "1 tbsp": "../../assets/Rectangle 219.png",
        "1 tsp": "../../assets/Rectangle 219.png",
        "1": "../../assets/Rectangle 219.png",
      },
    ),
    Food(
      name: "Spicy Ramen Noodles",
      image: "../../assets/spicyramen.jpg",
      cal: 120,
      time: 15,
      rate: 4.4,
      reviews: 23,
      isLiked: false,
      intolerances: {
        "Gluten": "https://example.com/gluten.jpg",
        "Lactose": "https://example.com/lactose.jpg",
      },
      description:
          "Spicy Ramen is a flavorful and hearty noodle soup that originates from Japan. It's known for its rich broth, chewy noodles, and a variety of toppings.",
      ingredients: {
        "2 cups  olive oil": "../../assets/spicyramen.jpg",
        "4 cups milk": "../../assets/Rectangle 219.png",
        "1 tbsp sugar": "../../assets/Rectangle 219.png",
        "1 tbsp": "../../assets/Rectangle 219.png",
        "1 tsp": "../../assets/Rectangle 219.png",
        "1": "../../assets/R.jpeg",
      },
    ),
  ];
}

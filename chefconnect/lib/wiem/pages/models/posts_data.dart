// post_model.dart

class Post {
  final String authorName;
  final String authorImageUrl;
  final String postImageUrl;
  final String caption;
  final int likes;
  final int comments;

  Post({
    required this.authorName,
    required this.authorImageUrl,
    required this.postImageUrl,
    required this.caption,
    required this.likes,
    required this.comments,
  });
}

List<Post> posts = [
    Post(
      authorName: "James Elden",
      authorImageUrl: "assets/james.png",
      postImageUrl: "assets/tunisian.png",
      caption: "Caption for post",
      likes: 123,
      comments: 20,
    ),
    // Add more posts here if needed
    Post(
      authorName: "James Elden",
      authorImageUrl: "assets/james.png",
      postImageUrl: "assets/french.png",
      caption: "Caption for post",
      likes: 123,
      comments: 20,
    ),

    Post(
      authorName: "James Elden",
      authorImageUrl: "assets/james.png",
      postImageUrl: "assets/mexican.png",
      caption: "Caption for post",
      likes: 123,
      comments: 20,
    ),

    Post(
      authorName: "James Elden",
      authorImageUrl: "assets/james.png",
      postImageUrl: "assets/irish.png",
      caption: "Caption for post",
      likes: 123,
      comments: 20,
    ),
  ];
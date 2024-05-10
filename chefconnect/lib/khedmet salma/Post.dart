class Post {
  String username;
  String caption;
  String imageUrl;
  int likes;
  int comments;
  DateTime date;
  String userProfileImageUrl;

  Post({
    required this.username,
    required this.caption,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.date,
    required this.userProfileImageUrl, required authorImageUrl, required email, required ingredients,
  });
}

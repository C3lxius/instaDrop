class Post {
  final String id;
  final String pid;
  final String username;
  final String caption;
  final String pic; //The pic to be posted
  final String dp; //OP's DP
  final List<dynamic> likes;
  final DateTime date;

  const Post(
      {required this.id,
      required this.pid,
      required this.username,
      required this.caption,
      required this.pic,
      required this.dp,
      required this.likes,
      required this.date});

  Map<String, dynamic> toJson() => {
        "id": id,
        "pid": pid,
        "username": username,
        "caption": caption,
        "pic": pic,
        "dp": dp,
        "comments": [],
        "likes": [],
        "date": date,
      };
}

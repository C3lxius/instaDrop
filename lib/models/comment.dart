class Comment {
  final String id;
  final String cid;
  final String username;
  final String comment;
  final String dp; //OP's DP
  final List<dynamic> likes;
  final DateTime date;

  const Comment(
      {required this.id,
      required this.cid,
      required this.username,
      required this.dp,
      required this.comment,
      required this.likes,
      required this.date});

  Map<String, dynamic> toJson() => {
        "id": id,
        "cid": cid,
        "username": username,
        "dp": dp,
        "comment": comment,
        "likes": [],
        "date": date,
      };
}

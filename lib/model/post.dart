class Post {
  final String name;
  final String title;
  final String selftext;
  final String url;
  final String type;

  Post({required this.name, required this.title, required this.selftext, required this.url, required this.type});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      name: json['name'],
      title: json['title'],
      selftext: json['selftext'],
      url: json['url'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'title': title,
    'selftext': selftext,
    'url': url,
    'type': type,
  };
}
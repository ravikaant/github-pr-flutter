class PRModel {
  final String htmlUrl;
  final int prNumber;
  final String title;
  final String createdAt;
  final UserModel user;

  PRModel(
      {required this.htmlUrl,
      required this.prNumber,
      required this.title,
      required this.createdAt,
      required this.user});

  factory PRModel.fromJSON(Map<String, dynamic> json) => PRModel(
      htmlUrl: json['html_url'],
      prNumber: json['number'],
      title: json['title'],
      createdAt: json['created_at'],
      user: UserModel.fromJSON(json['user']));
}

class UserModel {
  final String login;
  final String avatarUrl;
  final String htmlUrl;

  UserModel({required this.login, required this.avatarUrl, required this.htmlUrl});

  factory UserModel.fromJSON(Map<String, dynamic> json) => UserModel(
      login: json['login'],
      avatarUrl: json['avatar_url'],
      htmlUrl: json['html_url']);
}

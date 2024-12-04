class UserData {
  UserData({
    required this.userId,
    required this.username,
    required this.thumbnailUrl,
  });

  /// Kakao API User ID
  final int userId;

  /// User name
  final String username;

  /// User Image
  final String thumbnailUrl;
}

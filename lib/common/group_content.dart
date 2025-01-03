class GroupContent {
  GroupContent({
    required this.content,
    required this.groupID,
    required this.contentID,
    required this.createdAt,
    required this.userId,
  });

  // Content of data
  final String content;

  // ID of group which contains content
  final int groupID;

  // ID of content
  final int contentID;

  final DateTime createdAt;

  final int userId;
}

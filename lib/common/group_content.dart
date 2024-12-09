class GroupContent {
  GroupContent({
    required this.content,
    required this.groupID,
    required this.contentID,
  });

  // Content of data
  final String content;

  // ID of group which contains content
  final int groupID;

  // ID of content
  final int contentID;
}

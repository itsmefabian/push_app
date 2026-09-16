class PushMessages {
  final String messageId;
  final String title;
  final String body;
  final DateTime sendDate;
  final Map<String, dynamic>? data;
  final String? imageUrl;

  new({
    required this.messageId,
    required this.title,
    required this.body,
    required this.sendDate,
    this.data,
    this.imageUrl,
  });

  @override
  String toString() {
    return '''
    PushMessage
    Id:          $messageId,
    Title:       $title,
    Body:        $body,
    SendDate:    $sendDate,
    Data:        $data,
    ImageUrl:    $imageUrl,
    ''';
  }
}

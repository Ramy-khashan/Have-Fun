class VideoModel {
  String? docId;
  String? videoUrl;
  String? description;
  String? userId;

  VideoModel({this.docId, this.videoUrl, this.description, this.userId});

  VideoModel.fromJson(Map<String, dynamic> json) {
    docId = json['doc_id'];
    videoUrl = json['video_url'];
    description = json['description'];
    userId = json['user_id'];
  }
}

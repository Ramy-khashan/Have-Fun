class MusicModel {
  String? category;
  String? userAuthId;
  String? userDocId;
  String? docId;
  String? audioUrl;
  String? audioName;

  MusicModel(
      {this.category,
      this.userAuthId,
      this.userDocId,
      this.docId,
      this.audioUrl,
      this.audioName});

  MusicModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    userAuthId = json['user_auth_id'];
    userDocId = json['user_doc_id'];
    docId = json['doc_id'];
    audioUrl = json['audio_url'];
    audioName = json['audio_name'];
  }


}

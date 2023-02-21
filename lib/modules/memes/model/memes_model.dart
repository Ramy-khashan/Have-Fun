class MemesModel {
  String? docId;
  String? memesImg;
  String? description;

  MemesModel({this.docId, this.memesImg, this.description});

  MemesModel.fromJson(Map<String, dynamic> json) {
    docId = json['doc_id'];
    memesImg = json['memes_img'];
    description = json['description'];
  }
}

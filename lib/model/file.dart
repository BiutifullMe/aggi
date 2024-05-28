class FilesModel {
  List<String> files;

  FilesModel({required this.files});

  factory FilesModel.fromJson(Map<String, dynamic> json) {
    return FilesModel(
      files: (json['files'] as List).map((file) => file as String).toList(),
    );
  }
}

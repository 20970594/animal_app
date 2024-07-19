/*class Gif {
  String name;
  String url;

  Gif(this.name, this.url);  // Forma correcta de definir el constructor
}*/

class ImageModel {
  final String url;

  ImageModel({required this.url});

  factory ImageModel.fromJson(String jsonUrl) {
    return ImageModel(
      url: jsonUrl,
    );
  }
}
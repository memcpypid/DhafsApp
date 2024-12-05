import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  List<Result> results;
  int offset;
  int number;
  int totalResults;

  Welcome({
    required this.results,
    required this.offset,
    required this.number,
    required this.totalResults,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        offset: json["offset"],
        number: json["number"],
        totalResults: json["totalResults"],
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "offset": offset,
        "number": number,
        "totalResults": totalResults,
      };
}

class Result {
  String id;
  String title;
  String image;
  ImageType imageType;
  String hargaProduk; // New field for product price
  String deskripsiProduk; // New field for product description
  String keteranganProduk; // New field for product notes
  String location;

  Result(
      {required this.id,
      required this.title,
      required this.image,
      required this.imageType,
      required this.hargaProduk,
      required this.deskripsiProduk,
      required this.keteranganProduk,
      required this.location});

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        imageType: imageTypeValues.map[json["imageType"]]!,
        hargaProduk: json["harga_produk"], // Parsing the price
        deskripsiProduk: json["Deskripsi_Produk"], // Parsing the description
        keteranganProduk: json["Keterangan_Produk"], // Parsing the notes
        location: json["location"], // Parsing the notes
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "imageType": imageTypeValues.reverse[imageType],
        "harga_produk": hargaProduk, // Serializing the price
        "Deskripsi_Produk": deskripsiProduk, // Serializing the description
        "Keterangan_Produk": keteranganProduk, // Serializing the notes
        "location": location
      };
}

enum ImageType { JPG }

final imageTypeValues = EnumValues({"jpg": ImageType.JPG});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

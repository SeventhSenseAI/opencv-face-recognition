import 'dart:convert';

ComparisonImages compareImageFromMap(String str) =>
    ComparisonImages.fromMap(json.decode(str));

String compareImageToMap(ComparisonImages data) => json.encode(data.toMap());

class ComparisonImages {
  final List<String> gallery;
  final List<String> probe;
  final String searchMode;

  ComparisonImages({
    required this.gallery,
    required this.probe,
    required this.searchMode,
  });

  factory ComparisonImages.fromMap(Map<String, dynamic> json) =>
      ComparisonImages(
        gallery: List<String>.from(json["gallery"].map((x) => x)),
        probe: List<String>.from(json["probe"].map((x) => x)),
        searchMode: json["search_mode"],
      );

  Map<String, dynamic> toMap() => {
        "gallery": List<dynamic>.from(gallery.map((x) => x)),
        "probe": List<dynamic>.from(probe.map((x) => x)),
        "search_mode": searchMode,
      };
}

class DeleteCollection {
  final String id;

  DeleteCollection({required this.id});

  factory DeleteCollection.fromJson(Map<String, dynamic> json) {
    return DeleteCollection(
      id: json['id'] ?? '',
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }

}

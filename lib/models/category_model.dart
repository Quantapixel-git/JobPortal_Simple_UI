class CategoryModel {
  final int id;
  final String category;
  final String image;
  final int status;
  final String createdAt;
  final String updatedAt;

  CategoryModel({
    required this.id,
    required this.category,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      category: json['categorie'] ?? '', // Use 'categorie' as per your JSON
      image: json['image'] ?? '',
      status: json['status'] is int
          ? json['status']
          : int.tryParse(json['status'].toString()) ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categorie': category, // Use 'categorie' as per your JSON
      'image': image,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
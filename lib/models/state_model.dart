class StateModel {
  final int id;
  final String state;
  final String image;
  final int status;
  final String createdAt;
  final String updatedAt;

  StateModel({
    required this.id,
    required this.state,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      state: json['state'] ?? '',
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
      'state': state,
      'image': image,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

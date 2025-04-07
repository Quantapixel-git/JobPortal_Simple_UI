class DistrictModel {
  final int id;
  final String district;
  final String image;
  final int stateId;
  final int status;
  final String createdAt;
  final String updatedAt;
  final String stateName;
  final String stateImage;

  DistrictModel({
    required this.id,
    required this.district,
    required this.image,
    required this.stateId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.stateName,
    required this.stateImage,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      district: json['district'] ?? '',
      image: json['image'] ?? '',
      stateId: json['state_id'] is int
          ? json['state_id']
          : int.tryParse(json['state_id'].toString()) ?? 0,
      status: json['status'] is int
          ? json['status']
          : int.tryParse(json['status'].toString()) ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      stateName: json['state_name'] ?? '',
      stateImage: json['state_image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'district': district,
      'image': image,
      'state_id': stateId,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'state_name': stateName,
      'state_image': stateImage,
    };
  }
}

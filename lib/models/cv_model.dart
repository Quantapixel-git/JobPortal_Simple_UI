class ResumeModel {
  final int id;
  final String name;
  final String dob;
  final String email;
  final String mobile;
  final String qualification;
  final String experience;
  final String skills;
  final String address;
  final String linkedin;
  final String resume;
  final int status;
  final String createdAt;
  final String updatedAt;

  ResumeModel({
    required this.id,
    required this.name,
    required this.dob,
    required this.email,
    required this.mobile,
    required this.qualification,
    required this.experience,
    required this.skills,
    required this.address,
    required this.linkedin,
    required this.resume,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    return ResumeModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      dob: json['dob'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      qualification: json['qualification'] ?? '',
      experience: json['experience'] ?? '',
      skills: json['skills'] ?? '',
      address: json['address'] ?? '',
      linkedin: json['linkedin'] ?? '',
      resume: json['resume'] ?? '',
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
      'name': name,
      'dob': dob,
      'email': email,
      'mobile': mobile,
      'qualification': qualification,
      'experience': experience,
      'skills': skills,
      'address': address,
      'linkedin': linkedin,
      'resume': resume,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
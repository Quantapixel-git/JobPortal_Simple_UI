class JobModel {
  final int id;
  final int stateId;
  final int districtId;
  final int categoryId;
  final String jobTitle;
  final String? companyLogo;
  final String companyName;
  final String companyLocation;
  final String salary;
  final String qualification;
  final String experience;
  final String gender;
  final String maritalStatus;
  final String contactNumber;
  final String email;
  final String skills;
  final String? image;
  final String? additionalImage1;
  final String? additionalImage2;
  final String jobLocations;
  final String jobDescription;
  final String expiryAt;
  int isFeatured;
  int status;
  final String createdAt;
  final String updatedAt;
  final String stateName;
  final String districtName;
  final String categoryName;
  final String stateImage;
  final String districtImage;
  final String categoryImage;

  JobModel({
    required this.id,
    required this.stateId,
    required this.districtId,
    required this.categoryId,
    required this.jobTitle,
    this.companyLogo,
    required this.companyName,
    required this.companyLocation,
    required this.salary,
    required this.qualification,
    required this.experience,
    required this.gender,
    required this.maritalStatus,
    required this.contactNumber,
    required this.email,
    required this.skills,
    this.image,
    this.additionalImage1,
    this.additionalImage2,
    required this.jobLocations,
    required this.jobDescription,
    required this.expiryAt,
    required this.isFeatured,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.stateName,
    required this.districtName,
    required this.categoryName,
    required this.stateImage,
    required this.districtImage,
    required this.categoryImage,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      stateId: json['state_id'] is int
          ? json['state_id']
          : int.tryParse(json['state_id'].toString()) ?? 0,
      districtId: json['district_id'] is int
          ? json['district_id']
          : int.tryParse(json['district_id'].toString()) ?? 0,
      categoryId: json['category_id'] is int
          ? json['category_id']
          : int.tryParse(json['category_id'].toString()) ?? 0,
      jobTitle: json['job_title'] ?? '',
      companyLogo: json['company_logo'],
      companyName: json['company_name'] ?? '',
      companyLocation: json['company_location'] ?? '',
      salary: json['salary'] ?? '',
      qualification: json['qualification'] ?? '',
      experience: json['experience'] ?? '',
      gender: json['gender'] ?? '',
      maritalStatus: json['marital_status'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      email: json['email'] ?? '',
      skills: json['skills'] ?? '',
      image: json['image'],
      additionalImage1: json['additional_image1'],
      additionalImage2: json['additional_image2'],
      jobLocations: json['job_locations'] ?? '',
      jobDescription: json['job_description'] ?? '',
      expiryAt: json['expiry_at'] ?? '',
      isFeatured: json['is_featured'] is int
          ? json['is_featured']
          : int.tryParse(json['is_featured'].toString()) ?? 0,
      status: json['status'] is int
          ? json['status']
          : int.tryParse(json['status'].toString()) ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      stateName: json['state_name'] ?? '',
      districtName: json['district_name'] ?? '',
      categoryName: json['category_name'] ?? '',
      stateImage: json['state_image'] ?? '',
      districtImage: json['district_image'] ?? '',
      categoryImage: json['category_image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'state_id': stateId,
      'district_id': districtId,
      'category_id': categoryId,
      'job_title': jobTitle,
      'company_logo': companyLogo,
      'company_name': companyName,
      'company_location': companyLocation,
      'salary': salary,
      'qualification': qualification,
      'experience': experience,
      'gender': gender,
      'marital_status': maritalStatus,
      'contact_number': contactNumber,
      'email': email,
      'skills': skills,
      'image': image,
      'additional_image1': additionalImage1,
      'additional_image2': additionalImage2,
      'job_locations': jobLocations,
      'job_description': jobDescription,
      'expiry_at': expiryAt,
      'is_featured': isFeatured,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'state_name': stateName,
      'district_name': districtName,
      'category_name': categoryName,
      'state_image': stateImage,
      'district_image': districtImage,
      'category_image': categoryImage,
    };
  }
}

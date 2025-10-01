class ProductDetailsModel {
  final bool success;
  final String message;
  final ProductDetails data;

  ProductDetailsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ProductDetails.fromJson(json['data'] ?? {}),
    );
  }
}

class ProductDetails {
  final String id;
  final String productName;
  final String ingredients;
  final List<String> image;
  final List<String> howToUse;
  final String note;
  final String description;
  final SkinCondition? skinCondition;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductDetails({
    required this.id,
    required this.productName,
    required this.ingredients,
    required this.image,
    required this.howToUse,
    required this.note,
    required this.description,
    this.skinCondition,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      id: json['_id'] ?? '',
      productName: json['productName'] ?? '',
      ingredients: json['ingredients'] ?? '',
      image: json['image'] != null 
          ? List<String>.from(json['image']) 
          : [],
      howToUse: json['howToUse'] != null 
          ? List<String>.from(json['howToUse']) 
          : [],
      note: json['note'] ?? '',
      description: json['description'] ?? '',
      skinCondition: json['skinCondition'] != null 
          ? SkinCondition.fromJson(json['skinCondition']) 
          : null,
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt'].toString()) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.tryParse(json['updatedAt'].toString()) 
          : null,
    );
  }
}

class SkinCondition {
  final String id;
  final String image;
  final String skinType;
  final String symptoms;
  final List<String> treatment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SkinCondition({
    required this.id,
    required this.image,
    required this.skinType,
    required this.symptoms,
    required this.treatment,
    this.createdAt,
    this.updatedAt,
  });

  factory SkinCondition.fromJson(Map<String, dynamic> json) {
    return SkinCondition(
      id: json['_id'] ?? '',
      image: json['image'] ?? '',
      skinType: json['skinType'] ?? '',
      symptoms: json['symptmos'] ?? '', // Note: API has typo 'symptmos'
      treatment: json['treatment'] != null 
          ? List<String>.from(json['treatment']) 
          : [],
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt'].toString()) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.tryParse(json['updatedAt'].toString()) 
          : null,
    );
  }
}
class RoutineHomeModel {
  final bool success;
  final String message;
  final RoutineData data;

  RoutineHomeModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RoutineHomeModel.fromJson(Map<String, dynamic> json) {
    return RoutineHomeModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: RoutineData.fromJson(json['data'] ?? {}),
    );
  }
}

class RoutineData {
  final List<RoutineItem> result;
  final Meta meta;

  RoutineData({
    required this.result,
    required this.meta,
  });

  factory RoutineData.fromJson(Map<String, dynamic> json) {
    return RoutineData(
      result: (json['result'] as List<dynamic>?)
              ?.map((item) => RoutineItem.fromJson(item))
              .toList() ??
          [],
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }
}

class RoutineItem {
  final String id;
  final String category;
  final Product product;
  final DateTime? createdAt;
  final List<String>? morningTimeOfDay;
  final List<String>? eveningTimeOfDay;

  RoutineItem({
    required this.id,
    required this.category,
    required this.product,
    this.createdAt,
    this.morningTimeOfDay,
    this.eveningTimeOfDay,
  });

  factory RoutineItem.fromJson(Map<String, dynamic> json) {
    return RoutineItem(
      id: json['_id'] ?? '',
      category: json['category'] ?? '',
      product: Product.fromJson(json['product'] ?? {}),
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt'].toString())
          : _extractDateFromObjectId(json['_id'] ?? ''),
      morningTimeOfDay: json['morningTimeOfDay'] != null 
          ? List<String>.from(json['morningTimeOfDay']) 
          : null,
      eveningTimeOfDay: json['eveningTimeOfDay'] != null 
          ? List<String>.from(json['eveningTimeOfDay']) 
          : null,
    );
  }

  // Extract timestamp from MongoDB ObjectId
  static DateTime? _extractDateFromObjectId(String objectId) {
    if (objectId.length >= 8) {
      try {
        final timestampHex = objectId.substring(0, 8);
        final timestamp = int.parse(timestampHex, radix: 16);
        return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}

class Product {
  final String id;
  final String productName;

  Product({
    required this.id,
    required this.productName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      productName: json['productName'] ?? '',
    );
  }
}

class Meta {
  final int page;
  final int limit;
  final int total;

  Meta({
    required this.page,
    required this.limit,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
    );
  }
}
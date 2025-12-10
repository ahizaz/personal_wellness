class QuestionModel {
  final bool success;
  final String message;
  final QuestionDataWrapper data;

  QuestionModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: QuestionDataWrapper.fromJson(json['data'] ?? {}),
    );
  }
}

class QuestionDataWrapper {
  final List<QuestionData> result;
  final QuestionMeta meta;

  QuestionDataWrapper({
    required this.result,
    required this.meta,
  });

  factory QuestionDataWrapper.fromJson(Map<String, dynamic> json) {
    // Safely parse the result list
    List<QuestionData> resultList = [];
    if (json['result'] != null) {
      if (json['result'] is List) {
        resultList = (json['result'] as List)
            .map((item) => QuestionData.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    }
    
    return QuestionDataWrapper(
      result: resultList,
      meta: QuestionMeta.fromJson(json['meta'] ?? {}),
    );
  }
}

class QuestionMeta {
  final int page;
  final int limit;
  final int total;

  QuestionMeta({
    required this.page,
    required this.limit,
    required this.total,
  });

  factory QuestionMeta.fromJson(Map<String, dynamic> json) {
    return QuestionMeta(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
    );
  }
}

class QuestionData {
  final String id;
  final String question;
  final String questionType; // 'single', 'multiple', 'text', etc.
  final List<QuestionOption> options;
  final bool isRequired;
  final int order;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  QuestionData({
    required this.id,
    required this.question,
    required this.questionType,
    required this.options,
    required this.isRequired,
    required this.order,
    this.createdAt,
    this.updatedAt,
  });

  factory QuestionData.fromJson(Map<String, dynamic> json) {
    // Safely parse the options list
    List<QuestionOption> optionsList = [];
    if (json['options'] != null && json['options'] is List) {
      optionsList = (json['options'] as List)
          .map((item) => QuestionOption.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    
    return QuestionData(
      id: json['_id'] ?? json['id'] ?? '',
      question: json['question'] ?? '',
      questionType: json['questionType'] ?? json['type'] ?? 'single',
      options: optionsList,
      isRequired: json['isRequired'] ?? json['required'] ?? true,
      order: json['order'] ?? json['sequence'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }
}

class QuestionOption {
  final String id;
  final String text;
  final String? value;
  final bool isOther; // If true, shows text field when selected
  final int order;

  QuestionOption({
    required this.id,
    required this.text,
    this.value,
    this.isOther = false,
    this.order = 0,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['_id'] ?? json['id'] ?? '',
      text: json['text'] ?? json['label'] ?? json['option'] ?? '',
      value: json['value'] ?? json['text'] ?? json['label'] ?? json['option'],
      isOther: json['isOther'] ?? json['is_other'] ?? false,
      order: json['order'] ?? json['sequence'] ?? 0,
    );
  }
}


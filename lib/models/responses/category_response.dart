class CategoryResponse {
  final bool? status;
  final String? message;
  final List<Category>? categories;

  CategoryResponse({
    this.status,
    this.message,
    this.categories,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      categories: (json['categories'] as List?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'categories': categories?.map((e) => e.toJson()).toList(),
  };
}

class Category {
  final int? id;
  final String? name;
  final String? description;
  final String? image;
  final String? slug;
  final String? createdAt;
  final String? updatedAt;

  Category({
    this.id,
    this.name,
    this.description,
    this.image,
    this.slug,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      slug: json['slug'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'image': image,
    'slug': slug,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

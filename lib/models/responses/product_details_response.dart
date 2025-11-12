class ProductDetailsResponse {
  final bool? success;
  final ProductDetails? product;

  ProductDetailsResponse({
    this.success,
    this.product,
  });

  factory ProductDetailsResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProductDetailsResponse();
    return ProductDetailsResponse(
      success: json['success'] as bool?,
      product: json['product'] != null
          ? ProductDetails.fromJson(json['product'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'product': product?.toJson(),
    };
  }
}

class ProductDetails {
  final int? id;
  final int? categoryId;
  final int? subCategoryId;
  final String? name;
  final String? description;
  final String? price;
  final String? image;
  final String? image1;
  final String? image2;
  final String? weight;
  final int? stock;
  final String? createdAt;
  final String? updatedAt;
  final CategoryDetails? category;
  final SubCategoryDetails? subcategory;

  ProductDetails({
    this.id,
    this.categoryId,
    this.subCategoryId,
    this.name,
    this.description,
    this.price,
    this.image,
    this.image1,
    this.image2,
    this.weight,
    this.stock,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.subcategory,
  });

  factory ProductDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProductDetails();
    return ProductDetails(
      id: json['id'] as int?,
      categoryId: json['category_id'] as int?,
      subCategoryId: json['sub_category_id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: json['price']?.toString(),
      image: json['image'] as String?,
      image1: json['image1'] as String?,
      image2: json['image2'] as String?,
      weight: json['weight']?.toString(),
      stock: json['stock'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      category: json['category'] != null
          ? CategoryDetails.fromJson(json['category'])
          : null,
      subcategory: json['subcategory'] != null
          ? SubCategoryDetails.fromJson(json['subcategory'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'sub_category_id': subCategoryId,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'image1': image1,
      'image2': image2,
      'weight': weight,
      'stock': stock,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'category': category?.toJson(),
      'subcategory': subcategory?.toJson(),
    };
  }
}

class CategoryDetails {
  final int? id;
  final String? name;
  final String? description;
  final String? image;
  final String? slug;
  final String? createdAt;
  final String? updatedAt;

  CategoryDetails({
    this.id,
    this.name,
    this.description,
    this.image,
    this.slug,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CategoryDetails();
    return CategoryDetails(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      slug: json['slug'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'slug': slug,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class SubCategoryDetails {
  final int? id;
  final String? name;
  final int? categoryId;
  final String? description;
  final String? image;
  final String? createdAt;
  final String? updatedAt;

  SubCategoryDetails({
    this.id,
    this.name,
    this.categoryId,
    this.description,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory SubCategoryDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) return SubCategoryDetails();
    return SubCategoryDetails(
      id: json['id'] as int?,
      name: json['name'] as String?,
      categoryId: json['category_id'] as int?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'description': description,
      'image': image,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

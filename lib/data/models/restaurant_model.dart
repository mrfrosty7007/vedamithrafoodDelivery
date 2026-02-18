import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {
  final String name;
  final bool isOpen;
  final String ownerId;
  final String address;
  final DateTime createdAt;

  const RestaurantModel({
    required this.name,
    required this.isOpen,
    required this.ownerId,
    required this.address,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isOpen': isOpen,
      'ownerId': ownerId,
      'address': address,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    return RestaurantModel(
      name: map['name'] ?? '',
      isOpen: map['isOpen'] ?? false,
      ownerId: map['ownerId'] ?? '',
      address: map['address'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  RestaurantModel copyWith({
    String? name,
    bool? isOpen,
    String? ownerId,
    String? address,
    DateTime? createdAt,
  }) {
    return RestaurantModel(
      name: name ?? this.name,
      isOpen: isOpen ?? this.isOpen,
      ownerId: ownerId ?? this.ownerId,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

import 'package:uuid/uuid.dart';

class CategoryEntity {
  final String id;
  final String name;
  final String icon;

  CategoryEntity({
    String? id,
    required this.name,
    required this.icon,
  }) : id = id ?? const Uuid().v4();

  CategoryEntity copyWith({String? name, String? icon}) => CategoryEntity(
        id: id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
      );

  factory CategoryEntity.fromJson(Map<String, dynamic> json) => CategoryEntity(
        id: json['id'],
        name: json['name'],
        icon: json['icon']
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon' : icon
      };
}

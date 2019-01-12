// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Inventory _$InventoryFromJson(Map json) {
  return Inventory()
    ..currentlyEquiped = json['currentlyEquiped'] == null
        ? null
        : SoftGameObject.fromJson(json['currentlyEquiped'] as Map)
    ..items = (json['items'] as List)
        ?.map((e) => e == null ? null : SoftGameObject.fromJson(e as Map))
        ?.toList();
}

Map<String, dynamic> _$InventoryToJson(Inventory instance) => <String, dynamic>{
      'currentlyEquiped': instance.currentlyEquiped,
      'items': instance.items
    };

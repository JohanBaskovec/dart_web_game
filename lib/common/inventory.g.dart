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
    ..stacks = (json['stacks'] as List)
        ?.map((e) => e == null ? null : Stack.fromJson(e as Map))
        ?.toList();
}

Map<String, dynamic> _$InventoryToJson(Inventory instance) => <String, dynamic>{
      'currentlyEquiped': instance.currentlyEquiped,
      'stacks': instance.stacks
    };

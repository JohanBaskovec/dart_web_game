// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_component.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryComponent _$InventoryComponentFromJson(Map json) {
  return InventoryComponent()
    ..currentlyEquiped = json['currentlyEquiped'] as int
    ..stacks = (json['stacks'] as List)
        ?.map((e) => (e as List)?.map((e) => e as int)?.toList())
        ?.toList();
}

Map<String, dynamic> _$InventoryComponentToJson(InventoryComponent instance) =>
    <String, dynamic>{
      'currentlyEquiped': instance.currentlyEquiped,
      'stacks': instance.stacks
    };

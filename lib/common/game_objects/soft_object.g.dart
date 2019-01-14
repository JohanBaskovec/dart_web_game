// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soft_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoftGameObject _$SoftGameObjectFromJson(Map json) {
  return SoftGameObject(
      _$enumDecodeNullable(_$SoftObjectTypeEnumMap, json['type']),
      json['position'] == null
          ? null
          : WorldPosition.fromJson(json['position'] as Map))
    ..index = json['index'] as int;
}

Map<String, dynamic> _$SoftGameObjectToJson(SoftGameObject instance) =>
    <String, dynamic>{
      'type': _$SoftObjectTypeEnumMap[instance.type],
      'position': instance.position,
      'index': instance.index
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$SoftObjectTypeEnumMap = <SoftObjectType, dynamic>{
  SoftObjectType.stone: 'stone',
  SoftObjectType.axe: 'axe',
  SoftObjectType.log: 'log',
  SoftObjectType.hand: 'hand',
  SoftObjectType.apple: 'apple',
  SoftObjectType.fruitTreeLog: 'fruitTreeLog',
  SoftObjectType.bowl: 'bowl',
  SoftObjectType.bandage: 'bandage',
  SoftObjectType.soap: 'soap',
  SoftObjectType.knife: 'knife',
  SoftObjectType.sword: 'sword',
  SoftObjectType.shield: 'shield',
  SoftObjectType.bag: 'bag',
  SoftObjectType.pickaxe: 'pickaxe',
  SoftObjectType.spider: 'spider',
  SoftObjectType.cricket: 'cricket',
  SoftObjectType.potato: 'potato',
  SoftObjectType.snake: 'snake',
  SoftObjectType.leaves: 'leaves',
  SoftObjectType.bow: 'bow',
  SoftObjectType.arrow: 'arrow',
  SoftObjectType.string: 'string',
  SoftObjectType.rope: 'rope',
  SoftObjectType.fiber: 'fiber',
  SoftObjectType.bone: 'bone',
  SoftObjectType.tooth: 'tooth',
  SoftObjectType.spear: 'spear',
  SoftObjectType.banana: 'banana',
  SoftObjectType.worm: 'worm',
  SoftObjectType.bread: 'bread',
  SoftObjectType.rice: 'rice',
  SoftObjectType.fish: 'fish'
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stack _$StackFromJson(Map json) {
  return Stack(
      _$enumDecodeNullable(_$SoftObjectTypeEnumMap, json['objectType']))
    ..objectsIds = (json['objectsIds'] as List)?.map((e) => e as int)?.toList();
}

Map<String, dynamic> _$StackToJson(Stack instance) => <String, dynamic>{
      'objectType': _$SoftObjectTypeEnumMap[instance.objectType],
      'objectsIds': instance.objectsIds
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

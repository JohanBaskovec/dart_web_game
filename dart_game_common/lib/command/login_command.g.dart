// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginCommand _$LoginCommandFromJson(Map json) {
  return LoginCommand(json['name'] as String, json['id'] as int)
    ..type = _$enumDecodeNullable(_$CommandTypeEnumMap, json['type']);
}

Map<String, dynamic> _$LoginCommandToJson(LoginCommand instance) =>
    <String, dynamic>{
      'type': _$CommandTypeEnumMap[instance.type],
      'name': instance.name,
      'id': instance.id
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

const _$CommandTypeEnumMap = <CommandType, dynamic>{
  CommandType.Login: 'Login',
  CommandType.AddPlayer: 'AddPlayer',
  CommandType.Move: 'Move',
  CommandType.Unknown: 'Unknown'
};

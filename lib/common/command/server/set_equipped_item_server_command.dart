import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';
import 'package:json_annotation/json_annotation.dart';

part 'set_equipped_item_server_command.g.dart';

@JsonSerializable(anyMap: true)
class SetEquippedItemServerCommand extends ServerCommand {
  int itemId;

  SetEquippedItemServerCommand(this.itemId)
      : assert(itemId != null),
        super(ServerCommandType.setEquippedItem);

  @override
  void execute(Session session, World world) {
    session.player.inventory.currentlyEquiped = itemId;
  }

  /// Creates a new [SetEquippedItemServerCommand] from a JSON object.
  static SetEquippedItemServerCommand fromJson(Map<dynamic, dynamic> json) =>
      _$SetEquippedItemServerCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$SetEquippedItemServerCommandToJson(this);
}

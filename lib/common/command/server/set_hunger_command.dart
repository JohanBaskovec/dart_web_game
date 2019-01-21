import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/hunger_component.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/ui_controller.dart';
import 'package:json_annotation/json_annotation.dart';


part 'set_hunger_command.g.dart';

@JsonSerializable(anyMap: true)
class SetHungerCommand extends ServerCommand {
  HungerComponent hungerComponent;
  
  SetHungerCommand(this.hungerComponent): super(ServerCommandType.setHunger);


  @override
  void execute(Session session, World world, [UiController uiController]) {
    print('Executing $this');
    session.player.hungerComponent = hungerComponent;
  }

  /// Creates a new [SetHungerCommand] from a JSON object.
  static SetHungerCommand fromJson(Map<dynamic, dynamic> json) =>
      _$SetHungerCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$SetHungerCommandToJson(this);

  @override
  String toString() {
    return 'SetHungerCommand{hungerComponent: $hungerComponent}';
  }
}
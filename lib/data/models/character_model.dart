import 'package:valorant_app/data/models/role_model.dart';
import 'package:valorant_app/data/models/voice_line.dart';
import 'ability_model.dart';

class CharacterModel{
  String description,displayName,filePortrait,displayIcon;
  List<Ability> abilities;
  VoiceLine voiceLine;
  Role role;

  CharacterModel({
    required this.description, required this.displayName, required this.filePortrait,required this.role,
    required this.displayIcon, required this.abilities, required this.voiceLine
});
}
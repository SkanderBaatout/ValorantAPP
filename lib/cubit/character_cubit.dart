import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:valorant_app/data/models/ability_model.dart';
import 'package:valorant_app/data/models/role_model.dart';
import 'package:valorant_app/data/models/voice_line.dart';

import '../data/models/character_model.dart';
import '../data/repository/repo_layer.dart';

part 'character_state.dart';

class CharacterCubit extends Cubit<CharacterState> {
  CharacterCubit(this.repoLayer) : super(CharacterInitial());

  final RepoLayer repoLayer;

  Future<List<CharacterModel>> requestCharacter() async {
    try {
      final response = await repoLayer.getAgent();
      if (response == null) {
        return [];
      } else {
        final responseDecoded = json.decode(response.body);
        //jsonDecode(response.body);
        final skander = responseDecoded["data"] as List<dynamic>;
        final list = skander
            .map((dynamic e) {
              //serialization and deserialization
              //role serialization
              final role = e["role"] ?? {};
              final roleInfo = Role(
                  uuid: role["uuid"] ?? "",
                  displayIcon: role["displayIcon"],
                  description: role["description"] ?? "",
                  displayName: role["displayName"]);

              //ability model problem
              final ability = e["abilities"] as List<dynamic>;
              final abilities = ability.map((dynamic e) {
                return Ability(
                    slot: e["slot"] ?? "",
                    displayIcon: e["displayIcon"] ?? "",
                    description: e["description"] ?? "",
                    displayName: e["displayName"] ?? "");
              }).toList();
              abilities
                  .retainWhere((element) => element.displayIcon.isNotEmpty);

              //voice line
              final voiceLine = e["voiceLine"] ?? {};
              final voiceMediaList = voiceLine["mediaList"] as List;
              final voiceMedia =
                  VoiceLine(voiceLine: voiceMediaList[0]["wave"]);

              return CharacterModel(
                  description: e["description"] ?? "",
                  displayName: e["displayName"] ?? "",
                  filePortrait: e["fullPortrait"] ?? "",
                  displayIcon: e["displayIcon"] ?? "",
                  abilities: abilities,
                  voiceLine: voiceLine,
                  role: roleInfo);
            })
            .toSet()
            .toList();
        list.retainWhere((x) => x.filePortrait.isNotEmpty);
        return list;
      }
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }
}

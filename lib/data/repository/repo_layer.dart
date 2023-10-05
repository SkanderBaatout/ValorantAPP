import 'package:valorant_app/data/service/web_service.dart';

class RepoLayer {
  final WebService apiProvider;

  RepoLayer({required this.apiProvider});

  Future<dynamic> getAgent() async {
    return apiProvider.getAgent();
  }
}

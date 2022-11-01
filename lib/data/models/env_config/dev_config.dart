import 'package:telling/data/models/env_config/base_config.dart';

class DevConfig implements BaseConfig {
  String get pathApi => "http://telling-api.herokuapp.com/api";
}

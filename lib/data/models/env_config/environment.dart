import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:telling/data/models/env_config/base_config.dart';
import 'package:telling/data/models/env_config/dev_config.dart';
import 'package:telling/data/models/env_config/local_config.dart';
import 'package:telling/data/models/env_config/prod_config.dart';
import 'package:telling/data/models/env_config/qa_config.dart';
import 'package:telling/utils/constants/enums.dart';

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  late BaseConfig config;

  initConfig() {
    final environmentEnv = dotenv.env['ENVIRONMENT'];
    //Default "dev"
    Environments environment = Environments.values.firstWhere(
        (e) => e.toString() == 'Environments.' + (environmentEnv ?? "dev"));
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(Environments environment) {
    switch (environment) {
      case Environments.local:
        return LocalConfig();
      case Environments.dev:
        return DevConfig();
      case Environments.qa:
        return QaConfig();
      case Environments.prod:
        return ProdConfig();
      default:
        return DevConfig();
    }
  }
}

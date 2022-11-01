import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:telling/data/models/env_config/base_config.dart';

class LocalConfig implements BaseConfig {
  final localIp = dotenv.env['LOCAL_IP'];
  String get pathApi => "http://$localIp:4000/api";
}

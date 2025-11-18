import 'package:talker/talker.dart';

class LoggerService{
  late final Talker _talker;

  LoggerService._internal() {
    _talker = Talker();
  }

  static final LoggerService _instance = LoggerService._internal();
  factory LoggerService() => _instance;

  Talker get instance => _talker;
}
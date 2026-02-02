import 'package:flutter/foundation.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:is_spam/services/spam_detector.dart';
import '../models/sms_message.dart';

enum FilterType { all, spam, ham }

class SmsProvider with ChangeNotifier {
  final SmsQuery _query = SmsQuery();
  List<SmsMessageModel> _messages = [];
  bool _isLoading = false;
  FilterType _currentFilter = FilterType.all;
  String _errorMessage = '';

  List<SmsMessageModel> get messages {
    switch (_currentFilter) {
      case FilterType.spam:
        return _messages.where((m) => m.status == SpamStatus.spam).toList();
      case FilterType.ham:
        return _messages.where((m) => m.status == SpamStatus.ham).toList();
      case FilterType.all:
        return _messages;
    }
  }

  bool get isLoading => _isLoading;
  FilterType get currentFilter => _currentFilter;
  String get errorMessage => _errorMessage;

  void setFilter(FilterType filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  Future<void> fetchMessages() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final permission = await Permission.sms.status;
      if (permission.isDenied) {
        final result = await Permission.sms.request();
        if (result.isDenied) {
          _errorMessage = 'Sms permission denied';
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      final messages = await _query.querySms(
        kinds: [SmsQueryKind.inbox],
        count: 100, // Limit for performance
      );

      _messages = messages
          .map((m) => SmsMessageModel.fromSmsMessage(m))
          .toList();
    } catch (e) {
      _errorMessage = 'Error fetching messages: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

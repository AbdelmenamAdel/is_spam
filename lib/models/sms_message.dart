import 'package:is_spam/services/spam_detector.dart';

class SmsMessageModel {
  final String id;
  final String address;
  final String body;
  final DateTime date;
  final SpamStatus status;

  SmsMessageModel({
    required this.id,
    required this.address,
    required this.body,
    required this.date,
    required this.status,
  });

  factory SmsMessageModel.fromSmsMessage(dynamic message) {
    final body = message.body ?? '';
    return SmsMessageModel(
      id: message.id.toString(),
      address: message.address ?? 'Unknown',
      body: body,
      date: message.date ?? DateTime.now(),
      status: SpamDetector.classify(body),
    );
  }
}

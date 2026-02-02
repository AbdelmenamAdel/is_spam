import 'package:flutter/material.dart';
import 'package:is_spam/models/sms_message.dart';
import 'package:is_spam/services/spam_detector.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class SmsListItem extends StatelessWidget {
  final SmsMessageModel message;

  const SmsListItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isSpam = message.status == SpamStatus.spam;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 6,
                color: isSpam ? Color(0xFFFF5252) : Color(0xFF4CAF50),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              message.address,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF2D3436),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            DateFormat('MMM d, h:mm a').format(message.date),
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        message.body,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Color(0xFF636E72),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isSpam
                              ? Color(0xFFFF5252).withOpacity(0.1)
                              : Color(0xFF4CAF50).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isSpam ? Icons.block : Icons.check_circle_outline,
                              size: 14,
                              color: isSpam
                                  ? Color(0xFFFF5252)
                                  : Color(0xFF4CAF50),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isSpam ? 'SPAM' : 'NOT SPAM',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                color: isSpam
                                    ? Color(0xFFFF5252)
                                    : Color(0xFF4CAF50),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

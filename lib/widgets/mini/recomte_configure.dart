import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:is_spam/main.dart';
import 'lol_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

bool? autherMedia;

class AppGate extends StatefulWidget {
  const AppGate({super.key});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> {
  bool? appEnabled;
  @override
  void initState() {
    super.initState();
    _checkAppStatus();
  }

  Future<void> _checkAppStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool enabled = prefs.getBool('shield_sms') ?? true;

    log('Initial app enabled status from prefs: $enabled');
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 8),
          minimumFetchInterval: Duration.zero,
        ),
      );

      await remoteConfig.fetchAndActivate();
      enabled = remoteConfig.getBool('shield_sms');
      autherMedia = remoteConfig.getBool('shield_sms_auther_media');
      log('Fetched app enabled status from Remote Config: $enabled');
      await prefs.setBool('shield_sms', enabled);
    } catch (_) {
      log('Failed to fetch Remote Config, using cached value: $enabled');
    }

    if (!mounted) return;

    setState(() {
      appEnabled = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    log('Building AppGate with appEnabled: $appEnabled');
    // ⏳ لسه بيشيّك
    if (appEnabled == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ❌ التطبيق مقفول
    if (appEnabled == false) {
      return const LolView();
    }

    // ✅ التطبيق شغال
    return const HomeScreen();
  }
}

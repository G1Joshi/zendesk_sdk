import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'zendesk_sdk_platform_interface.dart';

/// An implementation of [ZendeskSdkPlatform] that uses method channels.
class MethodChannelZendeskSdk extends ZendeskSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('zendesk_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

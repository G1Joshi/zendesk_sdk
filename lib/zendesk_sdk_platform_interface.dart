import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'zendesk_sdk_method_channel.dart';

abstract class ZendeskSdkPlatform extends PlatformInterface {
  /// Constructs a ZendeskSdkPlatform.
  ZendeskSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static ZendeskSdkPlatform _instance = MethodChannelZendeskSdk();

  /// The default instance of [ZendeskSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelZendeskSdk].
  static ZendeskSdkPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ZendeskSdkPlatform] when
  /// they register themselves.
  static set instance(ZendeskSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

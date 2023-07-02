
import 'zendesk_sdk_platform_interface.dart';

class ZendeskSdk {
  Future<String?> getPlatformVersion() {
    return ZendeskSdkPlatform.instance.getPlatformVersion();
  }
}

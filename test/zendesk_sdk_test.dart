import 'package:flutter_test/flutter_test.dart';
import 'package:zendesk_sdk/zendesk_sdk.dart';
import 'package:zendesk_sdk/zendesk_sdk_platform_interface.dart';
import 'package:zendesk_sdk/zendesk_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockZendeskSdkPlatform 
    with MockPlatformInterfaceMixin
    implements ZendeskSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ZendeskSdkPlatform initialPlatform = ZendeskSdkPlatform.instance;

  test('$MethodChannelZendeskSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelZendeskSdk>());
  });

  test('getPlatformVersion', () async {
    ZendeskSdk zendeskSdkPlugin = ZendeskSdk();
    MockZendeskSdkPlatform fakePlatform = MockZendeskSdkPlatform();
    ZendeskSdkPlatform.instance = fakePlatform;
  
    expect(await zendeskSdkPlugin.getPlatformVersion(), '42');
  });
}

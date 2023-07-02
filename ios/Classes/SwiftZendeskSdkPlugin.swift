import Flutter
import UIKit
import ZendeskCoreSDK
import SupportProvidersSDK
import AnswerBotProvidersSDK
import ChatProvidersSDK

import AnswerBotSDK
import ChatSDK
import MessagingSDK
import SupportSDK

public class SwiftZendeskSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "zendesk_sdk", binaryMessenger: registrar.messenger())
    let instance = SwiftZendeskSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    Zendesk.initialize(appId: "",
        clientId: "",
        zendeskUrl: "")
    
    let identity = Identity.createAnonymous(name: "", email: "")
    Zendesk.instance?.setIdentity(identity)
    
    Support.initialize(withZendesk: Zendesk.instance)
    AnswerBot.initialize(withZendesk: Zendesk.instance, support: Support.instance!)
    Chat.initialize(accountKey: "")

do {
    let messagingConfiguration = MessagingConfiguration()
    let answerBotEngine = try AnswerBotEngine.engine()
    let supportEngine = try SupportEngine.engine()
    let chatEngine = try ChatEngine.engine()

    guard let viewController = Messaging.instance.buildUI(engines: [answerBotEngine, supportEngine, chatEngine],configs: [messagingConfiguration]) else { return }
    guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else { return }
        rootViewController.present(viewController, animated: true, completion: nil)
} catch{}

    result("iOS " + UIDevice.current.systemVersion)
  }
}

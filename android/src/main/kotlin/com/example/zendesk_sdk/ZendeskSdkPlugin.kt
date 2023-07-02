package com.example.zendesk_sdk

import androidx.annotation.NonNull
import android.content.Context
import android.app.Activity

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import zendesk.answerbot.AnswerBot
import zendesk.answerbot.AnswerBotEngine
import zendesk.chat.Chat
import zendesk.chat.ChatEngine
import zendesk.core.AnonymousIdentity
import zendesk.core.Identity
import zendesk.core.Zendesk
import zendesk.messaging.Engine
import zendesk.messaging.MessagingActivity
import zendesk.support.Support
import zendesk.support.SupportEngine

/** ZendeskSdkPlugin */
class ZendeskSdkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context : Context
  private lateinit var activity : Activity

  private lateinit var zendeskUrl : String
  private lateinit var appId : String
  private lateinit var oauthClientId : String
  private lateinit var chatAccountKey : String
  private lateinit var name : String
  private lateinit var email : String

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "zendesk_sdk")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext

    zendeskUrl = "";
    appId  = "";
    oauthClientId = "";
    chatAccountKey = "";
    name = "";
    email = "";
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "zendesk_sdk")
      channel.setMethodCallHandler(ZendeskSdkPlugin())
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      Zendesk.INSTANCE.init(activity, zendeskUrl, appId, oauthClientId);

      val identity: Identity = AnonymousIdentity.Builder().withNameIdentifier(name).withEmailIdentifier(email).build();
      Zendesk.INSTANCE.setIdentity(identity);

      Support.INSTANCE.init(Zendesk.INSTANCE);
      AnswerBot.INSTANCE.init(Zendesk.INSTANCE, Support.INSTANCE);
      Chat.INSTANCE.init(activity, chatAccountKey);

      val answerBotEngine: Engine? = AnswerBotEngine.engine()
      val supportEngine: Engine = SupportEngine.engine()
      val chatEngine: Engine? = ChatEngine.engine()

      MessagingActivity.builder().withEngines(answerBotEngine, supportEngine, chatEngine).show(activity)

      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity;
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }
}

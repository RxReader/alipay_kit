package io.github.v7lin.alipay_kit;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * AlipayKitPlugin
 */
public class AlipayKitPlugin implements FlutterPlugin, ActivityAware {
    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        AlipayKit alipayKit = new AlipayKit(registrar.context(), registrar.activity());
        alipayKit.startListening(registrar.messenger());
    }

    // --- FlutterPlugin

    private final AlipayKit alipayKit;

    public AlipayKitPlugin() {
        alipayKit = new AlipayKit();
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        alipayKit.setApplicationContext(binding.getApplicationContext());
        alipayKit.setActivity(null);
        alipayKit.startListening(binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        alipayKit.stopListening();
        alipayKit.setActivity(null);
        alipayKit.setApplicationContext(null);
    }

    // --- ActivityAware

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        alipayKit.setActivity(binding.getActivity());
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        alipayKit.setActivity(null);
    }
}

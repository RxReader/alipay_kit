package io.github.v7lin.alipay_kit;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.AsyncTask;

import androidx.annotation.NonNull;

import com.alipay.sdk.app.AuthTask;
import com.alipay.sdk.app.PayTask;

import java.lang.ref.WeakReference;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * AlipayKitPlugin
 */
public class AlipayKitPlugin implements FlutterPlugin, ActivityAware, MethodCallHandler {
    //

    private static final String METHOD_ISINSTALLED = "isInstalled";
    private static final String METHOD_PAY = "pay";
    private static final String METHOD_AUTH = "auth";

    private static final String METHOD_ONPAYRESP = "onPayResp";
    private static final String METHOD_ONAUTHRESP = "onAuthResp";

    private static final String ARGUMENT_KEY_ORDERINFO = "orderInfo";
    private static final String ARGUMENT_KEY_AUTHINFO = "authInfo";
    private static final String ARGUMENT_KEY_ISSHOWLOADING = "isShowLoading";

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context applicationContext;
    private Activity activity;

    // --- FlutterPlugin

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getBinaryMessenger(), "v7lin.github.io/alipay_kit");
        channel.setMethodCallHandler(this);
        applicationContext = binding.getApplicationContext();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        channel = null;
        applicationContext = null;
    }

    // --- ActivityAware

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
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
        activity = null;
    }

    // --- MethodCallHandler

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (METHOD_ISINSTALLED.equals(call.method)) {
            boolean isInstalled = false;
            try {
                final PackageManager packageManager = applicationContext.getPackageManager();
                PackageInfo info = packageManager.getPackageInfo("com.eg.android.AlipayGphone", PackageManager.GET_SIGNATURES);
                isInstalled = info != null;
            } catch (PackageManager.NameNotFoundException ignore) {
            }
            result.success(isInstalled);
        } else if (METHOD_PAY.equals(call.method)) {
            final String orderInfo = call.argument(ARGUMENT_KEY_ORDERINFO);
            final boolean isShowLoading = call.argument(ARGUMENT_KEY_ISSHOWLOADING);
            final WeakReference<Activity> activityRef = new WeakReference<>(activity);
            final WeakReference<MethodChannel> channelRef = new WeakReference<>(channel);
            new AsyncTask<String, String, Map<String, String>>() {
                @Override
                protected Map<String, String> doInBackground(String... params) {
                    Activity activity = activityRef.get();
                    if (activity != null && !activity.isFinishing()) {
                        PayTask task = new PayTask(activity);
                        return task.payV2(orderInfo, isShowLoading);
                    }
                    return null;
                }

                @Override
                protected void onPostExecute(Map<String, String> result) {
                    if (result != null) {
                        Activity activity = activityRef.get();
                        MethodChannel channel = channelRef.get();
                        if (activity != null && !activity.isFinishing() && channel != null) {
                            channel.invokeMethod(METHOD_ONPAYRESP, result);
                        }
                    }
                }
            }.execute();
            result.success(null);
        } else if (METHOD_AUTH.equals(call.method)) {
            final String authInfo = call.argument(ARGUMENT_KEY_AUTHINFO);
            final boolean isShowLoading = call.argument(ARGUMENT_KEY_ISSHOWLOADING);
            final WeakReference<Activity> activityRef = new WeakReference<>(activity);
            final WeakReference<MethodChannel> channelRef = new WeakReference<>(channel);
            new AsyncTask<String, String, Map<String, String>>(){
                @Override
                protected Map<String, String> doInBackground(String... strings) {
                    Activity activity = activityRef.get();
                    if (activity != null && !activity.isFinishing()) {
                        AuthTask task = new AuthTask(activity);
                        return task.authV2(authInfo, isShowLoading);
                    }
                    return null;
                }

                @Override
                protected void onPostExecute(Map<String, String> result) {
                    if (result != null) {
                        Activity activity = activityRef.get();
                        MethodChannel channel = channelRef.get();
                        if (activity != null && !activity.isFinishing() && channel != null) {
                            channel.invokeMethod(METHOD_ONAUTHRESP, result);
                        }
                    }
                }
            }.execute();
            result.success(null);
        } else {
            result.notImplemented();
        }
    }
}

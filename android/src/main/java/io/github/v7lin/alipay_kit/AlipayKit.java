package io.github.v7lin.alipay_kit;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.AsyncTask;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.alipay.sdk.app.AuthTask;
import com.alipay.sdk.app.PayTask;

import java.lang.ref.WeakReference;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class AlipayKit implements MethodChannel.MethodCallHandler {
    //

    private static final String METHOD_ISALIPAYINSTALLED = "isAlipayInstalled";
    private static final String METHOD_PAY = "pay";
    private static final String METHOD_AUTH = "auth";

    private static final String METHOD_ONPAYRESP = "onPayResp";
    private static final String METHOD_ONAUTHRESP = "onAuthResp";

    private static final String ARGUMENT_KEY_ORDERINFO = "orderInfo";
    private static final String ARGUMENT_KEY_AUTHINFO = "authInfo";
    private static final String ARGUMENT_KEY_ISSHOWLOADING = "isShowLoading";

    //

    private Context applicationContext;
    private Activity activity;

    private MethodChannel channel;

    public AlipayKit() {
        super();
    }

    public AlipayKit(Context applicationContext, Activity activity) {
        this.applicationContext = applicationContext;
        this.activity = activity;
    }

    //

    public void setApplicationContext(@Nullable Context applicationContext) {
        this.applicationContext = applicationContext;
    }

    public void setActivity(@Nullable Activity activity) {
        this.activity = activity;
    }

    public void startListening(@NonNull BinaryMessenger messenger) {
        channel = new MethodChannel(messenger, "v7lin.github.io/alipay_kit");
        channel.setMethodCallHandler(this);
    }

    public void stopListening() {
        channel.setMethodCallHandler(null);
        channel = null;
    }

    // --- MethodCallHandler

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (METHOD_ISALIPAYINSTALLED.equals(call.method)) {
            boolean isAlipayInstalled = false;
            try {
                final PackageManager packageManager = applicationContext.getPackageManager();
                PackageInfo info = packageManager.getPackageInfo("com.eg.android.AlipayGphone", PackageManager.GET_SIGNATURES);
                isAlipayInstalled = info != null;
            } catch (PackageManager.NameNotFoundException e) {
            }
            result.success(isAlipayInstalled);
        } else if (METHOD_PAY.equals(call.method)) {
            final String orderInfo = call.argument(ARGUMENT_KEY_ORDERINFO);
            final boolean isShowLoading = call.argument(ARGUMENT_KEY_ISSHOWLOADING);
            final WeakReference<Activity> activityRef = new WeakReference<>(activity);
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
                        if (activity != null && !activity.isFinishing()) {
                            if (channel != null) {
                                channel.invokeMethod(METHOD_ONPAYRESP, result);
                            }
                        }
                    }
                }
            }.execute();
            result.success(null);
        } else if (METHOD_AUTH.equals(call.method)) {
            final String authInfo = call.argument(ARGUMENT_KEY_AUTHINFO);
            final boolean isShowLoading = call.argument(ARGUMENT_KEY_ISSHOWLOADING);
            final WeakReference<Activity> activityRef = new WeakReference<>(activity);
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
                        if (activity != null && !activity.isFinishing()) {
                            if (channel != null) {
                                channel.invokeMethod(METHOD_ONAUTHRESP, result);
                            }
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

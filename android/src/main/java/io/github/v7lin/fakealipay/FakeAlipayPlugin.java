package io.github.v7lin.fakealipay;

import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

import com.alipay.sdk.app.AuthTask;
import com.alipay.sdk.app.PayTask;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FakeAlipayPlugin
 */
public class FakeAlipayPlugin implements MethodCallHandler {
    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "v7lin.github.io/fake_alipay");
        FakeAlipayPlugin plugin = new FakeAlipayPlugin(registrar, channel);
        channel.setMethodCallHandler(plugin);
    }

    private static final String METHOD_ISALIPAYINSTALLED = "isAlipayInstalled";
    private static final String METHOD_PAY = "pay";
    private static final String METHOD_AUTH = "auth";

    private static final String METHOD_ONPAYRESP = "onPayResp";
    private static final String METHOD_ONAUTHRESP = "onAuthResp";

    private static final String ARGUMENT_KEY_ORDERINFO = "orderInfo";
    private static final String ARGUMENT_KEY_AUTHINFO = "authInfo";
    private static final String ARGUMENT_KEY_ISSHOWLOADING = "isShowLoading";

    private final Registrar registrar;
    private final MethodChannel channel;

    public FakeAlipayPlugin(Registrar registrar, MethodChannel channel) {
        this.registrar = registrar;
        this.channel = channel;
    }

    @Override
    public void onMethodCall(MethodCall call, final Result result) {
        if (METHOD_ISALIPAYINSTALLED.equals(call.method)) {
            boolean isAlipayInstalled = false;
            try {
                final PackageManager packageManager = registrar.context().getPackageManager();
                PackageInfo info = packageManager.getPackageInfo("com.eg.android.AlipayGphone", PackageManager.GET_SIGNATURES);
                isAlipayInstalled = info != null;
            } catch (PackageManager.NameNotFoundException e) {
            }
            result.success(isAlipayInstalled);
        } else if (METHOD_PAY.equals(call.method)) {
            final String orderInfo = call.argument(ARGUMENT_KEY_ORDERINFO);
            final boolean isShowLoading = call.argument(ARGUMENT_KEY_ISSHOWLOADING);
            Runnable pay = new Runnable() {
                @Override
                public void run() {
                    PayTask task = new PayTask(registrar.activity());
                    final Map<String, String> result = task.payV2(orderInfo, isShowLoading);
                    if (registrar.activity() != null && !registrar.activity().isFinishing()) {
                        registrar.activity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                channel.invokeMethod(METHOD_ONPAYRESP, result);
                            }
                        });
                    }
                }
            };
            new Thread(pay).start();
            result.success(null);
        } else if (METHOD_AUTH.equals(call.method)) {
            final String authInfo = call.argument(ARGUMENT_KEY_AUTHINFO);
            final boolean isShowLoading = call.argument(ARGUMENT_KEY_ISSHOWLOADING);
            Runnable auth = new Runnable() {
                @Override
                public void run() {
                    AuthTask task = new AuthTask(registrar.activity());
                    final Map<String, String> result = task.authV2(authInfo, isShowLoading);
                    if (registrar.activity() != null && !registrar.activity().isFinishing()) {
                        registrar.activity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                channel.invokeMethod(METHOD_ONAUTHRESP, result);
                            }
                        });
                    }
                }
            };
            new Thread(auth).start();
            result.success(null);
        } else {
            result.notImplemented();
        }
    }
}

package io.github.v7lin.alipay_kit;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

import org.junit.Test;

import java.util.HashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * This demonstrates a simple unit test of the Java portion of this plugin's implementation.
 *
 * Once you have built the plugin's example app, you can run these tests from the command
 * line by running `./gradlew testDebugUnitTest` in the `example/android/` directory, or
 * you can run them directly from IDEs that support JUnit such as Android Studio.
 */

public class AlipayKitPluginTest {
  @Test
  public void onMethodCall_setEnv_returnsExpectedValue() {
    AlipayKitPlugin plugin = new AlipayKitPlugin();

    final MethodCall call = new MethodCall("setEnv", new HashMap<String, Object>() {
      {
        put("env", 1);
      }
    });
    MethodChannel.Result mockResult = mock(MethodChannel.Result.class);
    plugin.onMethodCall(call, mockResult);

    verify(mockResult).success(null);
  }
}

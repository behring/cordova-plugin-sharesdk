package behring.cordovasharesdk;

import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.wechat.friends.Wechat;

/**
 * This class ShareSDKPlugin a string called from JavaScript.
 */
public class ShareSDKPlugin extends CordovaPlugin {
    /**
     *  QQ空间
     */
    private final int SSDKPlatformSubTypeQZone = 6;
    /**
     *  邮件
     */
    private final int SSDKPlatformTypeMail = 18;
    /**
     *  短信
     */
    private final int SSDKPlatformTypeSMS = 19;

    /**
     *  拷贝
     */
    private final int SSDKPlatformTypeCopy = 21;

    /**
     *  微信好友
     */
    private final int SSDKPlatformSubTypeWechatSession = 22;

    /**
     *  微信朋友圈
     */
    private final int SSDKPlatformSubTypeWechatTimeline = 23;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        ShareSDK.initSDK(cordova.getActivity());
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        Log.d("ShareSDKPlugin", "action: " + action);
        Log.d("ShareSDKPlugin", "args: " + args);
        if (action.equals("share")) {
            JSONObject shareInfo = new JSONObject(args.getString(0));
            this.share(shareInfo, callbackContext);
            return true;
        }
        return false;
    }

    private void share(JSONObject shareInfo, CallbackContext callbackContext) {
        if (shareInfo != null && shareInfo.length() > 0) {
            switch (shareInfo.optInt("platformType")) {
                case SSDKPlatformSubTypeWechatSession:
                    this.shareToWechat(shareInfo, callbackContext);
                    break;
                default:
                    break;
            }

        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }

    private void shareToWechat(JSONObject shareInfo, final CallbackContext callbackContext) {
        Wechat.ShareParams sp = new Wechat.ShareParams();
        sp.setTitle(shareInfo.optString("title"));
        sp.setText(shareInfo.optString("content"));
        sp.setImagePath((String) shareInfo.optJSONArray("images").opt(0));
        sp.setUrl(shareInfo.optString("url"));
        Platform wechat = ShareSDK.getPlatform(Wechat.NAME);
        wechat.setPlatformActionListener(new PlatformActionListener() {
            @Override
            public void onComplete(Platform platform, int i, HashMap<String, Object> hashMap) {
                //分享成功的回调
                Log.d("ShareSDKPlugin", "onComplete! platform: " + platform + ", action: " + i + ", map: " + hashMap);
                callbackContext.success("分享成功");
            }

            @Override
            public void onError(Platform platform, int i, Throwable throwable) {
                //失败的回调，arg:平台对象，arg1:表示当前的动作，arg2:异常信息
                Log.e("ShareSDKPlugin", "onError! platform: " + platform + ", action: " + i + ", map: " + throwable);
            }

            @Override
            public void onCancel(Platform platform, int i) {
                //取消分享的回调
                Log.d("ShareSDKPlugin", "onCancel! platform: " + platform + ", action: " + i);
            }
        }); // 设置分享事件回调
        // 执行分享
        wechat.share(sp);
    }
}
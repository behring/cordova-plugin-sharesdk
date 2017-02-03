# Cordova Plugin ShareSDK

### 什么是Cordova Plugin ShareSDK

Cordova Plugin ShareSDK封装了[ShareSDK](http://sharesdk.mob.com/)的android和ios平台的分享功能。在hybird app开发中可以方便的完成分享功能。如:ionic2等。目前支持：微信，朋友圈，微博，QQ好友，QQ空间，新浪微博的分享。



### 为什么使用Cordova Plugin ShareSDK 

[ShareSDK](http://sharesdk.mob.com/)几乎完成了所有社交平台的分享功能的封装，但是都是基于原生app、web等。小型创业公司基于成本等其他因素，逐步开始使用hybird混合应用开发，基于html完成app开发，然后用cordova打包构建出各平台app。为了能在hybird app中快速集成分享功能，您需要使用此插件，简单的几行代码就可完成分享功能。



### 如何使用Cordova Plugin ShareSDK

#### cordova项目

1. 进入cordova项目目录。

```powershell
cd ~/yourpath/cordovaproject
```

2. 安装cordova-plugin-sharesdk。

```powershell
cordova plugin add cordova-plugin-sharesdk --variable SHARESDK_ANDROID_APP_KEY=xxxx --variable SHARESDK_IOS_APP_KEY=xxxx --variable WECHAT_APP_ID=xxxx --variable WECHAT_APP_SECRET=xxxx --variable WEIBO_APP_ID=xxxx --variable WEIBO_APP_SECRET=xxxx --variable WEIBO_REDIRECT_URL=http://xxxx --variable QQ_IOS_APP_ID=xxxx --variable QQ_IOS_APP_HEX_ID=xxxx --variable QQ_IOS_APP_KEY=xxxx --variable QQ_ANDROID_APP_ID=xxxx --variable QQ_ANDROID_APP_KEY=xxxx
```

3. 重新构建cordova项目。

```powershell
cordova build
```

4. 通过下面js代码完成分享。

```javascript
/** 分享纯文本 */
function shareText(platformType) {
    var text='这是一条测试文本~~~~';
    var shareInfo = {text:text};
    sharesdk.share(platformType, ShareSDK.ShareType.Text, shareInfo,
                   function(success){},
                   function(fail){});
}

/** 分享图片，多张使用数组 */
function shareImages(platformType) {
    var images = ['https://github.com/zhaolin0801/cordova-sharesdk-demo/blob/master/www/img/Wechat-QRcode.jpeg?raw=true','https://github.com/zhaolin0801/cordova-sharesdk-demo/blob/master/www/img/Wechat-QRcode.jpeg?raw=true'];
    var shareInfo = {images:images};
    sharesdk.share(platformType, ShareSDK.ShareType.Image, shareInfo,
                   function(success){},
                   function(fail){});
}

/** 分享网页 */
function shareWebPage(platformType) {
    var icon = 'https://github.com/zhaolin0801/cordova-sharesdk-demo/blob/master/www/img/Wechat-QRcode.jpeg?raw=true';
    var title = '这是网页的标题';
    var text = '这是网页的内容，android未签名只能分享单张图片到朋友圈';
    var url = 'http://carhot.cn/articles/1';
    var shareInfo = {icon:icon, title:title, text:text, url:url};
    sharesdk.share(platformType, ShareSDK.ShareType.WebPage, shareInfo,
                   function(success){},
                   function(fail){});
}

function shareTextToWechatSession() {
    shareText(ShareSDK.PlatformType.WechatSession);
}

function shareImagesToWechatSession() {
    shareImages(ShareSDK.PlatformType.WechatSession);
}

function shareWebPageToWechatSession() {
    shareWebPage(ShareSDK.PlatformType.WechatSession);
}


function shareTextToWechatTimeline() {
    shareText(ShareSDK.PlatformType.WechatTimeline);
}

function shareImagesToWechatTimeline() {
    shareImages(ShareSDK.PlatformType.WechatTimeline);
}

function shareWebPageToWechatTimeline() {
    shareWebPage(ShareSDK.PlatformType.WechatTimeline);
}
```

5.下面代码判断是否安装响应的客户端

```javascript
/** 是否安装微博客户端 **/
function checkWeiboClient() {
    sharesdk.isInstallClient.promise(ShareSDK.ClientType.SinaWeibo).then(function(isInstall){
        if(isInstall) {
            alert("新浪微博客户端已安装");
        }else {
            alert("未安装新浪微博客户端");
        }
    });
}

/** 是否安装QQ客户端 **/
function checkQQClient() {
    sharesdk.isInstallClient.promise(ShareSDK.ClientType.QQ).then(function(isInstall){
        if(isInstall) {
            alert("QQ客户端已安装");
        }else {
            alert("未安装QQ客户端");
        }
    });
}

/** 是否安装微信客户端 **/
function checkWechatClient() {
    sharesdk.isInstallClient.promise(ShareSDK.ClientType.Wechat).then(function(isInstall){
        if(isInstall) {
            alert("微信客户端已安装");
        }else {
            alert("未安装微信客户端");
        }
    });
}
```



#### ionic2项目

1. 进入ionic2项目目录。

```powershell
cd ~/yourpath/ionicproject
```

2. 安装cordova-plugin-sharesdk。

```powershell
ionic plugin add cordova-plugin-sharesdk --variable SHARESDK_ANDROID_APP_KEY=xxxx --variable SHARESDK_IOS_APP_KEY=xxxx --variable WECHAT_APP_ID=xxxx --variable WECHAT_APP_SECRET=xxxx --variable WEIBO_APP_ID=xxxx --variable WEIBO_APP_SECRET=xxxx --variable WEIBO_REDIRECT_URL=http://xxxx --variable QQ_IOS_APP_ID=xxxx --variable QQ_IOS_APP_HEX_ID=QQxxxx --variable QQ_IOS_APP_KEY=xxxx --variable QQ_ANDROID_APP_ID=xxxx --variable QQ_ANDROID_APP_KEY=xxxx
```

3. 重新构建cordova项目。

```powershell
cordova build
```

> anroid中的微信分享需要审核通过，并且打包release版本。
>
> ```
> cordova build android --release
> ```
>
> andorid打包的app签名一定要和微信开放平台注册的app签名一致！否则无法分享成功。微信开放平台填写的签名必须是**小写字母无分号**格式。
>
> 查看手机上安装的app签名apk[下载地址](http://file3.data.weipan.cn.wscdns.com/28171732/1a592358248a8c3cf185a2f1598abd2ebbece95c?ip=1484656202,117.36.140.26&ssig=54WbKKSkVd&Expires=1484656802&KID=sae,l30zoo1wmz&fn=gen_signature.apk&skiprd=2&se_ip_debug=117.36.140.26&corp=2&from=1221134)



4. 配置cordova-plugin-sharesdk全局变量。在ionic项目的declarations.d.ts文件添加下面2行代码。

```typescript
declare var sharesdk: any;
declare var ShareSDK: any;
```

5. 通过**Cordova项目**第4步中的代码进行分享。

> 因为插件中的变量是cordova注入的，在网页运行会报错，变量为定义。需要做判断处理。
>
> ```typescript
> if("undefined" != typeof ShareSDK){....}
> or
> if("undefined" != typeof sharesdk){....}
> ```



### 关于安装插件参数说明

在第2步添加[cordova-plugin-sharesdk](https://github.com/zhaolin0801/cordova-plugin-sharesdk.git) 插件的时候需要输入对应分享平台的Key和Secret作为参数。参数对应如下表：

| 参数                       | 说明                                       |
| ------------------------ | ---------------------------------------- |
| SHARESDK_IOS_APP_KEY     | [ShareSDK注册(iOS)](http://www.mob.com/)   |
| SHARESDK_ANDROID_APP_KEY | [ShareSDK注册(Android)](http://www.mob.com/) |
| WECHAT_APP_ID            | [微信开放平台注册](https://open.weixin.qq.com/)  |
| WECHAT_APP_SECRET        | [微信开放平台注册](https://open.weixin.qq.com/)  |
| WEIBO_APP_ID             | [新浪微博开放平台注册](http://open.weibo.com/)     |
| WEIBO_APP_SECRET         | [新浪微博开放平台注册](http://open.weibo.com/)     |
| WEIBO_REDIRECT_URL       | 微博回调地址：我的应用/应用信息/高级信息/OAUTH2.0授权设置里配置    |
| QQ_IOS_APP_ID            | [腾讯开放平台注册](http://open.qq.com/)          |
| QQ_IOS_APP_HEX_ID        | 由QQ_IOS_APP_ID生成。 其格式为：”QQ” ＋ AppId的16进制（如果appId转换的16进制数不够8位则在前面补0，如转换的是：5FB8B52，则最终填入为：QQ05FB8B52 注意：转换后的字母要大写） 转换16进制的方法：echo ‘ibase=10;obase=16;801312852′\|bc，其中801312852为QQ的AppID。**传入参数不需要加QQ，只需要传入8位数字** |
| QQ_IOS_APP_KEY           | [腾讯开放平台注册](http://open.qq.com/)          |
| QQ_ANDROID_APP_ID        | [腾讯开放平台注册](http://open.qq.com/)          |
| QQ_ANDROID_APP_KEY       | [腾讯开放平台注册](http://open.qq.com/)          |



### 关于cordova-plugin-cordova中全局变量说明

安装完cordova-plugin-sharesdk后，window下有2个全局变量，sharesdk和ShareSDK。

sharesdk：只提供一个share方法，shareInfo是一个object类型。包含要分享的数据。可用key参考下文。

```javascript
sharesdk.share(platformType, shareType, shareInfo,
                   function(){/**分享成功回调**/},
                   function(msg){/**分享失败或者取消分享回调**/});
```

> 分享失败或取消分享返回msg，msg是**json对象**。通过msg.state判断是取消分享还是分享失败。如果是分享失败。msg.error获取失败信息。



ShareSDK：提供ClientType，PlatformType，ShareType，ResponseState常量。如下表：



| 客户端类型(用于判断是否安装了相应的客户端)        | 说明      |
| ----------------------------- | ------- |
| ShareSDK.ClientType.SinaWeibo | 新浪微博客户端 |
| ShareSDK.ClientType.Wechat    | 微信客户端   |
| ShareSDK.ClientType.QQ        | QQ客户端   |



| 平台类型（分享到指定平台）                        | 说明    |
| ------------------------------------ | ----- |
| ShareSDK.PlatformType.QQFriend       | QQ好友  |
| ShareSDK.PlatformType.QZone（暂不支持）    | QQ空间  |
| ShareSDK.PlatformType.Copy           | 拷贝    |
| ShareSDK.PlatformType.WechatSession  | 微信好友  |
| ShareSDK.PlatformType.WechatTimeline | 微信朋友圈 |
| ShareSDK.PlatformType.SinaWeibo      | 新浪微博  |



| 分享内容类型                     | 说明   |
| -------------------------- | ---- |
| ShareSDK.ShareType.Text    | 文本类型 |
| ShareSDK.ShareType.Image   | 图片类型 |
| ShareSDK.ShareType.WebPage | 网页类型 |



| 分享响应状态                         | 说明   |
| ------------------------------ | ---- |
| ShareSDK.ResponseState.Begin   | 开始分享 |
| ShareSDK.ResponseState.Success | 分享成功 |
| ShareSDK.ResponseState.Fail    | 分享失败 |
| ShareSDK.ResponseState.Cancel  | 取消分享 |

### Demo地址

https://github.com/zhaolin0801/cordova-sharesdk-demo



### 问题

1. Android微信分享需要使用审核通过后的签名文件打包才能分享。
2. 目前仅支持android和ios平台的微信好友、微信朋友前、微博、QQ好友分享以及拷贝链接功能。分享类型包括：纯文本，单张图片，网页。


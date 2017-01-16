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
   cordova plugin add cordova-plugin-sharesdk --save
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

   ​

   #### ionic2项目

   1. 进入ionic2项目目录。

      ```powershell
      cd ~/yourpath/ionicproject
      ```


   1. 安装cordova-plugin-sharesdk。

      ```powershell
      cordova plugin add cordova-plugin-sharesdk --save
      ```

   2. 重新构建cordova项目。

      ```powershell
      cordova build
      ```

   3. 配置cordova-plugin-sharesdk全局变量。在ionic项目的declarations.d.ts文件添加下面2行代码。

      ```typescript
      declare var sharesdk: any;
      declare var ShareSDK: any;
      ```

   4. 通过下面**Cordova项目**第4步中的代码进行分享。

      > 因为插件中的变量是cordova注入的，在网页运行会报错，变量为定义。需要做判断处理。
      >
      > ```typescript
      > if("undefined" != typeof ShareSDK){....}
      > or
      > if("undefined" != typeof sharesdk){....}
      > ```

   ​

   ### 关于cordova-plugin-cordova中全局变量说明

   安装完cordova-plugin-sharesdk后，window下有2个全局变量，sharesdk和ShareSDK。

   1. sharesdk：只提供一个share方法，shareInfo是一个object类型。包含要分享的数据。可用key参考下文。

   ```javascript
   sharesdk.share(platformType, shareType, shareInfo,
                      function(success){},
                      function(fail){});
   ```

   2. ShareSDK：提供platformType，和shareType常量。如下表：

      | platformType类型                       | 说明    |
      | ------------------------------------ | ----- |
      | ShareSDK.PlatformType.QQFriend       | QQ好友  |
      | ShareSDK.PlatformType.QZone          | QQ空间  |
      | ShareSDK.PlatformType.Copy           | 拷贝    |
      | ShareSDK.PlatformType.WechatSession  | 微信好友  |
      | ShareSDK.PlatformType.WechatTimeline | 微信朋友圈 |
      | ShareSDK.PlatformType.SinaWeibo      | 新浪微博  |

      | shareType类型                | 说明   |
      | -------------------------- | ---- |
      | ShareSDK.ShareType.Text    | 文本类型 |
      | ShareSDK.ShareType.Image   | 图片类型 |
      | ShareSDK.ShareType.WebPage | 网页类型 |

   ​

   ### Demo地址

   https://github.com/zhaolin0801/cordova-sharesdk-demo

   ​

   ### 问题

   1. Android微信分享需要使用审核通过后的签名文件打包才能分享。
   2. 目前仅支持android和ios平台的微信分享。包括：纯文本，图片，网页。


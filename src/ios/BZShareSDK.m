#import "BZShareSDK.h"
#import <Cordova/CDVPlugin.h>
//ShareSDK头文件
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//微信SDK头文件
#import "WXApi.h"

@interface BZShareSDK()
@property(strong,nonatomic) NSString* shareSDKiOSAppKey;
@property(strong,nonatomic) NSString* wechatAppId;
@property(strong,nonatomic) NSString* wechatAppSecret;
@property(strong,nonatomic) CDVInvokedUrlCommand* command;
@end

@implementation BZShareSDK
- (void)pluginInitialize
{
    _shareSDKiOSAppKey = [[self.commandDelegate settings] objectForKey:@"sharesdkiosappkey"];
    _wechatAppId = [[self.commandDelegate settings] objectForKey:@"wechatappid"];
    _wechatAppSecret = [[self.commandDelegate settings] objectForKey:@"wechatappsecret"];
    
    NSMutableArray *incomingSocialPlatforms = [NSMutableArray array];
    /**微信分享*/
    [incomingSocialPlatforms addObject:@(SSDKPlatformTypeWechat)];
    
    [self initSocialPlatforms:incomingSocialPlatforms];
}

- (void) initSocialPlatforms:(NSArray*)incomingSocialPlatforms
{
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:_shareSDKiOSAppKey activePlatforms:incomingSocialPlatforms onImport:^(SSDKPlatformType platformType) {
        
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:_wechatAppId appSecret:_wechatAppSecret];
                break;
            default:
                break;
        }
    }];
}

- (void)share:(CDVInvokedUrlCommand*)command
{
    _command = command;
    NSNumber* platformType = [command.arguments objectAtIndex:0];
    NSNumber* shareType = [command.arguments objectAtIndex:1];
    NSDictionary* shareInfo = [command.arguments objectAtIndex:2];
   
    switch ([shareType integerValue]) {
        case SSDKContentTypeText:
            [self shareText:platformType shareInfo:shareInfo];
        break;
        case SSDKContentTypeImage:
            [self shareImages:platformType shareInfo:shareInfo];
        break;
        case SSDKContentTypeWebPage:
            [self shareWebPage:platformType shareInfo:shareInfo];
        break;
        default:
        break;
    }
}


- (void)shareText:(NSNumber *)platformType shareInfo:(NSDictionary *)shareInfo
{
        __block CDVPluginResult* pluginResult = nil;
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:[shareInfo objectForKey:@"text"]
                                         images:nil
                                            url:nil
                                          title:nil
                                           type:SSDKContentTypeText];
        //进行分享
        [ShareSDK share:[platformType integerValue] //传入分享的平台类型
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
         {
             pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"share success"];
             NSLog(@"state: %lu, userData: %@, contentEntity: %@, error: %@",state,userData,contentEntity,error);
             [self.commandDelegate sendPluginResult:pluginResult callbackId:_command.callbackId];
         }];
}
    
- (void)shareImages:(NSNumber *)platformType shareInfo:(NSDictionary *)shareInfo
{
    __block CDVPluginResult* pluginResult = nil;
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:nil
                                     images:[shareInfo objectForKey:@"images"]
                                        url:nil
                                      title:nil
                                       type:SSDKContentTypeImage];
    //进行分享
    [ShareSDK share:[platformType integerValue] //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
    {
         
         pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"share success"];
         NSLog(@"state: %lu, userData: %@, contentEntity: %@, error: %@",state,userData,contentEntity,error);
         [self.commandDelegate sendPluginResult:pluginResult callbackId:_command.callbackId];
     }];
}
    
- (void)shareWebPage:(NSNumber *)platformType shareInfo:(NSDictionary *)shareInfo
{
        __block CDVPluginResult* pluginResult = nil;
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:[shareInfo objectForKey:@"text"]
                                         images:[shareInfo objectForKey:@"icon"]
                                            url:[shareInfo objectForKey:@"url"]
                                          title:[shareInfo objectForKey:@"title"]
                                           type:SSDKContentTypeWebPage];
        //进行分享
        [ShareSDK share:[platformType integerValue] //传入分享的平台类型
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
         {
             
             pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"share success"];
             NSLog(@"state: %lu, userData: %@, contentEntity: %@, error: %@",state,userData,contentEntity,error);
             [self.commandDelegate sendPluginResult:pluginResult callbackId:_command.callbackId];
         }];
}
@end

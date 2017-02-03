#import "BZShareSDK.h"
#import <Cordova/CDVPlugin.h>
//ShareSDK头文件
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

int const SINA_WEIBO_CLIENT = 1;
int const WECHAT_CLIENT = 2;
int const QQ_CLIENT = 3;

@interface BZShareSDK()
@property(strong,nonatomic) NSString* shareSDKiOSAppKey;
@property(strong,nonatomic) NSString* wechatAppId;
@property(strong,nonatomic) NSString* wechatAppSecret;
@property(strong,nonatomic) NSString* weiboAppId;
@property(strong,nonatomic) NSString* weiboAppSecret;
@property(strong,nonatomic) NSString* weiboRedirectUrl;
@property(strong,nonatomic) NSString* qqiOSAppId;
@property(strong,nonatomic) NSString* qqiOSAppKey;
@property(strong,nonatomic) CDVInvokedUrlCommand* command;
@end

@implementation BZShareSDK

- (void)pluginInitialize
{
    _shareSDKiOSAppKey = [[self.commandDelegate settings] objectForKey:@"sharesdkiosappkey"];
    _wechatAppId = [[self.commandDelegate settings] objectForKey:@"wechatappid"];
    _wechatAppSecret = [[self.commandDelegate settings] objectForKey:@"wechatappsecret"];
    _weiboAppId = [[self.commandDelegate settings] objectForKey:@"weiboappid"];
    _weiboAppSecret = [[self.commandDelegate settings] objectForKey:@"weiboappsecret"];
    _weiboRedirectUrl = [[self.commandDelegate settings] objectForKey:@"weiboredirecturl"];
    _qqiOSAppId = [[self.commandDelegate settings] objectForKey:@"qqiosappid"];
    _qqiOSAppKey = [[self.commandDelegate settings] objectForKey:@"qqiosappkey"];
    
    NSMutableArray *incomingSocialPlatforms = [NSMutableArray array];
    /**微信分享*/
    [WXApi registerApp:_wechatAppId];//为了能够判断微信客户端是否安装，必须要注册微信的appid
    [incomingSocialPlatforms addObject:@(SSDKPlatformTypeWechat)];
    /**新浪微博分享*/
    [incomingSocialPlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    /**QQ分享 目前仅有QQ好友分享，不支持Qzone*/
    [incomingSocialPlatforms addObject:@(SSDKPlatformTypeQQ)];
    
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
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
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
            case SSDKPlatformTypeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                [appInfo SSDKSetupSinaWeiboByAppKey:_weiboAppId
                                          appSecret:_weiboAppSecret
                                        redirectUri:_weiboRedirectUrl
                                           authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:_qqiOSAppId
                                     appKey:_qqiOSAppKey
                                   authType:SSDKAuthTypeBoth];
                break;
            default:
                break;
        }
    }];
}

- (void)isInstallClient:(CDVInvokedUrlCommand*)command
{
    BOOL isInstallClient = NO;
    CDVPluginResult* pluginResult = nil;
    _command = command;
    NSNumber* clientType = [command.arguments objectAtIndex:0];
    switch ([clientType integerValue]) {
        case SINA_WEIBO_CLIENT:
            isInstallClient = [WeiboSDK isWeiboAppInstalled];
            break;
        case WECHAT_CLIENT:
            isInstallClient = [WXApi isWXAppInstalled];
            break;
        case QQ_CLIENT:
            isInstallClient = [QQApiInterface isQQInstalled];
            break;
        default:
            break;
    }
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:isInstallClient];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:_command.callbackId];
}

- (void)share:(CDVInvokedUrlCommand*)command
{
    _command = command;
    NSNumber* platformType = [command.arguments objectAtIndex:0];
    NSNumber* shareType = [command.arguments objectAtIndex:1];
    NSDictionary* shareInfo = [command.arguments objectAtIndex:2];
    
    switch ([shareType integerValue]) {
        case SSDKContentTypeText:
            if([platformType integerValue] == SSDKPlatformTypeCopy) {
                [self copyLink:shareInfo];
            }else {
                [self shareText:platformType shareInfo:shareInfo];
            }
            break;
        case SSDKContentTypeImage:
            [self shareImage:platformType shareInfo:shareInfo];
            break;
        case SSDKContentTypeWebPage:
            [self shareWebPage:platformType shareInfo:shareInfo];
            break;
        default:
            break;
    }
}

- (void)copyLink:(NSDictionary *)shareInfo
{
    CDVPluginResult* pluginResult = nil;
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [shareInfo objectForKey:@"text"];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:_command.callbackId];
}

- (void)shareText:(NSNumber *)platformType shareInfo:(NSDictionary *)shareInfo
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:[shareInfo objectForKey:@"text"]
                                     images:nil
                                        url:nil
                                      title:nil
                                       type:SSDKContentTypeText];
    //使用客户端分享，如果没有安装客户端，使用网页分享（对于新浪微博）
    [shareParams SSDKEnableUseClientShare];
    //进行分享
    [ShareSDK share:[platformType integerValue] //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
     {
         [self returnStateToTrigger:state error:error];
     }];
}

- (void)shareImage:(NSNumber *)platformType shareInfo:(NSDictionary *)shareInfo
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:nil
                                     images:[shareInfo objectForKey:@"image"]
                                        url:nil
                                      title:nil
                                       type:SSDKContentTypeImage];
    //使用客户端分享，如果没有安装客户端，使用网页分享（对于新浪微博）
    [shareParams SSDKEnableUseClientShare];
    //进行分享
    [ShareSDK share:[platformType integerValue] //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
     {
         [self returnStateToTrigger:state error:error];
     }];
}

- (void)shareWebPage:(NSNumber *)platformType shareInfo:(NSDictionary *)shareInfo
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:[shareInfo objectForKey:@"text"]
                                     images:[shareInfo objectForKey:@"icon"]
                                        url:[shareInfo objectForKey:@"url"]
                                      title:[shareInfo objectForKey:@"title"]
                                       type:SSDKContentTypeWebPage];
    //使用客户端分享，如果没有安装客户端，使用网页分享（对于新浪微博）
    [shareParams SSDKEnableUseClientShare];
    //进行分享
    [ShareSDK share:[platformType integerValue] //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
     {
         [self returnStateToTrigger:state error:error];
     }];
}

-(void)returnStateToTrigger:(SSDKResponseState)state error:(NSError *)error {
    CDVPluginResult* pluginResult = nil;
    if(state == SSDKResponseStateSuccess) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }else {
        if(error) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:@{@"state":[NSNumber numberWithInt:state], @"error":[error localizedDescription]}];
        }else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:@{@"state":[NSNumber numberWithInt:state]}];
        }
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:_command.callbackId];
}
@end

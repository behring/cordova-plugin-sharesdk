/**
 * @module ShareSDK
 * 平台类型
 *平台和分享类型的值参考ShareSDK ios源码中的值
 */
module.exports = {

    PlatformType: {
        /** QQ好友 */
        QQFriend: 24,
        /** QQ空间 */
        QZone: 6,
        /** 拷贝 */
        Copy: 21,
        /** 微信好友 */
        WechatSession: 22,
        /** 微信朋友圈 */
        WechatTimeline: 23,
        /** 新浪微博 */
        SinaWeibo: 1

    },
    /**
     * 分享类型
     */
    ShareType: {
        /** 文本 */
        Text: 1,
        /** 图片 */
        Image: 2,
        /** 网页 */
        WebPage: 3
    }
};
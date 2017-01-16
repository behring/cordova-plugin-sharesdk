/* global cordova */
var share = module.exports = function (platformType, shareType, shareInfo, success, fail) {
  cordova.exec(success, fail, 'ShareSDK', 'share', [platformType, shareType ,shareInfo])
}

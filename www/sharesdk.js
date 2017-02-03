/**
 * @exports sharesdk
 */
var sharesdkExport = {};


sharesdkExport.share = function (platformType, shareType, shareInfo, success, fail) {
  cordova.exec(success, fail, 'ShareSDK', 'share', [platformType, shareType ,shareInfo])
};

sharesdkExport.isInstallClient = function (clientType, success, fail) {
  cordova.exec(success, fail, 'ShareSDK', 'isInstallClient', [clientType])
};

sharesdkExport.isInstallClient.promise = function (clientType) {
  return new Promise(function (resolve, reject) {
    sharesdkExport.isInstallClient(clientType, resolve, reject)
  })
};

module.exports = sharesdkExport;
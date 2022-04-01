//
//  SharingHelper.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 20/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation
import SDWebImage
import MessageUI

enum SharingType: String {
    case iMessage
    case WhatsApp
    case Messenger
    case Snapchat
    case Skype
    case Viber
    case WeChat
    case QQMobile = "QQ Mobile"
    case Line
    case Telegram
    case More
    
    var image: UIImage {
        switch self {
        case .iMessage:
            return R.image.share_icon_imessage()!
        case .WhatsApp:
            return R.image.share_icon_whatsup()!
        case .Messenger:
            return R.image.share_icon_messenger()!
        case .Snapchat:
            return R.image.share_icon_snapchat()!
        case .Skype:
            return R.image.share_icon_skype()!
        case .Viber:
            return R.image.share_icon_viber()!
        case .WeChat:
            return R.image.share_icon_wechat()!
        case .QQMobile:
            return R.image.share_icon_qq()!
        case .Line:
            return R.image.share_icon_line()!
        case .Telegram:
            return R.image.share_icon_telegram()!
        case .More:
            return R.image.share_icon_more()!
        }
    }
    
    var urlScheme: String {
        switch self {
        case .WhatsApp:
            return "whatsapp://"
        case .Messenger:
            return "fb-messenger://"
        case .Snapchat:
            return "snapchat://"
        case .Skype:
            return "skype://"
        case .Viber:
            return "viber://"
        case .WeChat:
            return "wechat://"
        case .QQMobile:
            return "mqq://"
        case .Line:
            return "line://"
        case .Telegram:
            return "telegram://"
        default:
            return ""
        }
    }
    
    var appStoreLink: String {
        switch self {
        case .WhatsApp:
            return "https://itunes.apple.com/us/app/whatsapp-messenger/id310633997?mt=8"
        case .Messenger:
            return "https://itunes.apple.com/us/app/messenger/id454638411?mt=8"
        case .Snapchat:
            return "https://itunes.apple.com/us/app/snapchat/id447188370?mt=8"
        case .Skype:
            return "https://itunes.apple.com/us/app/skype-for-iphone/id304878510?mt=8"
        case .Viber:
            return "https://itunes.apple.com/us/app/viber-messenger-text-call/id382617920?mt=8"
        case .WeChat:
            return "https://itunes.apple.com/us/app/wechat/id414478124?mt=8"
        case .QQMobile:
            return "https://itunes.apple.com/us/app/qq/id444934666?mt=8"
        case .Line:
            return "https://itunes.apple.com/us/app/line/id443904275?mt=8"
        case .Telegram:
            return "https://itunes.apple.com/us/app/telegram-messenger/id686449807?mt=8"
        default:
            return ""
        }
    }
    
    var sharingExtensionBundle: String {
        switch self {
        case .iMessage:
            return "com.apple.mobilesms.compose"
        case .WhatsApp:
            return "net.whatsapp.WhatsApp.ShareExtension"
        case .Messenger:
            return "com.facebook.Messenger.ShareExtension"
        case .Snapchat:
            return "com.toyopagroup.picaboo.share"
        case .Skype:
            return "com.skype.skype.sharingextension"
        case .Viber:
            return "com.viber.app-share-extension"
        case .WeChat:
            return "com.tencent.xin.sharetimeline"
        case .QQMobile:
            return "com.tencent.mqq.ShareExtension"
        case .Line:
            return "jp.naver.line.Share"
        case .Telegram:
            return "ph.telegra.Telegraph.Share"
        default:
            return ""
        }
    }
}

class SharingHelper: NSObject {
    
    static var shared = SharingHelper()
    
    class func share(toType: SharingType, filenameURLString: String, presenter: UIViewController, completion: (() -> Void)?) {
        guard var fileCachedPath = SDImageCache.shared().defaultCachePath(forKey: filenameURLString) else {
            guard let completion = completion else { return }
            completion()
            return
        }
        if fileCachedPath.hasSuffix(".png"), (toType == .iMessage || toType == .Telegram || toType == .Snapchat) {
            var image: UIImage!
            if toType == .Snapchat, let tmp = UIImage(contentsOfFile: fileCachedPath) {
                image = tmp.rotated(by: Measurement(value: 450.0, unit: .degrees))
            } else {
                image = UIImage(contentsOfFile: fileCachedPath)
            }
            if let newImageWithWhiteBackground = image,
                let imageData = newImageWithWhiteBackground.jpegData(compressionQuality: 1) {
                var newFileUrl = URL(fileURLWithPath: fileCachedPath.replacingOccurrences(of: ".png", with: ".jpg"))
                fileCachedPath = newFileUrl.path
                do {
                    var resourceValues = URLResourceValues()
                    resourceValues.isExcludedFromBackup = true
                    try imageData.write(to: newFileUrl, options: .atomic)
                    try newFileUrl.setResourceValues(resourceValues)
                } catch {
                    print(error.localizedDescription)
                    guard let completion = completion else { return }
                    completion()
                    return
                }
            }
        }
        switch toType {
        case .More:
            defaultSharing(filepath: fileCachedPath, presenter: presenter)
        case .iMessage:
            AnalyticsService.log(.iMessageStart)
            let newPath = URL(fileURLWithPath: fileCachedPath)
            let controller = MFMessageComposeViewController()
            controller.messageComposeDelegate = SharingHelper.shared
            controller.addAttachmentURL(newPath, withAlternateFilename: nil)
            presenter.present(controller, animated: true, completion: nil)
        default:
            share(toType: toType, filepath: fileCachedPath, completion: completion)
        }
    }
    
    class func share(toType: SharingType, filepath: String, completion: (() -> Void)?) {
        let newPath = NSURL(fileURLWithPath: filepath)
        guard let executor = LNExtensionExecutor(extensionBundleIdentifier: toType.sharingExtensionBundle) else { return }
        executor.execute(withInputItems: [newPath], completionHandler: { _, _, _  in }, presentCompletionHandler: {
            guard let completion = completion else { return }
            completion()
        })
    }
    
    class func defaultSharing(filepath: String, presenter: UIViewController) {
        let newPath = NSURL(fileURLWithPath: filepath)
        let activityItems = [newPath]
        let actionController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        presenter.present(actionController, animated: true, completion: nil)
    }
    
}

extension SharingHelper: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

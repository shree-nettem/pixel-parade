//
//  AnalyticEvent.swift
//  Pixel-parade
//
//  Created by Mikhail Muzhev on 01/08/2019.
//  Copyright © 2019 Live Typing. All rights reserved.
//

import Foundation

struct AnalyticEvent {
    let eventName: String
    let eventParameters: [String: Any]?
}

enum AnalyticEventType {

    enum Source: String {
        case iMessage, main, photo
    }

    enum StickerType: String {
        case gif, png, jpg
    }

    enum PhotoSource {
        case camera, lib, cancel

        var string: String {
            switch self {
            case .camera:
                return "camera"
            case .lib:
                return "lib"
            case .cancel:
                return "cancel"
            }
        }
    }

    case appFirstLaunch
    case sessionStart
    case iMessageStart
    case restorePurchases

    case getPack(name: String, packSize: Int32)
    case buyPack(name: String, packSize: Int32, packCost: Double)
    case packDownloaded(name: String, packSize: Int32, packCost: Double)
    case emailPopup
    case emailClosed(isEmailProvided: Bool)
    case linkClicked(name: String, packSize: Int32, link: String)

    case packOpened(name: String, packSize: Int32, source: Source)
    case goHome(source: Source)
    case stickerOpened(packName: String, packSize: Int32, stickerNumber: Int32, stickerType: StickerType)
    case quickShare(packName: String, packSize: Int32, stickerNumber: Int32, stickerType: StickerType, shareButtonName: String)
    case standardShare(packName: String, packSize: Int32, stickerNumber: Int32, stickerType: StickerType)
    
    case photoFeature
    case photoDialog(source: PhotoSource)
    case stickerToPhoto(packName: String, packSize: Int32, stickerNumber: Int, stickerType: StickerType)
    case photoShare
    
    case searchFeature
    case searchResults(input: String)
    case searchTag(input: String)

    var value: AnalyticEvent {
        let eventName: String
        let eventParameters: [String: Any]?
        switch self {
        case .appFirstLaunch:
            eventName = "Launch_first_time"
            eventParameters = nil
        case .sessionStart:
            eventName = "Session_start"
            eventParameters = nil
        case .iMessageStart:
            eventName = "iMessage_start"
            eventParameters = nil
        case .restorePurchases:
            eventName = "Restore_purchases"
            eventParameters = nil
        case .getPack(let name, let packSize):
            eventName = "Get_pack"
            eventParameters = ["pack_name": name, "pack_size": packSize]
        case .buyPack(name: let name, packSize: let packSize, packCost: let packCost):
            eventName = "Buy_pack"
            eventParameters = ["pack_name": name, "pack_size": packSize, "pack_cost": packCost]
        case .packDownloaded(name: let name, packSize: let packSize, packCost: let packCost):
            eventName = "Pack_downloaded"
            eventParameters = ["pack_name": name, "pack_size": packSize, "pack_cost": packCost]
        case .emailPopup:
            eventName = "Email_popup"
            eventParameters = nil
        case .emailClosed(let isEmailProvided):
            eventName = "Email_closed"
            eventParameters = ["email_provided": isEmailProvided]
        case .linkClicked(name: let name, packSize: let packSize, link: let link):
            eventName = "Link_clicked"
            eventParameters = ["pack_name": name, "pack_size": packSize, "link": link]
        case .packOpened(name: let name, packSize: let packSize, source: let source):
            eventName = "Pack_opened"
            eventParameters = ["pack_name": name, "pack_size": packSize, "source": source.rawValue]
        case .goHome(source: let source):
            eventName = "Go_home"
            eventParameters = ["source": source.rawValue]
        case .stickerOpened(packName: let packName, packSize: let packSize, stickerNumber: let stickerNumber, stickerType: let stickerType):
            eventName = "Sticker_opened"
            eventParameters = ["pack_name": packName,
                               "pack_size": packSize,
                               "sticker_number": stickerNumber,
                               "sticker_type": stickerType.rawValue]
        case .quickShare(packName: let packName, packSize: let packSize, stickerNumber: let stickerNumber, stickerType: let stickerType, shareButtonName: let shareButtonName):
            eventName = "Quick_share"
            eventParameters = ["pack_name": packName,
                               "pack_size": packSize,
                               "sticker_number": stickerNumber,
                               "sticker_type": stickerType.rawValue,
                               "share_button_name": shareButtonName]
        case .standardShare(packName: let packName, packSize: let packSize, stickerNumber: let stickerNumber, stickerType: let stickerType):
            eventName = "Standard_share"
            eventParameters = ["pack_name": packName,
                               "pack_size": packSize,
                               "sticker_number": stickerNumber,
                               "sticker_type": stickerType.rawValue]
        case .photoFeature:
            eventName = "Photo_feature"
            eventParameters = nil
        case .photoDialog(source: let source):
            eventName = "Photo_dialog"
            eventParameters = ["source": source.string]
        case .stickerToPhoto(packName: let packName, packSize: let packSize, stickerNumber: let stickerNumber, stickerType: let stickerType):
            eventName = "Sticker_to_photo"
            eventParameters = ["pack_name": packName,
                               "pack_size": packSize,
                               "sticker_number": stickerNumber,
                               "sticker_type": stickerType.rawValue]
        case .photoShare:
            eventName = "Photo_share"
            eventParameters = nil
        case .searchFeature:
            eventName = "Search_feature"
            eventParameters = nil
        case .searchResults(input: let input):
            eventName = "Search_results"
            eventParameters = ["input": input]
        case .searchTag(input: let input):
            eventName = "Search_tag"
            eventParameters = ["input": input]
        }
        return AnalyticEvent(eventName: eventName, eventParameters: eventParameters)
    }

}

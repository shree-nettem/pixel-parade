//
//  NSAttributedString+Styles.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 30/04/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

enum StringStyle {
    
    case text(TextStyle)
    
    enum TextStyle {
        case mainTitle(TextColor)
        case title(TextColor)
        case subTitle(TextColor)
        case description(TextColor)
        case button(TextColor)
    }
    
    enum TextColor {
        case ppAquaBlue
        case ppGray
        case ppBlack
        case ppDeepSkyBlue
        case ppWhite
        case darkGreenBlue
    }
}

extension NSAttributedString {
    
    convenience init(string: String, style: StringStyle) {
        let attributes: [NSAttributedString.Key: Any]!
        switch style {
        case .text(let substyle):
            attributes = StringStyles.text(substyle)
        }
        self.init(string: string, attributes: attributes)
    }
}

// MARK: - Styles

class StringStyles {
    
    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
    static func text(_ style: StringStyle.TextStyle) -> [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = [:]
        
        switch style {
        case .mainTitle(let color):
            switch color {
            case .ppAquaBlue:
                attributes = [
                    .foregroundColor: UIColor.ppAquaBlue,
                    .font: R.font.sfuiDisplayHeavy(size: 24)!
                ]
            default:
                break
            }
        case .title(let color):
            switch color {
            case .ppAquaBlue:
                attributes = [
                    .foregroundColor: UIColor.ppAquaBlue,
                    .font: R.font.sfuiDisplayHeavy(size: 18)!
                ]
            case .ppBlack:
                attributes = [
                    .foregroundColor: UIColor.ppBlack,
                    .font: R.font.sfuiDisplayHeavy(size: 16)!
                ]
            default:
                break
            }
        case .subTitle(let color):
            switch color {
            case .ppBlack:
                attributes = [
                    .foregroundColor: UIColor.ppBlack,
                    .font: R.font.sfuiDisplayBold(size: 12)!
                ]
            default:
                break
            }
        case .description(let color):
            switch color {
            case .ppGray:
                attributes = [
                    .foregroundColor: UIColor.ppGray,
                    .font: R.font.sfuiDisplayRegular(size: 13)!
                ]
            case .ppBlack:
                attributes = [
                    .foregroundColor: UIColor.ppBlack,
                    .font: UIFont.systemFont(ofSize: 14)
                ]
            default:
                break
            }
        case .button(let color):
            switch color {
            case .ppDeepSkyBlue:
                attributes = [
                    .foregroundColor: UIColor.ppDeepSkyBlue,
                    .font: R.font.varelaRoundRegular(size: 14)!
                ]
            case .ppWhite:
                attributes = [
                    .foregroundColor: UIColor.ppWhite,
                    .font: R.font.varelaRoundRegular(size: 14)!
                ]
            case .darkGreenBlue:
                let paragraphStyle = NSParagraphStyle()
                attributes = [
                    .paragraphStyle: paragraphStyle.addAligment(.center),
                    .foregroundColor: UIColor.ppDarkGreenBlue,
                    .font: R.font.varelaRoundRegular(size: 14)!
                ]
            default:
                break
            }
        }
        return attributes
    }
    // swiftlint:enable cyclomatic_complexity
    // swiftlint:enable function_body_length
    
}

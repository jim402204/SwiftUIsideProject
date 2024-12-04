//
//  UIColor+.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/3.
//

import UIKit
import SwiftUI

extension UIColor {
    //使用 CASE 取值
    static func appColor(_ type: AssetsColor) -> UIColor {
        return UIColor(named: "\(type)") ?? .white
    }
    
    static func assets(_ color: AssetsColor) -> UIColor {
        return UIColor(hex: color.rawValue)
    }
}

extension Color {
    //使用 CASE 取值
    static func app(_ type: AssetsColor) -> Color {
        Color("\(type)")
    }
}

extension UIColor {
    
    convenience init(hex: String) {
        
        let scanner = Scanner(string: hex)
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
    convenience init(hex: String,alpha:CGFloat) {
        
        let scanner = Scanner(string: hex)
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: alpha
        )
    }
}

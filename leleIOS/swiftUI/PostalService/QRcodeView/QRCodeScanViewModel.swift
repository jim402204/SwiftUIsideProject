//
//  QRCodeScanViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2025/1/7.
//

import SwiftUI
import Combine
import CoreImage.CIFilterBuiltins

class QRCodeScanViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var qrCodeImage: UIImage?
    @Published var originalBrightness: CGFloat = UIScreen.main.brightness
    @Published var isBrightness: Bool = false
    
    
    init() {
        
        if let deviceID = UserDefaultsHelper.deviceID {
            generateQRCode(from: deviceID)
        }
    }
    
    func generateQRCode(from string: String) {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            qrCodeImage = UIImage(cgImage: cgImage)
        }
    }
    
    func activateCode(_ code: String) {
        // 在此處添加激活序號的邏輯
        print("Activating code: \(code)")
        generateQRCode(from: code)
    }
    
    func handleBrightnessChange(isOn: Bool) {
        if isOn {
            // 儲存原始亮度並調整到最大
            originalBrightness = UIScreen.main.brightness
            UIScreen.main.brightness = 1.0
        } else {
            // 關閉時恢復原亮度
            UIScreen.main.brightness = originalBrightness
        }
    }
    
    func restoreOriginalBrightness() {
        // 手動恢復原亮度
        UIScreen.main.brightness = originalBrightness
        isBrightness = false // 重置開關狀態
    }
}

//
//  FastRegisterPackageViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/26.
//

import UIKit
import Observation
import Foundation

@Observable
class FastRegisterPackageViewModel {
    
    var loadingManager = LoadingManager.shared
    var reflushList: Bool = false
    
    var imageData: Data? {
        didSet {
            guard let imageData = imageData else { return }
            self.callAPI(imageData: imageData)
        }
    }
    var packageID: Int? = nil
    var labelIdModel: LabelIdentificModel? = nil
    
    
    func callAPI(imageData: Data) {
//        var imageDataTest = testImagePNG()
        
        loadingManager.isLoading = true
        
        Task {
            guard let model = try? await apiService.requestA(NotifyApi.BedrockLabelIdentific(imageData: imageData)) else {
                loadingManager.isLoading = false
                return
            }
            self.labelIdModel = model
            
            self.registerPackageAPI()
        }
    }
        
    func getPackageIDAPI() {
        
        Task {
            guard let model = try? await apiService.requestA(CommunityManagerApi.GeneratePackageID()) else { return }
            self.packageID = model.id
        }
    }
    
    func registerPackageAPI() {
        
//        guard let packageID = self.packageID else { return }
        
        guard let labelIdModel = self.labelIdModel else {
            loadingManager.isLoading = false
            return
        }
        
        guard let result = extractBuildingInfo(from: labelIdModel.houseHold) else {
            loadingManager.isLoading = false
            return
        }
        print("棟: \(result.棟), 號: \(result.號), 樓: \(result.樓)")
        
        let houseHold = HouseHold(building: result.棟, doorPlate: result.號, floor: result.樓)
        
        Task {
            do {
                async let sendAPI1 = apiService.requestA(CommunityManagerApi.GeneratePackageID())
                
                let model1 = try await sendAPI1
                let packageID = model1.id
                
                let packageType = "packagetype.package"
                
                let _ = try await apiService.requestARow(
                    CommunityManagerApi.RegisterPackage(
                        packageID: packageID,
                        recipient: nil,
                        type: packageType,
                        other: labelIdModel.name,
                        userList: [],
                        houseHold: houseHold
                    )
                )
                
                reflushList.toggle()
                loadingManager.isLoading = false
                
            } catch {
                loadingManager.isLoading = false
                print(error)
            }
        }
    }
    
    /// 提取「棟」、「號」、「樓」的數字
    /// - Parameter address: 包含地址信息的字符串
    /// - Returns: 返回一個元組，包含棟號、門牌號和樓層，若無法提取則返回 nil
    func extractBuildingInfo(from address: String) -> (棟: String, 號: String, 樓: String)? {
        // 定義正則表達式
        let pattern = "([A-Za-z0-9]+)棟.*?([A-Za-z0-9]+)號.*?([A-Za-z0-9]+)樓"
        
        // 嘗試建立正則表達式
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            print("正則表達式無效")
            return nil
        }
        
        // 匹配範圍
        let range = NSRange(location: 0, length: address.utf16.count)
        
        // 嘗試匹配
        if let match = regex.firstMatch(in: address, options: [], range: range) {
            let 棟 = (address as NSString).substring(with: match.range(at: 1))
            let 號 = (address as NSString).substring(with: match.range(at: 2))
            let 樓 = (address as NSString).substring(with: match.range(at: 3))
            return (棟+"棟", 號+"號", 樓+"樓")
        } else {
            print("未能匹配到任何結果")
            return nil
        }
    }
    
}


extension FastRegisterPackageViewModel {
    
    func testImagePNG() -> Data {
        
        var imageDataTest = Data()
        
        // 示例：读取 testPackage.png 图片
        if let pngData = validateAndConvertToPNG(named: "testPackage") {
            print("图片数据加载成功，大小为: \(pngData.count) 字节")
            if let jpegData = convertToJPEG(data: pngData) {
                imageDataTest = jpegData
            }
//            imageDataTest = pngData
        } else {
            print("图片数据加载失败")
        }
        
        return imageDataTest
    }
        
    func convertToJPEG(data: Data) -> Data? {
        guard let image = UIImage(data: data) else {
            print("无法将图片数据转换为 UIImage")
            return nil
        }
        return image.jpegData(compressionQuality: 0.7) // 压缩质量可以调整
    }
    
    
}

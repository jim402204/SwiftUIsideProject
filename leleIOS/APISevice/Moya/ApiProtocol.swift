//
//  ApiProtocol.swift
//  vxu
//
//  Created by 江俊瑩 on 2022/3/4.
//

import Foundation
import Moya

enum BuildingType {
    case develop
    case produce
}

#if DEBUG
    var apiDomain = "https://go.lelelink.com"
    let buildingType: BuildingType = .develop

#else
    var apiDomain = "https://api.coursepass.tw"
    let buildingType: BuildingType = .produce
#endif


/// 預先指定response的data type
protocol DecodableResponseTargetType: TargetType {
    associatedtype ResponseDataType: Codable
}

/// API的共用protocol，設定API共用參數，且api的response皆要可以被decode
protocol ApiTargetType: DecodableResponseTargetType {
    var timeout: TimeInterval { get }
}


let leleGoLinkURL = URL(string: ("https://go.lelelink.com"))!

let leleApiURL5026 = URL(string: ("https://lele-api.ez-ai.com.tw:5026"))!

let leleApiURL = URL(string: ("https://api.lelelink.com"))!

let imageApiDomain = "https://api.happylink.com.tw"

/// 共用參數
extension ApiTargetType {
    var baseURL: URL { return leleGoLinkURL }
    var path: String { fatalError("path for ApiTargetType must be override") }
    var method: Moya.Method { return .get }
    var headers: [String : String]? { return nil }
    var task: Task { return .requestPlain }
//    var sampleData: Data { return Data() }
    var timeout: TimeInterval { return 20 }
}

/// 來用打印dev log
func ifDebug(block: (()->())? = nil) {
    
//    #if DEVELOPMENT || TEST
    #if DEBUG
        block?()
    #else
    #endif
}


// class 轉換dict
protocol Convertable: Codable {}

extension Convertable {
    /// 直接将Struct或Class转成Dictionary
    func convertToDict() -> Dictionary<String, Any>? {
        var dict: Dictionary<String, Any>? = nil
        
        do {
            let data = try JSONEncoder().encode(self)
            
            dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
        } catch {
            debugPrint(error)
        }
        
        return dict
    }
}

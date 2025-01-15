//
//  HomeApi.swift
//  CoursePass
//
//  Created by 江俊瑩 on 2022/8/3.
//

import Moya
import Foundation

/// API的共用protocol  ，設定共用參數，且response皆要可以被decode
protocol BaseTargetType: ApiTargetType {}

let deviceType = "ios"

/// 添加這個head的API 不要顯示hub 做loading的動作
var needShowHub: String { "noHub" }

/// 共用參數
extension BaseTargetType {
        
    var headers: [String : String]? {
        return [
            "Content-Type" : "application/json",
            "Device-Type" : deviceType,
            "Accept" : "application/json",
            "Authorization" : "Bearer \(UserDefaultsHelper.token ?? "")"
        ]
    }
    
    typealias defaultModel = [String:String]
}

enum HomeApi {
    
}

protocol NoBearerTargetType: ApiTargetType {}

/// 共用參數
extension NoBearerTargetType {
        
    var headers: [String : String]? {
        return [
            "Content-Type" : "application/json",
            "Device-Type" : deviceType,
            "Accept" : "application/json"
        ]
    }
    
    typealias defaultModel = [String:String]
}

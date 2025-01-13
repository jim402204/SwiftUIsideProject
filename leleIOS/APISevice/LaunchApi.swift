//
//  File.swift
//  vxu
//
//  Created by 江俊瑩 on 2022/3/4.
//

import Moya
import Foundation
import UIKit
import DeviceKit

enum LaunchApi {
    
    //MARK: - UserInfo
    struct UserInfo: BaseTargetType {
        typealias ResponseDataType = UserInfoModel

        var baseURL: URL { return leleApiURL }
        var path: String { return "user/info" }
    }
    
    //MARK: - DeviceInfo
    struct DeviceInfo: BaseTargetType {
        typealias ResponseDataType = DeviceModel
        
        var method: Moya.Method { .post }
        var path: String { return "user/device_info" }
        var task: Task { .requestParameters(parameters: parameters, encoding: JSONEncoding.default) }
        private var parameters: [String:Any] = [:]
    
        init() {
            let uuid = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
            
            parameters["UID"] = uuid
            parameters["Type"] = "iOS"
            parameters["Model"] = DeviceObject.shared.deviceName
            parameters["Version"] = UIDevice.current.systemVersion
            parameters["FCM"] = "FCM token"
            parameters["Lat"] = Double.zero
            parameters["Lng"] = Double.zero
            parameters["GeoTime"] = Date().ISO8601Format()
            
//            let input: [String: Any] = [
//                    "UID": "8AC76436-872C-47BC-8493-5134CA588E8B",
//                    "Type": "iOS",
//                    "Model": "iPhone 15",
//                    "Version": "17.5",
//                    "FCM": "",
//                    "Lat": 37.785834,
//                    "Lng": -122.406417,
//                    "GeoTime": "2024-11-25T02:44:54.400Z"
//                ]
//            
//            parameters = input
        }
    }
    
    //MARK: - HouseholdList  首頁資訊
    struct HouseholdList: BaseTargetType {
        typealias ResponseDataType = [HouseholdListModel]

        var baseURL: URL { return leleApiURL }
        var path: String { return "user/household_list" }
    }
    
    
    //MARK: - 註冊 不能用
    struct Register: BaseTargetType {
        typealias ResponseDataType = String
        
//        var baseURL: URL { return leleApiURL }
        var method: Moya.Method { .post }
        var path: String { return "user" }
        var task: Task { .requestCompositeParameters(bodyParameters: parameters, bodyEncoding: JSONEncoding.default, urlParameters: urlParameters) }

        private var parameters: [String:Any] = [:]
        private var urlParameters: [String:Any] = [:]
        /// 登出是拿 device id給server
        init(account: String, name: String, email: String, password: String, smsCode: String) {
            parameters["AccountID"] = account
            parameters["Name"] = name
            parameters["Email"] = email
            parameters["Password"] = password
            //sms 序號
            urlParameters["c"] = smsCode
            //測試帳號 Jim A1棟1號6樓
        }
    }
    
    //MARK: - 驗證碼
    struct SendSms: BaseTargetType {
        typealias ResponseDataType = String
        
        var baseURL: URL { return leleApiURL } //現在有時間過程的問題 超過20分還是無法重新打
        var method: Moya.Method { .post }
        var path: String { return "sendsms/" } //必須要加/不然會跳到轉址 且url拼接是sendsms?p=0920217339
 
        var task: Task { .requestCompositeParameters(bodyParameters: [:], bodyEncoding: JSONEncoding.default, urlParameters: parameters) }
        private var parameters: [String:Any] = [:]
        
        init(phone: String) {
            //電話
            parameters["p"] = phone
        }
    }
    
}




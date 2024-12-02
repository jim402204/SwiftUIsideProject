//
//  NotifyApi.swift
//  LeleTest
//
//  Created by 江俊瑩 on 2024/11/26.
//

import Moya
import Foundation

enum NotifyApi {
    
    //MARK: - 通知列表
    struct NotificationList: BaseTargetType {
        typealias ResponseDataType = [NotificationModel]
        enum Status: Int, CaseIterable {
            case 全部 = -1
            case 未讀 = 0
            case 已讀 = 1
        }
        var path: String { return "user/notification" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        // l可能是長度 sk 是index
        init(l: Int = 20, sk: Int = 0, s: Status = .全部) {
            parameters["l"] = l
            parameters["sk"] = sk
            parameters["s"] = s.rawValue
        }
    }
    
    
    //MARK: - 點數資訊
    struct Point: BaseTargetType {
        typealias ResponseDataType = PointModel
        
        var path: String { return "user/community/\(communityAdmin)/point" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        
        init(
            communityAdmin: String = "63b9b8452cb6973afe2b988f",
            building: String = "A1棟",
            doorPlate: String = "1號",
            floor: String = "1樓"
        ) {
            self.communityAdmin = communityAdmin
            parameters["b"] = building
            parameters["d"] = doorPlate
            parameters["f"] = floor
        }
    }
    
    //MARK: - 點數詳細
    struct PointDetail: BaseTargetType {
        typealias ResponseDataType = [PointHistoryModel]
        enum Status: String {
            case 全部 = ""
            case 一般點數 = "1"
            case 現金點數 = "2"
        }
        
        var path: String { return "user/community/\(communityAdmin)/point_history" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        
        init(
            communityAdmin: String = "63b9b8452cb6973afe2b988f",
            type: Status = .全部,
            l: Int = 20,
            sk: Int = 0,
            building: String = "A1棟",
            doorPlate: String = "1號",
            floor: String = "1樓"
        ) {
            self.communityAdmin = communityAdmin
            
            parameters["l"] = l
            parameters["sk"] = sk
            //PointType
            parameters["pt"] = type.rawValue
            
            parameters["b"] = building
            parameters["d"] = doorPlate
            parameters["f"] = floor
        }
    }
    
    
    
    //MARK: - 訪客資訊
    struct GuestList: BaseTargetType {
        typealias ResponseDataType = [GuestListModel]
        enum Status: Int {
            case home = 1
            case detail = 2
        }
        
        var path: String { return "user/community/\(communityAdmin)/guest_list" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        
        init(
            communityAdmin: String = "63b9b8452cb6973afe2b988f",
            l: Int = 20,
            sk: Int = 0,
            building: String = "A1棟",
            doorPlate: String = "1號",
            floor: String = "1樓",
            s: Status = .home
        ) {
            self.communityAdmin = communityAdmin
            parameters["l"] = l
            parameters["sk"] = sk
            parameters["b"] = building
            parameters["d"] = doorPlate
            parameters["f"] = floor
            parameters["s"] = s.rawValue
        }
    }
    
    
    
    
}

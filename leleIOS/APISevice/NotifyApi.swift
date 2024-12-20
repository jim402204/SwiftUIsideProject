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
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            communityInfo: CommunityInfo = UserDefaultsHelper.userBuilding
        ) {
            self.communityAdmin = communityAdmin
            parameters["b"] = communityInfo.building
            parameters["d"] = communityInfo.doorPlate
            parameters["f"] = communityInfo.floor
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
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
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
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            apiModelInfo: ApiModelInfo = ApiModelInfo(),
            communityInfo: CommunityInfo = UserDefaultsHelper.userBuilding,
            s: Status = .detail
        ) {
            self.communityAdmin = communityAdmin
            parameters["l"] = apiModelInfo.l
            parameters["sk"] = apiModelInfo.sk
            parameters["b"] = communityInfo.building
            parameters["d"] = communityInfo.doorPlate
            parameters["f"] = communityInfo.floor
            parameters["s"] = s.rawValue
        }
    }
    
    //MARK: - BedrockChatBot 聊天AI
    struct BedrockChatBotGet: BaseTargetType {
        typealias ResponseDataType = ChatMessageModel
        
        var baseURL: URL { return URL(string: "https://bheypo5vuh.execute-api.ap-northeast-1.amazonaws.com")!   }
        var path: String { return "prod/voice-bot" }
        
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        
        init(message: String) {
            parameters["message"] = message
        }
    }

    //MARK: - BedrockChatBot 聊天AI
    struct BedrockChatBot: BaseTargetType {
        typealias ResponseDataType = ChatMessageModel
        
        var method: Moya.Method { return .post }
        var baseURL: URL { return URL(string: "https://bheypo5vuh.execute-api.ap-northeast-1.amazonaws.com")!   }
        var path: String { return "prod/voice-bot" }
        
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        
        init(message: String) {
            parameters["message"] = message
        }
    }
    
    
    //MARK: - 獲取擺放位置列表 | getPackagePlaceList
    struct PackagePlaceList: BaseTargetType {
        typealias ResponseDataType = [HouseholdListModel]

        var path: String { return "community/\(communityAdmin)/package_place_list" }
        private var communityAdmin: String
        
        init(communityAdmin: String = UserDefaultsHelper.communityAdmin) {
            self.communityAdmin = communityAdmin
        }
    }
    
    //MARK: - 獲取用戶列表 | getHouseHold
    struct MHouseholdList: BaseTargetType {
        typealias ResponseDataType = [HouseholdListModel]

        var path: String { return "community/\(communityAdmin)/household" }
        private var communityAdmin: String
        
        init(communityAdmin: String = UserDefaultsHelper.communityAdmin) {
            self.communityAdmin = communityAdmin
        }
    }
    
    //MARK: - 產生包裹編號 | generatePackageID
    struct GeneratePackageID: BaseTargetType {
        typealias ResponseDataType = PackageIdModel

        var path: String { return "community/\(communityAdmin)/generate_package_id" }
        private var communityAdmin: String
        
        init(communityAdmin: String = UserDefaultsHelper.communityAdmin) {
            self.communityAdmin = communityAdmin
        }
    }
    
    //MARK: - 釋出包裹編號 | releasePackageID
    struct ReleasePackageID: BaseTargetType {
        typealias ResponseDataType = PackageIdModel

        var method: Moya.Method { .delete }
        var path: String { return "community/\(communityAdmin)/release_package_id" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        
        init(communityAdmin: String = UserDefaultsHelper.communityAdmin, id: Int) {
            self.communityAdmin = communityAdmin
            // 可多個 id "101, 102,103"
            self.parameters["id"] = "\(id)"
        }
    }
    
    //MARK: - 登記 儲存包裹(通知住戶) | savePackage
    struct RegisterPackage: BaseTargetType {
        typealias ResponseDataType = [HouseholdListModel]

        var method: Moya.Method { .post }
        var path: String { return "community/\(communityAdmin)/package" }
        var task: Task { .requestParameters(parameters: parameters, encoding: JSONEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        
        init(communityAdmin: String = UserDefaultsHelper.communityAdmin, model: String) {
            self.communityAdmin = communityAdmin
            
            
        }
    }
    
    //MARK: - 圖像識別 | labelIdentific
    struct BedrockLabelIdentific: BaseTargetType {
        typealias ResponseDataType = BaseResponseData<String>
        
        var method: Moya.Method { return .post }
        var baseURL: URL { return URL(string: "https://bheypo5vuh.execute-api.ap-northeast-1.amazonaws.com")!   }
        var path: String { return "prod/package-label-identific" }
        var task: Task { return .uploadMultipart([formData]) }

        var headers: [String : String]? {
            return [
                "Content-Type":"multipart/form-data",
                "Device-Type":"ios",
                "Accept":"application/json",
                "Authorization" : "Bearer \(UserDefaultsHelper.token ?? "")"
            ]
        }

        let formData: MultipartFormData

        init(imageData: Data) {
            let timestamp = Int(Date().timeIntervalSince1970)
            let fileName = "\(timestamp)" + ".jpeg"
            // name 是server欄位名稱
            let formData = Moya.MultipartFormData.init(provider: .data(imageData),
                                                       name: "file",
                                                       fileName: fileName,
                                                       mimeType: "image/jpeg")

            self.formData = formData
        }
    }
    
}

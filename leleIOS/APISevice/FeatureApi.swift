//
//  FeatureApi.swift
//  LeleTest
//
//  Created by 江俊瑩 on 2024/11/26.
//

import Moya
import Foundation

struct UserIDInfo: Codable {
    /// 使用者id
    var uid: String = ""
    /// 社區id
    var cid: String = ""
    /// 房屋id xx棟x號x樓
    var hid: String = ""
}

struct CommunityInfo: Codable {
//    var building: String = "A1棟"
//    var doorPlate: String = "1號"
//    var floor: String = "1樓"
    var id: String = ""
    var name: String = ""
    var building: String = ""
    var doorPlate: String = ""
    var floor: String = ""
    
    var buildingText: String {
        "\(building)\(doorPlate)\(floor)"
    }
}

struct ApiModelInfo {
    //可能是list length
    var l: Int = 30
    //可能是list index
    var sk: Int = 0
}

enum FeatureApi {
    
    //MARK: - 包裹資訊
    struct PackageList: BaseTargetType {
        typealias ResponseDataType = [PackageModel]
        enum Status: String, CaseIterable {
            case 未領取 = "2"
            case 已領取 = "3"
            case 退貨 = "4,5"
            case 寄放 = "6,7"
        }
        
        var path: String { return "user/community/\(communityAdmin)/package_list" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            communityInfo: CommunityInfo = UserDefaultsHelper.userBuilding,
            apiModelInfo: ApiModelInfo = ApiModelInfo(),
            status: Status = .寄放
        ) {
            self.communityAdmin = communityAdmin
            parameters["b"] = communityInfo.building
            parameters["d"] = communityInfo.doorPlate
            parameters["f"] = communityInfo.floor
            
            parameters["l"] = apiModelInfo.l
            parameters["sk"] = apiModelInfo.sk
            parameters["s"] = status.rawValue
            //排序降序  默認是原DB排序
            parameters["sd"] = 2
            parameters["all"] = true
        }
    }
    
    //MARK: - 包裹資訊
    struct MPackageList: BaseTargetType {
        typealias ResponseDataType = PackageModelWrapper//[PackageModel]//PackageModelWrapper
        
        var path: String { return "community/\(communityAdmin)/package_list" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            communityInfo: CommunityInfo = UserDefaultsHelper.userBuilding,
            apiModelInfo: ApiModelInfo = ApiModelInfo(),
            status: PackageList.Status = .寄放
        ) {
            self.communityAdmin = communityAdmin
            parameters["b"] = communityInfo.building
            parameters["d"] = communityInfo.doorPlate
            parameters["f"] = communityInfo.floor
            
            parameters["s"] = 2
            //可能跟過濾有關係
            parameters["sd"] = 1
            // 有沒有p 對應 respone result or array
            parameters["p"] = 1
            parameters["pp"] = 100
            //調整排序
            parameters["sb"] = ""
//            parameters["st"] = ""
//            parameters["et"] = ""
//            parameters["stc"] = ""
//            parameters["etc"] = ""
//            parameters["pt"] = ""
//            parameters["cm"] = ""
//            parameters["bc"] = ""
//            parameters["ptcn"] = ""
//            parameters["pc"] = ""
        }
    }
    
    //MARK: - 對講機列表
    struct IntercomList: BaseTargetType {
        typealias ResponseDataType = [IntercomListModel]
        enum Status: String, CaseIterable {
            case 社區 = "community"
            case 同戶 = "family"
            case 戶戶 = "household"
            case 服務 = "service"
        }
        
        var path: String { return "user/community/\(communityAdmin)/intercom/list/\(myPath)" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        private var myPath: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            communityInfo: CommunityInfo = UserDefaultsHelper.userBuilding,
            status: Status = .同戶
        ) {
            self.communityAdmin = communityAdmin
            parameters["b"] = communityInfo.building
            parameters["d"] = communityInfo.doorPlate
            parameters["f"] = communityInfo.floor
        
            myPath = status.rawValue
        }
    }
    
    //MARK: - 對講機設定
    struct IntercomSetting: BaseTargetType {
        typealias ResponseDataType = IntercomSettingModel
        
        var path: String { return "user/community/\(communityAdmin)/intercom/setting" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            communityInfo: CommunityInfo = UserDefaultsHelper.userBuilding,
            did: String = "6745670f61094f5e3d832061"
        ) {
            self.communityAdmin = communityAdmin
            parameters["b"] = communityInfo.building
            parameters["d"] = communityInfo.doorPlate
            parameters["f"] = communityInfo.floor
        
            parameters["did"] = did
        }
    }
    
    //MARK: - 對講機設定修改
    struct IntercomSettingPut: BaseTargetType {
        typealias ResponseDataType = defaultModel
        
        var method: Moya.Method { .put }
        var path: String { return "user/community/\(communityAdmin)/intercom/setting" }
        
        var task: Task { .requestCompositeData(bodyData: parameters, urlParameters: urlPara) }
        
        private var parameters: Data = Data()
        private var urlPara: [String:Any] = [:]
        private var communityAdmin: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            communityInfo: CommunityInfo = UserDefaultsHelper.userBuilding,
            did: String = "6745670f61094f5e3d832061",
            model: IntercomSettingModel = IntercomSettingModel(community: nil, device: nil, enabled: true, enabledCommunity: true, enabledFamily: true, enabledHouseHold: true, enabledService: true, disturbSetting: nil)
        ) {
            self.communityAdmin = communityAdmin
            urlPara["b"] = communityInfo.building
            urlPara["d"] = communityInfo.doorPlate
            urlPara["f"] = communityInfo.floor
        
            urlPara["did"] = did
            urlPara["dt"] = ""
            
            // 將 model 轉換為 JSON Data
            if let jsonData = try? JSONEncoder().encode(model) {
                self.parameters = jsonData
            }
        }
    }
    
    //MARK: - 公告狀態表
    struct NewsTypeList: BaseTargetType {
        typealias ResponseDataType = [NewTypeListModel]
        
        var path: String { return "user/community/\(communityAdmin)/news_type_list" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin
        ) {
            self.communityAdmin = communityAdmin
        }
    }
    
    //MARK: - 公告狀態表
    struct NewsTypeaList: BaseTargetType {
        typealias ResponseDataType = [NewTypeListModel]
        
        var path: String { return "user/community/\(communityAdmin)/news_type_list" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin
        ) {
            self.communityAdmin = communityAdmin
        }
    }
    
    //MARK: - 公告列表
    struct NewsList: BaseTargetType {
        typealias ResponseDataType = NewContainerModel
        enum Top: Int {
            case 置頂 = 1
            case 一般 = 0
        }
        enum Status: String {
            case 全部
            case 活動
            case 會議
            case 維修保養
            case 財務
            case 施工裝潢
            case 一般
            case 管理費
            case 宣導
            case 系統功能
        }
        var path: String { return "user/community/\(communityAdmin)/news_list" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            apiModelInfo: ApiModelInfo = ApiModelInfo(l: 30),
            top: Top = .置頂,
            type: Status = .全部
        ) {
            self.communityAdmin = communityAdmin
            
            parameters["l"] = apiModelInfo.l
            parameters["sk"] = apiModelInfo.sk
            parameters["t"] = type == .全部 ? "" : type.rawValue
            parameters["top"] = top.rawValue
        }
    }
    
    //MARK: - 公告全部已讀
    struct NewReadAll: BaseTargetType {
        typealias ResponseDataType = defaultModel
        
        var method: Moya.Method { .post }
        var path: String { return "user/community/\(communityAdmin)/news/readall" }
        
        var task: Task { .requestPlain }
        private var communityAdmin: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin
        ) {
            self.communityAdmin = communityAdmin
        }
    }
    
    //MARK: - 管理費
    struct MgmtfeeInfo: BaseTargetType {
        typealias ResponseDataType = [MgmtfeeInfoModel]
        
        var path: String { return "user/community/\(communityAdmin)/mgmtfee/paying" }
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
    
    //MARK: - 管理費
    struct MgmtfeeHistory: BaseTargetType {
        typealias ResponseDataType = [MgmtfeeInfoModel]
        
        var path: String { return "user/community/\(communityAdmin)/mgmtfee/history" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            communityInfo: CommunityInfo = UserDefaultsHelper.userBuilding,
            apiModelInfo: ApiModelInfo = ApiModelInfo()
        ) {
            self.communityAdmin = communityAdmin
            
            parameters["l"] = apiModelInfo.l
            parameters["sk"] = apiModelInfo.sk
            parameters["b"] = communityInfo.building
            parameters["d"] = communityInfo.doorPlate
            parameters["f"] = communityInfo.floor
        }
    }
    
    //MARK: - 付方式list
    struct PaySinopacFeeRate: BaseTargetType {
        typealias ResponseDataType = PayFeeRateModel
        
        var path: String { return "user/community/\(communityAdmin)/pay/sinopac/fee_rate" }
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
    
    //MARK: - GasHistory
    struct GasHistory: BaseTargetType {
        typealias ResponseDataType = [GasHistoryModel]
        
        var path: String { return "user/community/\(communityAdmin)/gas_history" }
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
    
    //MARK: - Gasform 一個紀錄
    struct Gasform: BaseTargetType {
        typealias ResponseDataType = GasHistoryModel
        
        var path: String { return "user/community/\(communityAdmin)/gasform" }
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
    
    //MARK: - Gas 可能需要紀錄的第一個用Gasform 也可以直接拿紀錄的第一
    struct Gas: BaseTargetType {
        typealias ResponseDataType = GasModel
        
        var path: String { return "user/community/\(communityAdmin)/gas" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            communityInfo: CommunityInfo = UserDefaultsHelper.userBuilding,
            dateString: String = "2024-11"
        ) {
            self.communityAdmin = communityAdmin
            
            parameters["b"] = communityInfo.building
            parameters["d"] = communityInfo.doorPlate
            parameters["f"] = communityInfo.floor
            
            parameters["m"] = dateString
        }
    }
    
    //MARK: - GasUpdate
    struct GasUpdate: BaseTargetType {
        typealias ResponseDataType = GasModel
        
        var method: Moya.Method { .put }
        var path: String { return "user/community/\(communityAdmin)/gas" }
        var task: Task { .requestCompositeParameters(bodyParameters: [:], bodyEncoding: JSONEncoding.default, urlParameters: parameters) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            communityInfo: CommunityInfo = UserDefaultsHelper.userBuilding,
            newValue: String = "1001"
        ) {
            self.communityAdmin = communityAdmin
            
            parameters["b"] = communityInfo.building
            parameters["d"] = communityInfo.doorPlate
            parameters["f"] = communityInfo.floor
            
            parameters["v"] = newValue
        }
    }
    
    //MARK: - MediaList 安控 影像列表
    struct MediaList: BaseTargetType {
        typealias ResponseDataType = [MediaListModel]
        
        var path: String { return "user/community/\(communityAdmin)/media/list" }
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
    
    //MARK: - 日歷事件
    struct CalendarEventList: BaseTargetType {
        typealias ResponseDataType = [CalendarEventListModel.Result]
        
        var path: String { return "user/community/\(communityAdmin)/calendar/event_list" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            startDate: String = "2024-10-25",
            endDate: String = "2024-12-07"
        ) {
            self.communityAdmin = communityAdmin
            
            parameters["st"] = startDate
            parameters["et"] = endDate
        }
    }
    
    
    
    
}



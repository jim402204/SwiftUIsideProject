//
//  PostulateApi.swift
//  LeleTest
//
//  Created by 江俊瑩 on 2024/11/29.
//

import Foundation
import Moya

enum PublicFacilitiesApi {
    
    //MARK: - 公設預約項目
    struct FacilityTypeList: BaseTargetType {
        typealias ResponseDataType = [FacilityTypeModel]
        
        var path: String { return "user/community/\(communityAdmin)/facility_type_list" }
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
    
    //MARK: - 公設預約List
    struct FacilityList: BaseTargetType {
        typealias ResponseDataType = [FacilityModel]
        enum Status: String { //FacilityTypeList 的name
            case 全部 = ""
            case 運動類 = "facilitytype.sport"
            case 休閒類 = "facilitytype.play"
            case 公共類 = "facilitytype.public"
            case 影視類
            case 學習類
            case 餐飲類
            case 其他類
        }
        var path: String { return "user/community/\(communityAdmin)/facility_list" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            communityInfo: CommunityInfo = UserDefaultsHelper.userBuilding,
            type: Status = .全部
        ) {
            self.communityAdmin = communityAdmin
            
            parameters["b"] = communityInfo.building
            parameters["d"] = communityInfo.doorPlate
            parameters["f"] = communityInfo.floor
            
            parameters["ft"] = type.rawValue
        }
    }
    
    //MARK: - 預約資訊
    struct FacilityBookingList: BaseTargetType {
        typealias ResponseDataType = [FacilityBookingＭodel]
        enum Status {
            case 預約資訊
            case 歷史紀錄
        }
        var path: String { return "user/community/\(communityAdmin)/facility_booking_list" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            communityInfo: CommunityInfo = UserDefaultsHelper.userBuilding,
            apiModelInfo: ApiModelInfo = ApiModelInfo(),
            status: Status = .歷史紀錄
        ) {
            self.communityAdmin = communityAdmin
            
            parameters["l"] = apiModelInfo.l
            parameters["sk"] = apiModelInfo.sk
            parameters["b"] = communityInfo.building
            parameters["d"] = communityInfo.doorPlate
            parameters["f"] = communityInfo.floor
            
            if status == .預約資訊 {
                parameters["sd"] = 1
                // 狀態
                parameters["s"] = "1,3"
            } else if status == .歷史紀錄 {
                parameters["sd"] = -1
                // 狀態
                parameters["s"] = "2,4,5,6"
            } else {
                fatalError()
            }
            // 開始結束時間
            parameters["st"] = ""
            parameters["et"] = ""
        }
    }
    
    //MARK: - 可預約的時間
    struct AvailableBookingTime: BaseTargetType {
        typealias ResponseDataType = [BookingTimeModel]
        
        var path: String { return "user/community/\(communityAdmin)/facility/\(facilityID)/available_booking_time" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        private var facilityID: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            facilityID: String = "640e93a6d740668d09258dc1",
            communityInfo: CommunityInfo = UserDefaultsHelper.userBuilding,
            startＤate: String = "2024-11-30",
            start: String = "08:30"
        ) {
            self.communityAdmin = communityAdmin
            //哪裡來還不知道
            self.facilityID = facilityID
            
            parameters["b"] = communityInfo.building
            parameters["d"] = communityInfo.doorPlate
            parameters["f"] = communityInfo.floor
            // 明天
            parameters["sd"] = startＤate
            parameters["st"] = start
        }
    }
    
    //MARK: - Booking  //原App 也打失敗
    struct Booking: BaseTargetType {
        typealias ResponseDataType = String
        
        var method: Moya.Method { .post }
        var path: String { return "user/community/\(communityAdmin)/facility/\(facilityID)/booking" }
        var task: Task { .requestCompositeParameters(bodyParameters: [:], bodyEncoding: JSONEncoding.default, urlParameters: parameters) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        private var facilityID: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            facilityID: String = "640e93a6d740668d09258dc1",
            communityInfo: CommunityInfo = UserDefaultsHelper.userBuilding,
            startＤate: String = "2024-11-30",
            start: String = "08:30"
        )  {
            self.communityAdmin = communityAdmin
            self.facilityID = facilityID
            
            parameters["b"] = communityInfo.building
            parameters["d"] = communityInfo.doorPlate
            parameters["f"] = communityInfo.floor
            
            parameters["sd"] = startＤate
            parameters["st"] = start
            parameters["ed"] = "14:00"
            parameters["bc"] = 4
            //點數要帶入
            parameters["pt"] = ""
        }
    }
    
    
    
    
    
    
    
    
    
    
    //MARK: - 社區規約
    struct RulesTypeList: BaseTargetType {
        typealias ResponseDataType = [RulesTypeListModel]
    
        var path: String { return "user/community/\(communityAdmin)/rules_type_list" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin
        ) {
            self.communityAdmin = communityAdmin
        }
    }
    
    //MARK: - 社區規約
    struct RulesList: BaseTargetType {
        typealias ResponseDataType = [RulesListModel]
        enum Status: String {
            case 全部 = ""
            case 共用部分管理規則
            case 會議規則
            case 選舉辦法
            case 停車場管理辦法
            case 住戶遷出入管理辦法
            case 住戶房屋修繕管理辦法
            case 管理服務人服務規則
            case 財務管理辦法
        }
        var path: String { return "user/community/\(communityAdmin)/rules_list" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            apiModelInfo: ApiModelInfo = ApiModelInfo(),
            type: Status = .全部
        ) {
            self.communityAdmin = communityAdmin
            
            parameters["l"] = apiModelInfo.l
            parameters["sk"] = apiModelInfo.sk
            parameters["t"] = type.rawValue
            parameters["top"] = 0 //不置頂
        }
    }
    
    //MARK: - 社區已讀全部 readall api  先不用 進入頁面會有read api
    
    
    //MARK: - 意見回報 跟 住戶報修
    struct FeedbackList: BaseTargetType {
        typealias ResponseDataType = [FeedbackListModel]
        enum Status: String {
            case 全部 = ""
            case 等待回覆 = "0"
            case 已經回覆 = "1"
        }
        var path: String { return "user/community/\(communityAdmin)/feedback_list" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            communityInfo: CommunityInfo = UserDefaultsHelper.userBuilding,
            apiModelInfo: ApiModelInfo = ApiModelInfo(),
            type: Status = .全部
        ) {
            self.communityAdmin = communityAdmin
            
            parameters["l"] = apiModelInfo.l
            parameters["sk"] = apiModelInfo.sk
            parameters["b"] = communityInfo.building
            parameters["d"] = communityInfo.doorPlate
            parameters["f"] = communityInfo.floor
            
            parameters["r"] = type.rawValue
        }
    }
    
    //MARK: - 回報的項目種類
    struct FeedbackTypeList: BaseTargetType {
        typealias ResponseDataType = [FeedbackTypeModel]
      
        var path: String { return "user/community/\(communityAdmin)/feedback_type_list" }
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
    
    //MARK: - 回報上傳 圖片 (沒有測試)
   struct UploadFeedback: BaseTargetType {
       typealias ResponseDataType = BaseResponseData<String>
       
       var method: Moya.Method { return .post }
       var path: String { return "user/community/\(communityAdmin)/feedback" }
       var task: Task { return .uploadMultipart(formData) }

       var headers: [String : String]? {
           return [
               "Content-Type":"multipart/form-data",
               "Device-Type":"ios",
               "Accept":"application/json",
               "Authorization" : "Bearer \(UserDefaultsHelper.token ?? "")"
           ]
       }

       let formData: [MultipartFormData]
       private var communityAdmin: String
       
       init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            feedbackType: String,
            feedbackContent: String,
            imageData: Data // 可能是多個圖片 最多一次上傳5張
       ) {
           
           self.communityAdmin = communityAdmin
           
           let timestamp = Int(Date().timeIntervalSince1970)
           let fileName = "\(timestamp)" + ".jpeg"
           
           var multipartData = [MultipartFormData]()
           // 添加文字字段
           let typeData = MultipartFormData(provider: .data(feedbackType.data(using: .utf8)!), name: "Type")
           let descData = MultipartFormData(provider: .data(feedbackContent.data(using: .utf8)!), name: "Desc")
           
           // 添加图片字段
           let imageDataPart = MultipartFormData(provider: .data(imageData),
                                                 name: "Image",
                                                 fileName: fileName,
                                                 mimeType: "image/jpeg")
           
           multipartData.append(typeData)
           multipartData.append(descData)
           multipartData.append(imageDataPart)
        
           self.formData = multipartData
       }
   }
    
}

//MARK: - 投票暫時不做

extension PublicFacilitiesApi {
    
    //MARK: - 投票列表
    struct VoteList: BaseTargetType {
        typealias ResponseDataType = [VoteListModel]
        enum Tab: Int {
            case 進行中 = 1
            case 截止 = 0
        }
        var path: String { return "user/community/\(communityAdmin)/vote_list" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            communityInfo: CommunityInfo = UserDefaultsHelper.userBuilding,
            apiModelInfo: ApiModelInfo = ApiModelInfo(),
            tab: Tab = .截止
        ) {
            self.communityAdmin = communityAdmin
            
            parameters["l"] = apiModelInfo.l
            parameters["sk"] = apiModelInfo.sk
            parameters["b"] = communityInfo.building
            parameters["d"] = communityInfo.doorPlate
            parameters["f"] = communityInfo.floor
            
            parameters["v"] = tab.rawValue
        }
    }
    
    //MARK: - 投票結果留言
    struct VoteDetailMessageList: BaseTargetType {
        typealias ResponseDataType = VoteMessageModel
       
        var path: String { return "user/community/\(communityAdmin)/vote/\(voteID)/message_list" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        private var voteID: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            communityInfo: CommunityInfo = UserDefaultsHelper.userBuilding,
            apiModelInfo: ApiModelInfo = ApiModelInfo(),
            voteID: String = "65d80b71b274549885813d2b"
        ) {
            self.communityAdmin = communityAdmin
            self.voteID = voteID
            
            parameters["l"] = apiModelInfo.l
            parameters["sk"] = apiModelInfo.sk
            parameters["b"] = communityInfo.building
            parameters["d"] = communityInfo.doorPlate
            parameters["f"] = communityInfo.floor
        }
    }
    
    //MARK: - 投票結果
    struct VoteResult: BaseTargetType {
        typealias ResponseDataType = VoteResultModel
       
        var path: String { return "user/community/\(communityAdmin)/vote/\(voteID)/result" }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        private var communityAdmin: String
        private var voteID: String
        
        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            communityInfo: CommunityInfo = UserDefaultsHelper.userBuilding,
            apiModelInfo: ApiModelInfo = ApiModelInfo(),
            voteID: String = "65d80b71b274549885813d2b"
        ) {
            self.communityAdmin = communityAdmin
            self.voteID = voteID
            
            parameters["l"] = apiModelInfo.l
            parameters["sk"] = apiModelInfo.sk
            parameters["b"] = communityInfo.building
            parameters["d"] = communityInfo.doorPlate
            parameters["f"] = communityInfo.floor
        }
    }
    
}

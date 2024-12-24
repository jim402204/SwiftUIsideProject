//
//  CommunityManagerApi.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/23.
//

import Moya
import Foundation

enum CommunityManagerApi {
    
    //MARK: - 獲取社區資訊 | getCommunityInfo
    struct CommunityInfoData: BaseTargetType {
        typealias ResponseDataType = CommunityInfoModel

        var path: String { return "community/\(communityAdmin)/info" }
        private var communityAdmin: String
        
        init(communityAdmin: String = UserDefaultsHelper.communityAdmin) {
            self.communityAdmin = communityAdmin
        }
    }
    
    //MARK: - 獲取擺放位置列表 | getPackagePlaceList
    struct PackagePlaceList: BaseTargetType {
        typealias ResponseDataType = [PackagePlaceListModel]

        var path: String { return "community/\(communityAdmin)/package_place_list" }
        private var communityAdmin: String
        
        init(communityAdmin: String = UserDefaultsHelper.communityAdmin) {
            self.communityAdmin = communityAdmin
        }
    }
    
    //MARK: - 獲取用戶列表 | getHouseHold
    struct MHouseholdList: BaseTargetType {
        typealias ResponseDataType = MHouseholdModel

        var path: String { return "community/\(communityAdmin)/household" }
        private var communityAdmin: String
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        private var parameters: [String:Any] = [:]
        
        init(communityAdmin: String = UserDefaultsHelper.communityAdmin,
             communityInfo: CommunityInfo = UserDefaultsHelper.userBuilding) {
            self.communityAdmin = communityAdmin
            
            parameters["b"] = communityInfo.building
            parameters["d"] = communityInfo.doorPlate
            parameters["f"] = communityInfo.floor
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
    
    
    
}

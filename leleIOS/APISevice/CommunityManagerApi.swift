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
    
//    //MARK: - 登記 儲存包裹(通知住戶) | savePackage
//    struct RegisterPackage: BaseTargetType {
//        typealias ResponseDataType = [HouseholdListModel]
//
//        var method: Moya.Method { .post }
//        var path: String { return "community/\(communityAdmin)/package" }
//        var task: Task { .requestParameters(parameters: parameters, encoding: JSONEncoding.default) }
//        private var parameters: [String:Any] = [:]
//        private var communityAdmin: String
//        
//        init(
//            communityAdmin: String = UserDefaultsHelper.communityAdmin,
//            packageID: Int,
//            recipient: String?,
//            type: String,
//            other: String?,
//            userList: [FacilityTypeModel]
//        ) {
//            self.communityAdmin = communityAdmin
//            
//            let houseHold: [String: String] = [
//                "Building": "A1棟",
//                "DoorPlate": "1號",
//                "Floor": "1樓"
//            ]
//            self.parameters["HouseHold"] = houseHold
//            self.parameters["PackageID"] = packageID
//            self.parameters["Type"] = type
//            self.parameters["Status"] = 2
//            
//            // 转换 userList 为字典数组
//            let userModelList: [[String: String]] = userList.map { user in
//                return [
//                    "id": user.id,
//                    "Name": user.name,
//                    "Desc": user.desc
//                ]
//            }
//            
//            self.parameters["HouseHolderUserList"] = userModelList
//            
//            if let recipient = recipient {
//                self.parameters["Recipient"] = recipient
//            } else if let other = other {
//                self.parameters["RecipientCustomName"] = other
//            } else {
//                fatalError("recipient & other nil")
//            }
//        }
//    }
    struct RegisterPackage: BaseTargetType {
        typealias ResponseDataType = [HouseholdListModel]

        var method: Moya.Method { .post }
        var path: String { return "community/\(communityAdmin)/package" }
        var task: Task { .requestJSONEncodable(requestBody) } // 使用 requestJSONEncodable
        private var communityAdmin: String
        private var requestBody: [Package]

        init(
            communityAdmin: String = UserDefaultsHelper.communityAdmin,
            packageID: Int,
            recipient: String?,
            type: String,
            other: String?,
            userList: [FacilityTypeModel]
        ) {
            self.communityAdmin = communityAdmin

            // 构造 HouseHold 对象
            let houseHold = HouseHold(
                building: "A1棟",
                doorPlate: "1號",
                floor: "1樓"
            )

            // 转换 userList 为 UserModel 数组
            let userModelList = userList.map { user in
                UserModel(id: user.id, name: user.name, desc: user.desc)
            }

            // 构造单个 Package 对象
            let package = Package(
                houseHold: houseHold,
                packageID: packageID,
                type: type,
                status: 2,
                houseHolderUserList: userModelList,
                recipient: recipient,
                recipientCustomName: other
            )

            // 构造顶级请求对象
            self.requestBody = [package] // PackageRequest(payload: [package])
        }
    }

    
    
}

import Foundation

struct PackageRequest: Encodable {
    let payload: [Package]
}

struct Package: Encodable {
    let houseHold: HouseHold
    let packageID: Int
    let type: String
    let status: Int
    let houseHolderUserList: [UserModel]
    let recipient: String?
    let recipientCustomName: String?
}

//struct HouseHold: Encodable {
//    let building: String
//    let doorPlate: String
//    let floor: String
//}

struct UserModel: Encodable {
    let id: String
    let name: String
    let desc: String
}

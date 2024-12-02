//
//  BaseAPIModel.swift
//  LeleTest
//
//  Created by 江俊瑩 on 2024/11/25.
//

import Foundation

//MARK: - 一次性
struct OnceTokenModel: Codable {
    let Token: String
}

//MARK: - login
struct TokenModel: Codable {
    let jwtToken: String

    // 自定義 CodingKey，將 "JWT-Token" 對應到 swift 的 "jwtToken" 屬性
    enum CodingKeys: String, CodingKey {
        case jwtToken = "JWT-Token"
    }
}

//MARK: - UserInfoModel
struct UserInfoModel: Codable {
    let id, name, accountID, email: String
    let password: String
    let community: String?
    let communityAdmin: [String]
    let communityAdminRole: [String: String]
    let communityAdminRoleStatus: [String: RoleStatus]
    let active: Bool
    let created, lastLogin, defaultHouseHold: String
    let privateNotify: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name = "Name"
        case accountID = "AccountID"
        case email = "Email"
        case password = "Password"
        case community = "Community"
        case communityAdmin = "CommunityAdmin"
        case communityAdminRole = "CommunityAdminRole"
        case communityAdminRoleStatus = "CommunityAdminRoleStatus"
        case active = "Active"
        case created = "Created"
        case lastLogin = "LastLogin"
        case defaultHouseHold = "DefaultHouseHold"
        case privateNotify = "PrivateNotify"
    }
}

struct RoleStatus: Codable {
    let lastLogin: String
    let create: String

    enum CodingKeys: String, CodingKey {
        case lastLogin = "LastLogin"
        case create = "Create"
    }
}

//MARK: - device_info
struct DeviceModel: Codable {
    let ID: String
}


// MARK: - HouseholdListModel
struct HouseholdListModel: Codable {
    let id: String
    let community: Community
    let building, doorPlate, floor: String

    enum CodingKeys: String, CodingKey {
        case id
        case community = "Community"
        case building = "Building"
        case doorPlate = "DoorPlate"
        case floor = "Floor"
    }
}

// MARK: - Community
struct Community: Codable {
    let id, name, contact, phone: String
    let email, city, district, tel: String
    let address: String
    let lat, lng: Double
    let module: [Module]

    enum CodingKeys: String, CodingKey {
        case id
        case name = "Name"
        case contact = "Contact"
        case phone = "Phone"
        case email = "Email"
        case city = "City"
        case district = "District"
        case tel = "Tel"
        case address = "Address"
        case lat = "Lat"
        case lng = "Lng"
        case module = "Module"
    }
    
    // MARK: - Module
    struct Module: Codable {
        let name: String

        enum CodingKeys: String, CodingKey {
            case name = "Name"
        }
    }
}

enum Title: String, Codable {
    case 報修回覆 = "報修回覆"
    case 社區通知 = "社區通知"
    case 退件通知 = "退件通知"
    case 郵務通知 = "郵務通知"
}

// MARK: - NotificationModel
struct NotificationModel: Codable {
    let id: String
    let title: Title
    let body, createAt: String
    let notification: String?
    let type: Int
    let lastNotify: String
    let recipient: [Recipient]
    let voice: String
    let package: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title = "Title"
        case body = "Body"
        case createAt = "CreateAt"
        case notification = "Notification"
        case type = "Type"
        case lastNotify = "LastNotify"
        case recipient = "Recipient"
        case voice = "Voice"
        case package = "Package"
    }
    
    // MARK: - Recipient
    struct Recipient: Codable {
        let user: String
        let readAt: String?

        enum CodingKeys: String, CodingKey {
            case user = "User"
            case readAt = "ReadAt"
        }
    }
}


// MARK: - PointModel
struct PointModel: Codable {
    let id, community: String
    let houseHold: HouseHold
    let total, totalCash: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case community = "Community"
        case houseHold = "HouseHold"
        case total = "Total"
        case totalCash = "Total_Cash"
    }
}

// MARK: - HouseHold
struct HouseHold: Codable {
    let building, doorPlate, floor: String
    
    enum CodingKeys: String, CodingKey {
        case building = "Building"
        case doorPlate = "DoorPlate"
        case floor = "Floor"
    }
}

// MARK: - PointHistoryModel
struct PointHistoryModel: Codable {
    let changeMethod, pointType, changeValue: Int
    let ps: String?
    let time: String
    let targetHouseHold: HouseHold?

    enum CodingKeys: String, CodingKey {
        case changeMethod = "ChangeMethod"
        case pointType = "PointType"
        case changeValue = "ChangeValue"
        case ps = "PS"
        case time = "Time"
        case targetHouseHold = "TargetHouseHold"
    }
}


// MARK: - GuestListModel
struct GuestListModel: Codable {
    let id: String
    let peopleCount: Int
    let reason: String
    let company, name, webCamFileName, leaveTime: String?
    let status: Int
    let visitTime: String

    enum CodingKeys: String, CodingKey {
        case id
        case peopleCount = "PeopleCount"
        case reason = "Reason"
        case company = "Company"
        case name = "Name"
        case webCamFileName = "WebCamFileName"
        case status = "Status"
        case visitTime = "VisitTime"
        case leaveTime = "LeaveTime"
    }
}


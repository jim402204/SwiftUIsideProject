//
//  ManagerModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/23.
//

import Foundation

// MARK: - CommunityInfoModel
struct CommunityInfoModel: Codable {
    let city, name: String
    let defaultFacilityType, defaultPackageType: [DefaultCommunityType]
    let address, email: String
    let defaultDepositType: [DefaultCommunityType]
    // 棟別戶別
    let houseHoldData: [HouseHoldDatum]
    let defaultShippingProvider: [DefaultCommunityType]
    let function: [String]
    let contact, district, tel: String
    let defaultVisitReason: [DefaultCommunityType]
    let defaultCompany: String?
    let defaultShippingFrom: [DefaultCommunityType]
    let phone: String
    let active: Bool
    let lng: Double
    let id: String
    let module: [DefaultCommunityType]
    let roleName: String
    let contractTime: String
    let lat: Double

    enum CodingKeys: String, CodingKey {
        case city = "City"
        case name = "Name"
        case defaultFacilityType = "DefaultFacilityType"
        case defaultPackageType = "DefaultPackageType"
        case address = "Address"
        case email = "Email"
        case defaultDepositType = "DefaultDepositType"
        case houseHoldData = "HouseHoldData"
        case defaultShippingProvider = "DefaultShippingProvider"
        case function = "Function"
        case contact = "Contact"
        case district = "District"
        case tel = "Tel"
        case defaultVisitReason = "DefaultVisitReason"
        case defaultCompany = "DefaultCompany"
        case defaultShippingFrom = "DefaultShippingFrom"
        case phone = "Phone"
        case active = "Active"
        case lng = "Lng"
        case id
        case module = "Module"
        case roleName = "RoleName"
        case contractTime = "ContractTime"
        case lat = "Lat"
    }
}

// MARK: - DefaultDepositType
struct DefaultCommunityType: Codable, Hashable {
    let name, desc, id: String
    let company: [DefaultCommunityType]?
    let isStatic: Bool?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case desc = "Desc"
        case id
        case company = "Company"
        case isStatic = "IsStatic"
    }
}

// MARK: - HouseHoldDatum
struct HouseHoldDatum: Codable {
    let index: Int
    let doorPlate: [DoorPlate]
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case index = "Index"
        case doorPlate = "DoorPlate"
        case name = "Name"
    }
    
    // MARK: - DoorPlate
    struct DoorPlate: Codable {
        let floor: [Floor]
        let index: Int
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case floor = "Floor"
            case index = "Index"
            case name = "Name"
        }
    }
    // MARK: - Floor
    struct Floor: Codable {
        let name: String
        let index: Int
        
        enum CodingKeys: String, CodingKey {
            case name = "Name"
            case index = "Index"
        }
    }
}

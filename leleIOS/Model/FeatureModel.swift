//
//  FeatureModel.swift
//  LeleTest
//
//  Created by 江俊瑩 on 2024/11/26.
//

import Foundation

// MARK: - PackageModel
struct PackageModel: Codable {
    let id: String
    let packageID: Int
    let barCode: String
    let deposit: DepositData?
    let type: NameDescModel?
    let status: Int
    let initTime: String
    /// 退貨會nil
    let checkTime: String?
    /// 寄件人
    let sender: IdNameModel?
    /// 收件人
    let receiver: String?
    /// 物流
    let shippingProvider: NameDescModel?
    let ps: String?
    let recipientDetail: IdNameModel?
    let isFreezing: Bool?
    let shippingFrom: NameDescModel?
    let isRefrigeration: Bool?
    let recipientCustomName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case packageID = "PackageID"
        case barCode = "BarCode"
        case type = "Type"
        case status = "Status"
        case initTime = "InitTime"
        case checkTime = "CheckTime"
        case sender = "SenderDetail"
        case receiver = "ReceiverShippingProvider"
        case shippingProvider = "ShippingProvider"
        case ps = "PS"
        case recipientDetail = "RecipientDetail"
        case isFreezing = "IsFreezing"
        case shippingFrom = "ShippingFrom"
        case isRefrigeration = "IsRefrigeration"
        case recipientCustomName = "RecipientCustomName"
        case deposit = "DepositData"
    }
    
    // 寄物
    struct DepositData: Codable {
        let typeCustomName: String?
//        let cash: Bool
//        let sendType: Int
        let cashCount: Int?
        let senderHouseHold: HouseHold?
//        let sender: String?
        let senderDetail: IdNameModel?
        let senderOtherName: String?
        let receiverDetail: IdNameModel?
        let receiverOtherName: String?
//        let receiverType: Int
        let receiverProvider: String?
        let senderProvider: String?

        enum CodingKeys: String, CodingKey {
            case typeCustomName = "TypeCustomName"
            case cashCount = "CashCount"
//            case cash = "Cash"
//            case sendType = "SendType"
            case senderHouseHold = "SenderHouseHold"
//            case sender = "Sender"
            case senderDetail = "SenderDetail"
            case senderOtherName = "SenderOtherName"
            case receiverDetail = "ReceiverDetail"
            case receiverOtherName = "ReceiverOtherName"
//            case receiverType = "ReceiverType"
            case senderProvider = "SenderShippingProvider"
            case receiverProvider = "ReceiverShippingProvider"
        }
    }
}

// MARK: - NameDescModel
struct NameDescModel: Codable {
    let name: String
    let desc: String
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case desc = "Desc"
    }
}

// MARK: - IdNameModel
struct IdNameModel: Codable {
    let id: String
    let name: String
    let privateNotify: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case name = "Name"
        case privateNotify = "PrivateNotify"
    }
}

// MARK: - IntercomListModel
struct IntercomListModel: Codable {
    let id: String
    /// 戶戶會為nil
    let name: String?
    let canDial: Bool?
    let device: [Device]?
    
    let building, doorPlate, floor: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name = "Name"
        case canDial = "CanDial"
        case device = "Device"
        case building = "Building"
        case doorPlate = "DoorPlate"
        case floor = "Floor"
    }
}

// MARK: - Device
struct Device: Codable {
    let id: String
    let intercomSetting: IntercomSettingModel

    enum CodingKeys: String, CodingKey {
        case id
        case intercomSetting = "IntercomSetting"
    }
}

// MARK: - IntercomSetting
struct IntercomSettingModel: Codable {
    // IntercomList 不需要, IntercomSetting 需要
    let community, device: String?
    let enabled, enabledCommunity, enabledFamily, enabledHouseHold: Bool
    let enabledService: Bool
    // 勿擾模式設定
    let disturbSetting: [DisturbSetting]?

    enum CodingKeys: String, CodingKey {
        case community = "Community"
        case device = "Device"
        case enabled = "Enabled"
        case enabledCommunity = "EnabledCommunity"
        case enabledFamily = "EnabledFamily"
        case enabledHouseHold = "EnabledHouseHold"
        case enabledService = "EnabledService"
        case disturbSetting = "DisturbSetting"
    }
}

// MARK: - DisturbSetting
struct DisturbSetting: Codable {
    let enabled: Bool
    let startTime, endTime: Int
    let week: [Int]

    enum CodingKeys: String, CodingKey {
        case enabled = "Enabled"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case week = "Week"
    }
}

// MARK: - NewTypeListModel
struct NewTypeListModel: Codable {
    let id, community, name: String
    let index: Int

    enum CodingKeys: String, CodingKey {
        case id
        case community = "Community"
        case name = "Name"
        case index = "Index"
    }
}

// MARK: - NewModel
struct NewModel: Codable {
    let result: [Result]
    let total: Int
    
    
    // MARK: - Result
    struct Result: Codable {
        let id, community, title, type: String
        let startTime: String
        let show: Bool
        let desc: String
        let file: [String]?
        let image: [String]?
        //沒資料不知道做什麼
//        let read: String?
        let hasRead: Bool
        let status, readCount: Int
        let create: String
        let staff: Staff

        enum CodingKeys: String, CodingKey {
            case id
            case community = "Community"
            case title = "Title"
            case type = "Type"
            case startTime = "StartTime"
            case show = "Show"
            case desc = "Desc"
            case file = "File"
            case image = "Image"
//            case read = "Read"
            case hasRead = "HasRead"
            case status = "Status"
            case readCount = "ReadCount"
            case create = "Create"
            case staff = "Staff"
        }
    }

    // MARK: - Staff
    struct Staff: Codable {
        let id, name: String

        enum CodingKeys: String, CodingKey {
            case id
            case name = "Name"
        }
    }
}

// MARK: - MgmtfeeInfoModel
struct MgmtfeeInfoModel: Codable {
    let id, title: String
    let endTime: String
    let payType: [Int]
    let feeInclude: Bool
    let activeTime: String
    let billItem: [BillItem]
    let close: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case title = "Title"
        case endTime = "EndTime"
        case payType = "PayType"
        case feeInclude = "FeeInclude"
        case activeTime = "ActiveTime"
        case billItem = "BillItem"
        case close = "Close"
    }
}

// MARK: - BillItem
struct BillItem: Codable {
    let name: String
    let value: Int

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case value = "Value"
    }
}

// MARK: - MgmtfeeHistoryModel
struct MgmtfeeHistoryModel: Codable {
    let id, title: String
    let endTime: String
    let payType: [Int]
    let feeInclude: Bool
    let activeTime: String
    let billItem: [BillItem]
    let close: Bool
    let payInfo: PayInfo?

    enum CodingKeys: String, CodingKey {
        case id
        case title = "Title"
        case endTime = "EndTime"
        case payType = "PayType"
        case feeInclude = "FeeInclude"
        case activeTime = "ActiveTime"
        case billItem = "BillItem"
        case close = "Close"
        case payInfo = "PayInfo"
    }
    
    // MARK: - PayInfo
    struct PayInfo: Codable {
        let payType: Int
        let payTime: String

        enum CodingKeys: String, CodingKey {
            case payType = "PayType"
            case payTime = "PayTime"
        }
    }
}

// MARK: - PayFeeRateModel
struct PayFeeRateModel: Codable {
    let atm, card, cardMgmtFee, line: Fee
    let mobile: Fee

    enum CodingKeys: String, CodingKey {
        case atm = "ATM"
        case card = "Card"
        case cardMgmtFee = "Card_MgmtFee"
        case line = "Line"
        case mobile = "Mobile"
    }
    
    struct Fee: Codable {
        let fee, feeRate: Int

        enum CodingKeys: String, CodingKey {
            case fee = "Fee"
            case feeRate = "FeeRate"
        }
    }
}

// MARK: - GasHistory

struct GasHistoryModel: Codable {
    let month, endTime: String
    let data: DataClass?
    
    enum CodingKeys: String, CodingKey {
        case month = "Month"
        case endTime = "EndTime"
        case data = "Data"
    }
    
    struct DataClass: Codable {
        let month: String
        let useValue: Int
        let update: String
        
        enum CodingKeys: String, CodingKey {
            case month = "Month"
            case useValue = "UseValue"
            case update = "Update"
        }
    }
}

// MARK: - GasModel
struct GasModel: Codable {
    let month: String
    // 先在要帶入的值
    let useValue: Int
    let update: String

    enum CodingKeys: String, CodingKey {
        case month = "Month"
        case useValue = "UseValue"
        case update = "Update"
    }
}

// MARK: - MediaListModel
struct MediaListModel: Codable {
    let id, name: String
    let model: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name = "Name"
        case model = "Model"
    }
}

// MARK: - CalendarEventListModel
struct CalendarEventListModel: Codable {
    let result: [Result]
    let intent: [String]

    enum CodingKeys: String, CodingKey {
        case result
        case intent = "Intent"
    }
    
    struct Result: Codable {
        let name, start, end, color: String
        let allDay: Bool
        let place, desc: String?

        enum CodingKeys: String, CodingKey {
            case name = "Name"
            case start = "Start"
            case end = "End"
            case color = "Color"
            case allDay = "AllDay"
            case place = "Place"
            case desc = "Desc"
        }
    }

}

// MARK: - VoteListModel
struct VoteListModel: Codable {
    let id, title: String
    let voteByHouseHold: Bool
    let important, canMessage, secret: Bool?
    let desc: String?
    let startTime, endTime: String
    let question: [VoteQuestion]
    let voteCount, voteTotal: Int
    let image: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case title = "Title"
        case voteByHouseHold = "VoteByHouseHold"
        case important = "Important"
        case canMessage = "CanMessage"
        case secret = "Secret"
        case desc = "Desc"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case question = "Question"
        case voteCount = "VoteCount"
        case voteTotal = "VoteTotal"
        case image = "Image"
    }
    
}

struct VoteQuestion: Codable {
    let id: String
    let multiple: Bool
    let options: [VoteOption]
    let voteCount: Int
    let title, desc: String?

    enum CodingKeys: String, CodingKey {
        case id
        case multiple = "Multiple"
        case options = "Options"
        case voteCount = "VoteCount"
        case title = "Title"
        case desc = "Desc"
    }
}

struct VoteOption: Codable {
    let id, desc: String
    let ps: String?
    let voteCount: Int
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id
        case desc = "Desc"
        case ps = "PS"
        case voteCount = "VoteCount"
        case image = "Image"
    }
}

// MARK: - VoteMessageModel
struct VoteMessageModel: Codable {
    let result: [Result]
    let total: Int
    
    // MARK: - Result
    struct Result: Codable {
        let houseHold: HouseHold
        let user: IdNameModel
        let message, create: String

        enum CodingKeys: String, CodingKey {
            case houseHold = "HouseHold"
            case user = "User"
            case message = "Message"
            case create = "Create"
        }
    }
}

// MARK: - VoteResultModel
struct VoteResultModel: Codable {
    let id, community, title: String
    let voteByHouseHold, important, canMessage: Bool
    let desc: String
    let startTime, endTime: String
    let image: [String]
    let question: [VoteQuestion]
    let create, staff: String
    let publish: Bool
    let voteCount, voteTotal: Int

    enum CodingKeys: String, CodingKey {
        case id
        case community = "Community"
        case title = "Title"
        case voteByHouseHold = "VoteByHouseHold"
        case important = "Important"
        case canMessage = "CanMessage"
        case desc = "Desc"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case image = "Image"
        case question = "Question"
        case create = "Create"
        case staff = "Staff"
        case publish = "Publish"
        case voteCount = "VoteCount"
        case voteTotal = "VoteTotal"
    }
}



// MARK: - RulesTypeListModel
struct RulesTypeListModel: Codable {
    let id, community, name: String
    let index: Int

    enum CodingKeys: String, CodingKey {
        case id
        case community = "Community"
        case name = "Name"
        case index = "Index"
    }
}


// MARK: - FeedbackListModel
struct FeedbackListModel: Codable {
    let id, type, desc: String
    let image: [String]?
    let create: String
    let reply, replyTime, readAt: String?
    let replyImage: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case type = "Type"
        case desc = "Desc"
        case image = "Image"
        case create = "Create"
        case reply = "Reply"
        case replyTime = "ReplyTime"
        case readAt = "ReadAt"
        case replyImage = "ReplyImage"
    }
}

// MARK: - FeedbackTypeModel
struct FeedbackTypeModel: Codable {
    let id, community, name: String
    let index: Int

    enum CodingKeys: String, CodingKey {
        case id
        case community = "Community"
        case name = "Name"
        case index = "Index"
    }
}

// MARK: - FacilityTypeModel
struct FacilityTypeModel: Codable {
    let id, name, desc: String

    enum CodingKeys: String, CodingKey {
        case id
        case name = "Name"
        case desc = "Desc"
    }
}

// MARK: - FacilityModel
struct FacilityModel: Codable {
    let id: String
    let type: TypeClass
    let name, desc: String
    let enableTime: [EnableTime]
    let maxBookingEachTime, eachBookingTime: Int
    let photo: [String]
    let enableBooking: Bool
    let maxBooking, bookingCanCancelTime: Int
    let canBookingTime: Int?
    let index: Int
    let needPoint, bookingNeedPoint, cancelBookingReturnPoint, pointByHousehold: Bool?
    let pointByTime: Bool?
    let pointType: [Int]?
    let point, timeout, eachBookingMaxTime, bookingRestrictionDay: Int?
    let bookingRestrictionTimes: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case type = "Type"
        case name = "Name"
        case desc = "Desc"
        case enableTime = "EnableTime"
        case maxBookingEachTime = "MaxBookingEachTime"
        case eachBookingTime = "EachBookingTime"
        case photo = "Photo"
        case enableBooking = "EnableBooking"
        case maxBooking = "MaxBooking"
        case bookingCanCancelTime = "BookingCanCancelTime"
        case canBookingTime = "CanBookingTime"
        case index = "Index"
        case needPoint = "NeedPoint"
        case bookingNeedPoint = "BookingNeedPoint"
        case cancelBookingReturnPoint = "CancelBookingReturnPoint"
        case pointByHousehold = "PointByHousehold"
        case pointByTime = "PointByTime"
        case pointType = "PointType"
        case point = "Point"
        case timeout = "Timeout"
        case eachBookingMaxTime = "EachBookingMaxTime"
        case bookingRestrictionDay = "BookingRestrictionDay"
        case bookingRestrictionTimes = "BookingRestrictionTimes"
    }
    
    struct EnableTime: Codable {
        let weekday, startHour, startMin, endHour: Int
        let endMin: Int

        enum CodingKeys: String, CodingKey {
            case weekday = "Weekday"
            case startHour = "StartHour"
            case startMin = "StartMin"
            case endHour = "EndHour"
            case endMin = "EndMin"
        }
    }
    
    struct TypeClass: Codable {
        let name, desc: String

        enum CodingKeys: String, CodingKey {
            case name = "Name"
            case desc = "Desc"
        }
    }
}


// MARK: - FacilityBookingＭodel

struct FacilityBookingＭodel: Codable {
    let id: String
    let facility: IdNameModel
    let point, pointType: Int?
    let bookingCount, bookingMethod: Int
    let bookingStartTime, bookingEndTime: String
    let pointStatus, status: Int
    let checkTime: String
    let canCancelTime: String?
    let disableCancel: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case facility = "Facility"
        case point = "Point"
        case pointType = "PointType"
        case bookingCount = "BookingCount"
        case bookingMethod = "BookingMethod"
        case bookingStartTime = "BookingStartTime"
        case bookingEndTime = "BookingEndTime"
        case pointStatus = "PointStatus"
        case status = "Status"
        case checkTime = "CheckTime"
        case canCancelTime = "CanCancelTime"
        case disableCancel = "DisableCancel"
    }
}

// MARK: - BookingTimeModel
struct BookingTimeModel: Codable {
    let hour, min, available: Int

    enum CodingKeys: String, CodingKey {
        case hour = "Hour"
        case min = "Min"
        case available = "Available"
    }
}

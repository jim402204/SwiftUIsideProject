//
//  UserApi.swift
//  CoursePass
//
//  Created by Jim on 2023/7/13.
//

import Moya
import Foundation

enum UserApi {
    
    //MARK: - 登入
    // 只用在登入
    struct GetToken: BaseTargetType {
        typealias ResponseDataType = OnceTokenModel

        var path: String { return "token" }
    }
    
    //MARK: - Login
    struct Login: BaseTargetType {
        typealias ResponseDataType = TokenModel

        var method: Moya.Method { .post }
        var path: String { return "login" }
        var task: Task { .requestParameters(parameters: parameters, encoding: JSONEncoding.default) }
        private var parameters: [String:Any] = [:]
    
        init(user: String, digest: String, token: String) {
            parameters["user"] = user
            parameters["digest"] = digest
            parameters["token"] = token
        }
    }
    
    //MARK: - Login
    struct Logout: BaseTargetType {
        typealias ResponseDataType = String
        
        var method: Moya.Method { .post }
        var path: String { return "user/logout" }
        var task: Task { .requestCompositeParameters(bodyParameters: [:], bodyEncoding: JSONEncoding.default, urlParameters: parameters) }
        private var parameters: [String:Any] = [:]
        
        /// 登出是拿 device id給server
        init(uid: String) {
            parameters["did"] = uid
        }
    }
    
    struct DeleteUser: BaseTargetType {
        typealias ResponseDataType = String
        
        var method: Moya.Method { .delete }
        var path: String { return "user" }
 
        var task: Task { .requestParameters(parameters: [:], encoding: URLEncoding.default) }
    }
    
    struct LoginDeviceList: BaseTargetType {
        typealias ResponseDataType = [LoginDeviceListModel]

        var path: String { return "user/login_device_list" }
    }
    
    
    
    
    
    
//    //MARK: - 更新個人資料
//    struct UpdateProfile: BaseTargetType {
//        typealias ResponseDataType = BaseResponseData<String>
//        
//        var method: Moya.Method { return .put }
//        var path: String { return "user/profile" }
//        var task: Task { .requestParameters(parameters: parameters, encoding: JSONEncoding.default) }
//        private var parameters: [String:Any] = [:]
//        
//        init(name: String? = nil, gender: String? = nil, birthday: String? = nil) {
//            
//            if let name = name {
//                parameters["name"] = name
//            }
//            if let gender = gender {
//                parameters["gender"] = gender
//            }
//            if let birthday = birthday {
//                parameters["birthday"] = birthday
//            }
//        }
//        
//        init(education: String, grade: Int, schoolID: Int) {
//            parameters["education_stage"] = education
//            parameters["grade"] = grade
//            parameters["school_id"] = schoolID
//        }
//    }
//    
//    //MARK: - 上傳圖片
//    struct UploadAvatar: BaseTargetType {
//        typealias ResponseDataType = BaseResponseData<String>
//        var method: Moya.Method { return .post }
//        var path: String { return "user/profile/uploadAvatar" }
//        var task: Task { return .uploadMultipart([formData]) }
//       
//        var headers: [String : String]? {
//            return [
//                "Content-Type":"multipart/form-data",
//                "Device-Type":"ios",
//                "Accept":"application/json",
//                "Authorization": "Bearer \("token" ?? "")"
//            ]
//        }
//        
//        let formData: MultipartFormData
//
//        init(imageData: Data) {
//            let timestamp = Int(Date().timeIntervalSince1970)
//            let fileName = "\(timestamp)" + ".jpeg"
//            // name 是server欄位名稱
//            let formData = Moya.MultipartFormData.init(provider: .data(imageData),
//                                                       name: "avatar",
//                                                       fileName: fileName,
//                                                       mimeType: "image/jpeg")
//            
//            self.formData = formData
//        }
//    }
    
    

}


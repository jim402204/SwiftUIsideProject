//
//  UserDefault.swift
//  CoursePass
//
//  Created by 江俊瑩 on 2022/3/30.
//

import Foundation

// https://www.andyibanez.com/posts/nsuserdefaults-property-wrappers/


struct UserDefaultsHelper {
    @UserDefault(key: "token") static var token: String?
    @UserDefaultValue(key: "communityInfo", defaultValue: CommunityInfo()) static var userBuilding: CommunityInfo
    @UserDefaultValue(key: "communityAdmin", defaultValue: "") static var communityAdmin: String
    @UserDefaultValue(key: "userRole", defaultValue: UserRole.住戶) static var userRole: UserRole
    @UserDefaultValue(key: "UserIdInfo", defaultValue: UserIDInfo()) static var UserIdInfo: UserIDInfo
}

@propertyWrapper
struct UserDefaultValue<T: Codable> {
    let key: String
    let defaultValue: T
    var container: UserDefaults = .standard

    var wrappedValue: T {
        get {
            guard let data = container.data(forKey: key) else { return defaultValue }
            let object = try? JSONDecoder().decode(UserDWrapper<T>.self.self, from: data)
            return object?.wrapped ?? defaultValue
        }
        
        set {
            let data = try? JSONEncoder().encode(UserDWrapper(wrapped: newValue))
            container.set(data, forKey: key)
            container.synchronize()
        }
    }
}

/// 儲存物件要包 不要有bug apple沒有修Codable
@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    var container: UserDefaults = .standard
    
    init(key: String) {
        self.key = key
    }
    var wrappedValue: T? {
        get {
            guard let data = container.data(forKey: key) else { return nil }
            
            let object = try? JSONDecoder().decode(UserDWrapper<T>.self, from: data)
            return object?.wrapped
        }
        
        set {
            if let object = newValue, let data = try? JSONEncoder().encode(UserDWrapper(wrapped: object)) {
                container.set(data, forKey: key)
                container.synchronize()
            } else if newValue == nil {
                container.set(nil, forKey: key)
                container.synchronize()
                debugPrint("UserDefault key: nil")
            } else {
                debugPrint("UserDefault fail: \(key)")
            }
        }
    }
}

// https://stackoverflow.com/a/59475086
struct UserDWrapper<T> : Codable where T : Codable {
    let wrapped : T
}

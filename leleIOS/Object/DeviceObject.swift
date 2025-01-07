//
//  DeviceObject.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2025/1/7.
//

import DeviceKit
import UIKit

class DeviceObject {
    
    static let shared = DeviceObject()
    
    /// iOS
    public var os: String { UIDevice.current.systemName }
    /// iPhone 8 Plus
    public var deviceName: String { return Device.current.description }
    /// iOS 16.6
    public var  systemVersion: String { UIDevice.current.systemVersion }
    /// 1.0.0
    public var appVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "appVersion"
    /// 1
    public var buildNumber = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "buildNumber"
        
    private init() {}
}

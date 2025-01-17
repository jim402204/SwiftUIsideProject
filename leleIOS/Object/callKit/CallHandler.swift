//
//  ddd.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2025/1/17.
//

import Foundation
import CallKit

class CallHandler {
    private let callManager = CallManager() // 確保 callManager 正確初始化
    private var activeCallUUID: UUID? // 存儲當前通話的 UUID
    
    func simulateIncomingCall() {
        let uuid = UUID()
        activeCallUUID = uuid // 保存 UUID，供後續掛斷通話使用
        
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: "1234567890")
        update.localizedCallerName = "Demo Caller"
        update.hasVideo = false

        print("Triggering simulated call with UUID: \(uuid)")
        
        callManager.provider.reportNewIncomingCall(with: uuid, update: update) { error in
            if let error = error {
                print("Failed to report incoming call: \(error.localizedDescription)")
            } else {
                print("Incoming call reported successfully!")
            }
        }
        
    }
    // 主動觸發關閉
    func endCall() {
        // 注意！掛斷通話時需要使用與報告來電時相同的 UUID
        guard let uuid = activeCallUUID else {
            print("No active call to end")
            return
        }
        
        let endCallAction = CXEndCallAction(call: uuid)
        let transaction = CXTransaction(action: endCallAction)

        callManager.callController.request(transaction) { error in
            if let error = error {
                print("Failed to end call: \(error.localizedDescription)")
            } else {
                print("Call ended successfully!")
            }
        }
    }
}


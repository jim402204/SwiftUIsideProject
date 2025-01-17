//
//  CallManager.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2025/1/17.
//

import Foundation
import CallKit

class CallManager: NSObject, CXProviderDelegate {
    let provider: CXProvider
    let callController = CXCallController() // 新增這一行
    
    override init() {
        let configuration = CXProviderConfiguration()
//        let configuration = CXProviderConfiguration(localizedName: "Demo Call")
        configuration.supportsVideo = false
        configuration.maximumCallsPerCallGroup = 1
        configuration.supportedHandleTypes = [.phoneNumber]

        provider = CXProvider(configuration: configuration)
        super.init()
        provider.setDelegate(self, queue: nil)
        
        // 打印初始化日誌，確認流程是否正常
        print("CXProvider initialized and delegate set.")
    }

    func providerDidReset(_ provider: CXProvider) {
        print("Provider was reset. Cleaning up resources.")
        // 清理通话状态
//        endAllActiveCalls()
//        stopAudioSession()
//        updateCallUI(forActiveCall: false)
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("Ending call")
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("Answering call")
        action.fulfill()
    }

}


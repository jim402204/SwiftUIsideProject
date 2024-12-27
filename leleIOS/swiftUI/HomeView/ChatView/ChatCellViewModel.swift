//
//  ChatCellViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/27.
//

import Observation
import Foundation

// MARK: - ChatCellViewModel
@Observable
class ChatCellViewModel {
    
    let msg: String
    let isParse: Bool
    let voiceURL: String
    let isMyMsg: Bool
    
    init (model: ChatMessageModel) {
        self.msg = model.output
        self.isParse = model.parse
        self.voiceURL = model.url
        self.isMyMsg = false
    }
    
    init (msg: String) {
        self.msg = msg
        self.isParse = false
        self.voiceURL = ""
        self.isMyMsg = true
    }
}

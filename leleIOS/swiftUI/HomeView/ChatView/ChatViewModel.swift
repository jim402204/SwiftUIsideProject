//
//  ChatViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/19.
//

import Observation
import Foundation
import AVKit

@Observable
class ChatViewModel {
    
    var list: [ChatCellViewModel] = []
    var message: String = ""
    let player = AudioPlayerManager()
    var loadingManager = LoadingManager.shared
    /// 第一次要到就會不變了
    var msgID: String? = nil
    
    func sendMsg() {
        
        callBestAPI(message: message)
        
        let msg = ChatCellViewModel(msg: message)
        list.append(msg)
        //清空發問
        message = ""
    }
    
    func refresh() {
        list.removeAll()
    }
    
}

// MARK: - API

extension ChatViewModel {
    
    func callAPI(message: String) {
        
        Task {
            guard let model = try? await apiService.requestA(NotifyApi.BedrockChatBotGet(message: message)) else { return }
            
            let viewModel = ChatCellViewModel(model: model)
            
            await MainActor.run {
                self.list.append(viewModel)
                self.player.play(from: viewModel.voiceURL)
            }
        }
    }
    
    func callBestAPI(message: String) {
        
        loadingManager.isLoading = true
        
        Task {
            guard let model = try? await apiService.requestA(NotifyApi.BedrockChatBot(msgID: msgID, message: message)) else {
                loadingManager.isLoading = false
                return
            }
            
            let viewModel = ChatCellViewModel(model: model)
            self.msgID = model.id
            
            await MainActor.run {
                self.list.append(viewModel)
                self.player.play(from: viewModel.voiceURL)
                
                loadingManager.isLoading = false
            }
        }
    }
}

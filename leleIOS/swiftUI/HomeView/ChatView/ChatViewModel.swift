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
    var message: String = "我想填瓦斯度數"
    var player: AVPlayer = AVPlayer()
    private var statusObserver: NSKeyValueObservation?
    
    func sendMsg() {
        callBestAPI(message: message)
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
                self.play(load: viewModel.voiceURL)
            }
        }
    }
    
    func callBestAPI(message: String) {
        
        Task {
            guard let model = try? await apiService.requestA(NotifyApi.BedrockChatBot(message: message)) else { return }
            
            let viewModel = ChatCellViewModel(model: model)
            
            await MainActor.run {
                self.list.append(viewModel)
                self.play(load: viewModel.voiceURL)
            }
        }
    }
}

// MARK: - player 相關

extension ChatViewModel {
    
    func play(load urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        
        playNewAudio(from: url)
    }
    
    fileprivate func playNewAudio(from url: URL) {
        if player.timeControlStatus == .playing {
            player.pause()
            player.seek(to: .zero)
        }
        
        let newItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: newItem)
        
        statusObserver = newItem.observe(\.status, options: [.new]) { [weak self] item, _ in
            if item.status == .readyToPlay {
                self?.player.play()
            } else if item.status == .failed {
                // 处理加载失败的情况
            }
        }
    }
    
    fileprivate func removeObserver() {
        // 移除之前的观察者
        statusObserver?.invalidate()
        statusObserver = nil
    }
    
    func playerRelease() {
        
        player.pause()
        statusObserver?.invalidate()
        statusObserver = nil
    }
}

// MARK: - ChatCellViewModel

class ChatCellViewModel {
    
    let msg: String
    let isParse: Bool
    let voiceURL: String
    
    init (model: ChatMessageModel) {
        self.msg = model.output
        self.isParse = model.parse
        self.voiceURL = model.url
    }
}

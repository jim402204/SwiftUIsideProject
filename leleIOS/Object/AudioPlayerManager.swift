//
//  AudioPlayerManager.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/27.
//
// AudioPlayerManager.swift
// 封裝 AVPlayer 和相關邏輯

import AVKit
import Foundation

class AudioPlayerManager {
    private var player: AVPlayer = AVPlayer()
    private var statusObserver: NSKeyValueObservation?

    deinit {
        removeObserver()
    }

    func play(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        playNewAudio(from: url)
    }

    func stop() {
        player.pause()
        player.seek(to: .zero)
        removeObserver()
    }

    private func playNewAudio(from url: URL) {
        // 停止當前播放並重置
        if player.timeControlStatus == .playing {
            player.pause()
            player.seek(to: .zero)
        }

        let newItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: newItem)

        // 添加狀態監聽
        statusObserver = newItem.observe(\.status, options: [.new]) { [weak self] item, _ in
            if item.status == .readyToPlay {
                self?.player.play()
            } else if item.status == .failed {
                // 處理播放失敗
                print("Audio playback failed: \(item.error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    private func removeObserver() {
        // 移除之前的觀察者
        statusObserver?.invalidate()
        statusObserver = nil
    }
}

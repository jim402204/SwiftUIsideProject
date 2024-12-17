//
//  LoadMoreManager.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/13.
//

import SwiftUI
import Observation
// MARK: - LoadMoreManager  用於管理分頁邏輯
/// 用於管理分頁邏輯  注意是struct結構 為了更新swiftUI
@Observable
class LoadMoreManager {
    var currentPage: Int = 1
    var isLoading: Bool = false
    var hasMoreData: Bool = true {
        didSet {
            print("LoadMoreManager hasMoreData changed to: \(hasMoreData)")
        }
    }
    
    private let pageSize: Int // 每頁的數量
    
    init(pageSize: Int = 20) {
        self.pageSize = pageSize
    }

    // 計算當前已加載數量
    var loadedCount: Int { return (currentPage - 1) * pageSize }

    // 重置分頁
//    mutating
    func reset() {
        currentPage = 1
        isLoading = false
        hasMoreData = true
    }

    // 標記開始加載
//    mutating
    func startLoading() { isLoading = true }
    
    // 加載下一頁的前置檢查
    func canLoadMore() -> Bool {
        return !isLoading && hasMoreData
    }

    // 在成功获取数据后更新分页状态
//    mutating
    func handleSuccess<Model>(models: [Model]) {
        isLoading = false
        if models.isEmpty {
            hasMoreData = false // 如果返回数组为空，标记无更多数据
        } else {
            currentPage += 1
        }
    }

    // 處理加載失敗
//    mutating
    func handleFailure() {
        isLoading = false
        hasMoreData = false
        //因為是多層結構並需手動更新
    }
    
}

// MARK: - PaginatedLoadable 給viewModel用

protocol PaginatedLoadable: AnyObject {
    associatedtype Item: Identifiable
    
    var items: [Item] { get set }
    var loadMoreManager: LoadMoreManager { get set }
    func loadMoreAPI() // 分页加载方法，由具体实现定义
}

extension PaginatedLoadable {
    
    /// 給cell 需要的更多API  掛在 cell  onAppear 下
    func loadMoreIfNeeded(currentItem: Item) {
        guard !items.isEmpty else { return }
        guard let currentIndex = items.firstIndex(where: { $0.id == currentItem.id }) else { return }
        
        let offset = 1 // 目标偏移量：倒数第3个
        guard items.count >= offset else { return } // 确保数组长度足够
        let thresholdIndex = items.index(items.endIndex, offsetBy: -offset)

        print("currentIndex: \(currentIndex), thresholdIndex: \(thresholdIndex)")
        if currentIndex == thresholdIndex {
            loadMoreAPI()
        }
    }
    
    /// 第一次call API
    func startAPI() {
        resetPagination()
        loadMoreAPI()
    }
    /// 回歸初始設置  tabChanged：切換tab時可用
    func resetPagination() {
        items.removeAll()
        loadMoreManager.reset()
    }
    
//    if viewModel.loadMoreManager.hasMoreData {
//        ProgressView()
//            .padding()
//            .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    viewModel.loadMoreAPI()
//                }
//            }
//    }
    
}

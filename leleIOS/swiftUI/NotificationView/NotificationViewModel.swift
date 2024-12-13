import SwiftUI
import RxSwift
import Moya

extension NotificationViewModel: PaginatedLoadable {
    typealias Item = NotificationModel
    
    var items: [NotificationModel] {
        get { list }
        set { list = newValue }
    }
    
    func loadMoreAPI() {
        notificationListAPI()
    }
}

class NotificationViewModel: ObservableObject {
    private let disposeBag = DisposeBag()
    
    @Published var selectedTab: NotifyApi.NotificationList.Status = .全部
    @Published var list: [NotificationModel] = []
    var loadMoreManager = LoadMoreManager() // 用於管理分頁邏輯

    let tabs = NotifyApi.NotificationList.Status.allCases.map { $0 }

    func tabChanged(to tab: NotifyApi.NotificationList.Status) {
        selectedTab = tab
        resetPagination()
        notificationListAPI()
    }

}

extension NotificationViewModel {
    
    private func notificationListAPI() {

        guard loadMoreManager.canLoadMore() else { return }

        loadMoreManager.startLoading()
        
        let currentTab = NotifyApi.NotificationList.Status.allCases.first { $0 == selectedTab } ?? .全部
        let sk = loadMoreManager.loadedCount
        
        apiService.request(NotifyApi.NotificationList(sk: sk, s: currentTab))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] (models: [NotificationModel]) in
                guard let self = self else { return }
                
                self.list.append(contentsOf: models)
                self.loadMoreManager.handleSuccess(models: models)
                
            }, onFailure: { [weak self] error in
                self?.loadMoreManager.handleFailure()
                print("Error fetching notifications: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
}






import SwiftUI
import RxSwift
import Moya

class NotificationViewModel: ObservableObject {
    private let disposeBag = DisposeBag()
    
    @Published var selectedTab: NotifyApi.NotificationList.Status = .全部
    @Published var notifications: [NotificationModel] = []
    
    let tabs = NotifyApi.NotificationList.Status.allCases.map { $0 }
    
//    init() 不能放置binding 可能重複呼叫 StateObject的話 只有一次 不算preview
    
    func tabChanged(to tab: NotifyApi.NotificationList.Status) {
        selectedTab = tab
        notificationListAPI()
    }
    
    func callAPI() {
        
//        loginAPI {
            self.notificationListAPI()
//        }
    }
    
}

extension NotificationViewModel {
    
    private func notificationListAPI() {
        let currentTab = NotifyApi.NotificationList.Status.allCases.first { $0 == selectedTab } ?? .全部
        
        apiService.request(NotifyApi.NotificationList(s: currentTab))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] (models: [NotificationModel]) in
                
                self?.notifications = models
            })
            .disposed(by: disposeBag)
    }
    
   
    
}



import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = MainTabViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 首頁
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("首頁")
                }
                .tag(0)
            
            // 雲對講
            IntercomView()
                .tabItem {
                    Image(systemName: "phone.bubble.fill")
                    Text("雲對講")
                }
                .tag(1)
            
            // 通知
            NotificationView()
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("通知")
                }
                .tag(2)
            
            // 個人
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("個人")
                }
                .tag(3)
        }
    }
}

// 預覽
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

import SwiftUI
import UIKit // 确保导入 UIKit

//https://juejin.cn/post/7105021679633432606
//要精細的控制tabBar只能用UIkit來轉

class NavigationManager: ObservableObject {
    // 目前只有homePage有用到
    @Published var path = NavigationPath()
}

struct MainTabView: View {
    @StateObject private var router = NavigationManager()
    @StateObject private var viewModel = MainTabViewModel()
    @State private var selectedTab = 0
    
    init() {
        // 修改 TabBar 中的物件，例如图标文本等
        let itemAppearance = UITabBarItemAppearance()
        // 图标的颜色————也就是Image的颜色
        // 未选中的标签的图标的颜色
        itemAppearance.normal.iconColor = UIColor(Color(.systemGray5))
        // 选中的标签的图标的颜色
        itemAppearance.selected.iconColor = UIColor(Color.white)
        // 文本的颜色和字體大小
        itemAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color(.systemGray5)),
            .font: UIFont.systemFont(ofSize: 14) // 設置未選中狀態的字體大小
        ]
        // 選中的标签的标题的颜色和字體大小
        itemAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.white),
            .font: UIFont.systemFont(ofSize: 14) // 設置選中狀態的字體大小
        ]
        
        // 調整圖標和文字之間的距離
        itemAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5)
        itemAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5)
       
        let appeareance = UITabBarAppearance()
        appeareance.stackedLayoutAppearance = itemAppearance
        // TabBar的背景颜色
        appeareance.backgroundColor = UIColor(Color.teal)
        appeareance.stackedItemPositioning = .automatic
        
        UITabBar.appearance().standardAppearance = appeareance
        UITabBar.appearance().scrollEdgeAppearance = appeareance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 首頁
//            NavigationStack(path: $router.path) {
                HomeView()
                    .environmentObject(router)
//            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("首頁")
            }
            .tag(0)
            
            // 雲對講
            NavigationStack{
                IntercomView(isRootPage: true)
            }
            .tabItem {
                Image(systemName: "phone.bubble.fill")
                Text("雲對講")
            }
            .tag(1)
            
            // 通知
            NavigationStack {
                NotificationView()
            }
            .tabItem {
                Image(systemName: "bell.fill")
                Text("通知")
            }
            .tag(2)
            
            // 個人
            NavigationStack {
                ProfileView()
            }
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
            .environmentObject(AppState())
    }
}

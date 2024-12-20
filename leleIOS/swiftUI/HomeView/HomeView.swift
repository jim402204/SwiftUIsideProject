//
//  HomeView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/2.
//

import SwiftUI

// 各個頁面的基本結構
struct HomeView: View {
    @EnvironmentObject var router: NavigationManager
    @State private var showRoleSelection = false
    @State private var userRole: UserRole = UserDefaultsHelper.userRole
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack(spacing: 10) {
                
                Spacer().frame(height: 10)
                
                HStack {
                    Text(UserDefaultsHelper.userBuilding.name)
//                    Text("家家測試社區")
                        .appFont(.size(24),color: .teal)
                        .lineLimit(1)
                    Text("功能選單")
                        .appFont(.title2)
                    
                    testButton()
                    Spacer()
                }
                .padding(.vertical,8)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .padding(.horizontal)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                    ForEach(PageModelFactory.generatePageModel(for: userRole), id: \.name) { item in
                        Button(action: {
                            router.path.append(item.navigationPage)
                        }) {
                            VStack {
                                Image(systemName: item.systemImageName)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.teal)
                                Text(item.name)
                                    .foregroundStyle(Color.black.opacity(0.7))
                                    .appFont(.subheadline)
                            }
                        }
    //                    createNavigationLink(for: item)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .applyShadow()
                )
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarStyle(title: "首頁", isRootPage: true)
            .navigationDestination(for: HomeNavigationPage.self) { destination in
                destinationView(for: destination)
            }
        } //NavigationStack
    }
    
    func createNavigationLink(for item:  PageModel<HomeView.HomeNavigationPage>
    ) -> some View {
        NavigationLink(destination: destinationView(for: item.navigationPage)) {
            VStack {
                Image(systemName: item.systemImageName)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.teal)
                Text(item.name)
                    .foregroundStyle(Color.black.opacity(0.7))
            }
        }
    }
    
    func testButton() -> some View {
        Button("角色切換") {
            showRoleSelection = true
        }
        .appFont(.subheadline)
        .confirmationDialog("選擇角色", isPresented: $showRoleSelection) {
            ForEach(UserRole.allCases) { role in
                Button(role.rawValue) {
                    userRole = role
                    UserDefaultsHelper.userRole = role
                }
            }
            Button("取消", role: .cancel) {}
        }
    }
}


#Preview {
    @Previewable @StateObject var router = NavigationManager()
//    NavigationStack(path: $router.path) {
        HomeView()
            .environmentObject(router)
//    }
}


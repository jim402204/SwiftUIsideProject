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
    
    var body: some View {
        VStack(spacing: 10) {
            
            Spacer().frame(height: 10)
            
            HStack {
                Text(UserDefaultsHelper.userBuilding.name)
                    .appFont(.size(24),color: .teal)
                    .lineLimit(1)
                Text("功能選單")
                    .appFont(.title2)
                Spacer()
            }
            .padding(.vertical,8)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .padding(.horizontal)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                ForEach(HomeView.pageModel, id: \.name) { item in
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
        .navigationBarStyle(title: "首頁")
        .navigationDestination(for: HomeNavigationPage.self) { destination in
            destinationView(for: destination)
        }
        //            .navigationBarHidden(true)
    }
}


#Preview {
    @Previewable @StateObject var router = NavigationManager()
    NavigationStack(path: $router.path) {
        HomeView()
            .environmentObject(router)
    }
}

//                    NavigationLink(destination: destinationView(for: item.navigationPage)) {
//                        Text("aa")
//                    }



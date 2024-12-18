//
//  GasView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/18.
//

import SwiftUI

struct GasView: View {
    @State private var viewModel = GasViewModel()
    
    let noData = "未填寫"
    
    var body: some View {
        VStack(spacing: 0) {
            
            Spacer().frame(height: 25)
            
            Text(UserDefaultsHelper.userBuilding.buildingText)
                .appFont(.largeTitle)
            
            Spacer().frame(height: 10)
            
            Divider()
            
            Text("第202411期")
                .appFont(.title2)
                .background(Color.white)
                .cornerRadius(20)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.teal, lineWidth: 2) // 设置边框颜色和宽度
                )
                .overlay {
                    HStack {
                        Spacer()
                        Text("箭頭")
                        Spacer().frame(width: 10)
                    }
                }
                .padding()
            
            VStack {
                HStack {
                    Text("上期度數")
                    Spacer()
                    Text("")
                }
                HStack {
                    Text("本期度數")
                    Spacer()
                    Text("\(String(describing: viewModel.model?.data?.useValue))")
                }
                HStack {
                    Text("填表時間")
                    Spacer()
                    Text("\(String(describing: viewModel.model?.data?.update))")
                }
                HStack {
                    Text("截止時間")
                    Spacer()
                    Text(viewModel.model?.endTime ?? "")
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.teal, lineWidth: 2) // 设置边框颜色和宽度
            )
            .padding(.vertical,10)
            .padding(.horizontal)
            
            Spacer()
            
        }
        .navigationBarStyle(title: "瓦斯超表")
    }
}

#Preview {
    PreviewTokenView {
        NavigationStack {
            GasView()
        }
    }
}

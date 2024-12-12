//
//  HomeView+.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/11.
//

import Foundation
import SwiftUI

struct PageModel<T>: Identifiable where T: Hashable {
    let id = UUID() // 唯一標識符
    let name: String // 圖標名稱
    let systemImageName: String // 系統圖標名稱
    let navigationPage: T // 對應導航標識符
}

extension HomeView {
    
    // 定義枚舉，作為導航堆疊中的標識符
    enum HomeNavigationPage: Hashable {
        case postalService
        case intercom
        case securityControl
        case bulletin
        case rule
        case guest
        case detail(String) // 可以攜帶額外參數的頁面
    }
   
    static var pageModel: [PageModel<HomeNavigationPage>] {
        [
            PageModel(name: "雲對講", systemImageName: "phone.bubble.fill", navigationPage: .intercom),
            PageModel(name: "郵務管理", systemImageName: "envelope.fill", navigationPage: .postalService),
            PageModel(name: "社區公告", systemImageName: "megaphone.fill", navigationPage: .bulletin),
            PageModel(name: "報修", systemImageName: "doc.text.fill", navigationPage: .detail("報修")),
            PageModel(name: "住戶意見", systemImageName: "bubble.left.and.bubble.right.fill", navigationPage: .detail("住戶意見")),
            PageModel(name: "訪客", systemImageName: "person.crop.circle.fill", navigationPage: .guest),
            PageModel(name: "公設", systemImageName: "building.columns.fill", navigationPage: .detail("公設")),
            PageModel(name: "投票", systemImageName: "hand.thumbsup.fill", navigationPage: .detail("投票")),
            PageModel(name: "規約", systemImageName: "doc.plaintext.fill", navigationPage: .rule),
            PageModel(name: "瓦斯", systemImageName: "flame.fill", navigationPage: .detail("瓦斯")),
            PageModel(name: "行事曆", systemImageName: "calendar", navigationPage: .detail("行事曆")),
            PageModel(name: "管理費", systemImageName: "dollarsign.circle.fill", navigationPage: .detail("管理費")),
            PageModel(name: "安控", systemImageName: "lock.shield.fill", navigationPage: .securityControl),
            PageModel(name: "相簿", systemImageName: "photo.on.rectangle", navigationPage: .detail("相簿")),
            PageModel(name: "遠端關懷", systemImageName: "antenna.radiowaves.left.and.right", navigationPage: .detail("遠端關懷")),
            PageModel(name: "社區百問", systemImageName: "questionmark.circle.fill", navigationPage: .detail("社區百問"))
        ]
    }


    @ViewBuilder
    func destinationView(for page: HomeNavigationPage) -> some View {
        switch page {
        case .intercom:
            IntercomView()
        case .postalService:
            PostalServiceView()
        case .bulletin:
            BulletinView()
                
        case .rule:
            RuleView()
        case .securityControl:
            SecurityControlView()
        case .guest:
            GuestView()
        case .detail(let message):
            DetailView()
//            ChildView()
        }
    }

}


struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("這是詳細頁面")
                .appFont(.largeTitle)
                .padding()

            Button(action: {
                dismiss() // 點擊按鈕後返回上一頁
            }) {
                Text("返回")
                    .appFont(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
//        .navigationTitle("詳細信息")
        .navigationBarStyle(title: "詳細信息")
        
    }
}





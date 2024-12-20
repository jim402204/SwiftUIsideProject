//
//  PostalServiceEntryView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/20.
//

import SwiftUI

struct PostalServiceEntryView: View {
    
    @State private var viewModel = PostalServiceEntryViewModel()
    
    @State private var packageType: String = ""
    @State private var type = "普通"
//    @State private var isRefrigerated = false
//    @State private var isFrozen = false
    @State private var household = "選擇戶別"
    @State private var recipient = ""
    @State private var otherRecipient = ""
    @State private var notes = ""
    @State private var location = "位置"

    var body: some View {
        Form {
            
//            Section(header: Text("冷藏/冷凍選項")) {
//                Toggle("冷藏", isOn: $isRefrigerated)
//                Toggle("冷凍", isOn: $isFrozen)
//            }
            
            Section(header: Text("包裹類型")) {
                Picker("包裹類型", selection: $packageType) {
                    Text("包裹類型").tag("包裹類型")
                    Text("掛號").tag("掛號")
                    Text("包裹").tag("包裹")
                    Text("公家機關").tag("公家機關")
                }
            }
            
            Section(header: Text("冷藏/冷凍選項")) {
                Picker("", selection: $type) {
                    Text("普通").tag("普通")
                    Text("冷藏").tag("冷藏")
                    Text("冷凍").tag("冷凍")
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section(header: Text("戶別")) {
                Picker("戶別", selection: $household) {
                    Text("戶別").tag("戶別")
                    Text("戶別1").tag("戶別1")
                    Text("戶別2").tag("戶別2")
                    Text("戶別3").tag("戶別3")
                }
            }
            
            Section(header: Text("位置")) {
                Picker("位置", selection: $location) {
                    Text("位置").tag("位置")
                    Text("管理室").tag("管理室")
                    Text("冰箱").tag("冰箱")
                    Text("信箱").tag("信箱")
                }
            }

            Section(header: Text("收件人")) {
                TextField("收件人", text: $recipient)
                TextField("其他收件人", text: $otherRecipient)
            }

            Section(header: Text("備註")) {
                TextField("備註", text: $notes)
            }
            

            Button(action: {
                // 發送API請求的邏輯
            }) {
                Text("登記")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationBarStyle(title: "包裹登記")
        .onAppear {
            viewModel.callAsyncAPI()
        }
        .onDisappear {
            viewModel.releaseAPI()
        }
    }
}

#Preview {
    PostalServiceEntryView()
}

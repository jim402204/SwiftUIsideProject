//
//  PostalServiceEntryView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/20.
//

import SwiftUI

struct PostalServiceEntryView: View {
    @State private var isSheetPresented = false
    @State private var viewModel = PostalServiceEntryViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            
            Section(header: Text("包裹類型")) {
                Picker("包裹類型", selection: $viewModel.packageType) {
                    Text("包裹類型").tag(nil as String?) // 空选项
                    ForEach(viewModel.cInfoViewModel.packageType, id: \.desc) { model in
                        Text(model.desc).tag(model.name)
                    }
                }
//                Text("packageType: \(viewModel.packageType)")
            }
            
            Section(header: Text("冷藏/冷凍選項")) {
                Picker("", selection: $viewModel.optionType) {
                    Text("普通").tag("普通")
                    Text("冷藏").tag("冷藏")
                    Text("冷凍").tag("冷凍")
                }
                .pickerStyle(SegmentedPickerStyle())
//                Text("type: \(viewModel.optionType)")
            }

            Section(header: Text("戶別")) {
                HStack(spacing: 6) {
                    Text("戶別")
                        .backgroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        
                    Spacer()
                    Text(viewModel.pickerViewModel.selectedResult)
                        .foregroundColor(.gray)
                    Image(systemName: "chevron.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 10, height: 10)
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    isSheetPresented = true
                }
//                Text("戶別: \(viewModel.pickerViewModel.getSelectedResult)")
            }
            
            Section(header: Text("位置")) {
                Picker("位置", selection: $viewModel.location) {
                    Text("位置").tag(nil as String?)
                    ForEach(viewModel.packagePlaceModels, id: \.name) { model in
                        Text(model.name)
                    }
                }
//                Text("location: \(viewModel.location)")
            }

            Section(header: Text("收件人")) {
                Picker("收件人", selection: $viewModel.recipient) {
                    Text("收件人").tag(nil as String?)
                    ForEach(viewModel.householdUserModels, id: \.name) { model in
                        Text(model.name).tag(model.id)
                    }
                }
//                Text("recipient: \(viewModel.recipient)")
            }

            Section(header: Text("其他收件人/備註")) {
                TextField("其他收件人", text: $viewModel.otherRecipient)
                TextField("備註", text: $viewModel.notes)
            }

            Button(action: {
                // 發送API請求的邏輯
                viewModel.registerPackageAPI()
            }) {
                Text("登記")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationBarStyle(title: "包裹登記")
        .onAppear {
            viewModel.callAPI()
        }
        .onDisappear {
            viewModel.releaseAPI()
        }
        .sheet(isPresented: $isSheetPresented) {
            PickerSheetView(
                pickerVM: $viewModel.pickerViewModel,
                isPresented: $isSheetPresented
            )
        }
        .onChange(of: viewModel.isPopPage) { _ , new in
            guard !new else { return }
            self.dismiss()
        }
    }
}

#Preview {
    PostalServiceEntryView()
}

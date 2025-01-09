//
//  SwiftUIViewdd.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/10.
//

import SwiftUI
import Kingfisher

struct BulletinDetailView: View {
    let viewModel: BulletinCellViewModel
    
    var body: some View {
        
        ScrollView() {
            VStack(alignment: .leading, spacing: 10) {
                
                Text(viewModel.title)
                    .appFont(.title2)
                    .bold()
                
                HStack {
                    Text(viewModel.date)
                        .appFont(.subheadline, color: .secondary)
                    
                    Text(viewModel.type)
                        .tagStyle(background: .green)
                        .font(.subheadline)
                }
                
                if let updateDate = viewModel.updateDate {
                    HStack(spacing: 6) {
                        Text("最後更新")
                        Text(updateDate)
                            .appFont(.subheadline, color: .secondary)
                    }
                }
                
                Divider()
                
                Text(viewModel.content)
                    .appFont(.size(20))
                    .lineLimit(nil)
                
//                SwiftUITextView(
//                    text: viewModel.content,
//                    fontSize: 20,
//                    lineBreakMode: .byCharWrapping
//                )
//                .frame(maxHeight: .infinity) 

                
                if !viewModel.images.isEmpty {
//                if true {
                
                    Divider()
                    Text("公告圖片")
                        .foregroundStyle(Color(.systemBlue))
                    VStack(spacing: 10) {
                        ForEach(viewModel.images, id: \.self) { url in
                            KFImage(url)
                                .cacheOriginalImage()
                                .cancelOnDisappear(true)
                                .placeholder {
                                    ProgressView()
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.9) // 設置固定寬度
                        }
                    }
                }
                
                if viewModel.file != nil {
//                if true {
                
                    Divider()
                    Text("公告附檔")
                        .foregroundStyle(Color(.systemBlue))
                    Button(action: {
                        
                    }) {
                        Text("點開附件")
                            .foregroundColor(.teal)
                            .padding(.vertical,8)
                            .padding(.horizontal)
                            .background()
                            .cornerRadius(20)
                            .applyShadow()
                    }
                }
                
            }
            .padding()
            
        }
        .navigationBarStyle(title: "公告內容")
        
    }//body
}

#Preview {
    //    NavigationStack {
    BulletinDetailView(viewModel:
                        BulletinCellViewModel(
                            type: "活動",
                            title: "大家一起去爬山",
                            date: "2024-12-06",
                            content: "爬山囉！\n\n\n\n\nsdfsfdf\n\n\n\n\n\nafsafsaf",
                            isTop: false)
    )
    //    }
}

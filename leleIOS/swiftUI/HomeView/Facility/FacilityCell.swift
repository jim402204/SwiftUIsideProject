//
//  FacilityCell.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/17.
//

import SwiftUI
import Kingfisher

struct FacilityCell: View {
    let viewModel: FacilityCellViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text(viewModel.name)
                    .foregroundStyle(.white)
                    .appFont(.size(24))
                    .bold()
                Spacer()
                Text(viewModel.tagText)
                    .tagStyle(textColor: .white, background: .orange)
                    .appFont(.subheadline)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(Color(.black.withAlphaComponent(0.5)))
            
            Spacer()
            
            HStack {
                Text(viewModel.enableTimeLabel)
                    .foregroundStyle(.white)
                    .appFont(.subheadline)
                Spacer()
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(Color(.black.withAlphaComponent(0.5)))
        }
//        .background(Color.white)
        .background(content: {
            KFImage(viewModel.imageUrl)
                .cacheOriginalImage()
                .cancelOnDisappear(true)
                .placeholder {
                    ProgressView()
                }
                .resizable()
                .background(Color.white)
        })
        .cornerRadius(30)
        .frame(height: 200)
        .applyShadow()
        .paddingCell(vertical: 10)

    }
}

#Preview(traits: .sizeThatFitsLayout) {
    FacilityCell(viewModel: FacilityCellViewModel(id: "", name: "name", tagText: "tagText", imageUrl: nil, enableTimeLabel: "enableTimeLabel"))
}

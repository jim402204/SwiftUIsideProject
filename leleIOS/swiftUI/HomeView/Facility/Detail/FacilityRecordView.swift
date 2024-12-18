//
//  FacRecordView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/17.
//

import SwiftUI

struct FacilityRecordView: View {
    @State private var viewModel = FacilityRecordViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 10)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(viewModel.list.enumerated()), id: \.offset) { _, item in
                        FacilityBookingCell(viewModel: item)
                    }
                }
            }
        }
        .refreshable {
            viewModel.callAPI()
        }
        .navigationBarStyle(title: "歷史紀錄")
        .background(Color(UIColor.systemGroupedBackground))
    }
}

#Preview {
    PreviewTokenView {
        NavigationStack {
            FacilityRecordView()
        }
    }
}

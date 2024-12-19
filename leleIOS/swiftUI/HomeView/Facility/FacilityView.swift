//
//  FacilityView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/17.
//

import SwiftUI

struct FacilityView: View {
    @State private var viewModel = FacilityViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(viewModel.list.enumerated()), id: \.offset) { _, item in
                        NavigationLink(destination: Text("ddd")) {
                            FacilityCell(viewModel: item)
                        }
                    }
                }
            }
        }
        .refreshable {
            viewModel.callAPI()
        }
        .navigationBarStyle(title: "公設預約")
        .background(Color(UIColor.systemGroupedBackground))
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                NavigationLink(destination: FacilityReservationView()) {
                    Image(systemName: "checkmark.circle") // 预约图标
                        .foregroundStyle(.white)
                }
                NavigationLink(destination: FacilityRecordView()) {
                    Image(systemName: "clock.arrow.circlepath") // 记录图标
                        .foregroundStyle(.white)
                }
            }
        }.foregroundStyle(.white)
    }
}

#Preview {
    PreviewTokenView {
        NavigationStack {
            FacilityView()
        }
    }
}

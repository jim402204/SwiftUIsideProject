//
//  ReservationView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/17.
//

import SwiftUI

struct FacilityReservationView: View {
    @State private var viewModel = FacilityReservationViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 10)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(viewModel.list.enumerated()), id: \.offset) { _, item in
                        FacilityBookingCell(viewModel: item)
                        
                        NavigationLink(destination: Text("ddd")) {
                            FacilityBookingCell(viewModel: item)
                        }
                        
                    }
                }
            }
        }
        .refreshable {
            viewModel.callAPI()
        }
        .navigationBarStyle(title: "預約資訊")
        .background(Color(UIColor.systemGroupedBackground))
    }
}

#Preview {
    PreviewTokenView {
        NavigationStack {
            FacilityReservationView()
        }
    }
}

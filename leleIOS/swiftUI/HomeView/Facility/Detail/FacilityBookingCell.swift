//
//  FacilityRecordCell.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/17.
//

import SwiftUI

struct FacilityBookingCell: View {
    var viewModel: FacilityBookingCellViewＭodel! = nil
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(spacing: 15) {
                VStack {
                    Text("11月")
                        .foregroundStyle(.red)
                    Text("24")
                        .appFont(.size(24))
                        .bold()
                    Text("周日")
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color(.systemGray5))
                .cornerRadius(10)
                
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(viewModel.name)
                        Text(viewModel.date)
                    }
                    
                    HStack {
                        Text(viewModel.point)
                        Text("已預扣點數")
                            .tagStyle(textColor: .white, background: .green)
                            .appFont(.subheadline)
                    }
                    
                    HStack(spacing: 0) {
                        Text(viewModel.bookingCount)
                        Text("『逾時未進場』")
                            .foregroundStyle(.red)
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical,12)
            .padding(.horizontal)
            .background(Color.white)
            .overlay(content: {
                
                if !viewModel.isHideCancelTag {
                    VStack() {
                        HStack {
                            Spacer()
                            HStack() {
                                Spacer().frame(width: 15)
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("000")
                                        .frame(height: 25)
                                    Text("取消预约")
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                }
                                Spacer()
                            }
                            .frame(width: 100)
                            .padding(.vertical, 6)
                            .background(Color.red)
                            .cornerRadius(20)
                            .offset(x: 15, y: -25)
                            .clipped()
                        }
                        Spacer()
                    }
                }
            })
            .cornerRadius(20)
            .applyShadow()
            .paddingCell(vertical: 6)
            
        }//ZStack
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    FacilityBookingCell()
}


import SwiftUI

struct CommunityInfoCardView: View {
    @ObservedObject var viewModel: ProfileViewModel
    let cardCornerRadius: CGFloat

    var body: some View {
        VStack(spacing: 10) {
            Text("社區資訊")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    
                    NavigationLink(destination: Text("家家測試社區")) {
                        HStack {
                            VStack() {
                                Image(systemName: "person.fill")
                                Text("現居")
                                    .appFont(.caption)
                            }
                            .foregroundColor(.blue)
                            
                            Text("家家測試社區")
                                .appFont(.title3)
                                .bold()
                                .foregroundColor(.black)
                            
                            Spacer()
                        }
                        .foregroundColor(.blue)
                        .padding()
                    }
                    
                    Divider()
                    
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.gray)
                        Text(viewModel.shortAddress)
                        Spacer()
                    }
                    .padding()
                    
                    Divider()
                    
                    HStack {
                        Image(systemName: "house.fill")
                            .foregroundColor(.gray)
                        Text(viewModel.building)
                        Spacer()
                    }
                    .padding()
                    
                    Divider()
                    
                    NavigationLink(destination: Text("點數管理")) {
                        HStack {
                            Text("點數")
                                .foregroundColor(.black)
                            Text(viewModel.point)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        .padding()
                    }
                }
                .background(Color.white)
            }
            .cornerRadius(cardCornerRadius)
            .applyShadow()
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CommunityInfoCardView(viewModel: ProfileViewModel(), cardCornerRadius: 20)
}

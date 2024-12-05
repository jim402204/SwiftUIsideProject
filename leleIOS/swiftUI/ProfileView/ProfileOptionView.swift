import SwiftUI

struct ProfileOptionView: View {
    let title: String
    var iconName: String = arrowIcon
    var action: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.black)
            Spacer()
            Image(systemName: iconName)
                .foregroundColor(.gray)
        }
        .contentShape(Rectangle())
        .padding()
//        .background(Color.clear)
//        .onTapGesture {
//            action?()
//        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ProfileOptionView(title: "個人資料", iconName: "chevron.right") {
        print("Tapped")
    }
}

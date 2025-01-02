//
//  easySegmentObject.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2025/1/2.
//

import SwiftUI

struct CustomTabBarView: View {
    @Binding var activeTab: DummyTab
    var offsetObserver: PageOffsetObserver

    var body: some View {
        TabBarView(.gray)
            .overlay {
                if let collectionViewBounds = offsetObserver.collectionView?.bounds {
                    GeometryReader {
                        let width = $0.size.width
                        let tabCount = CGFloat(DummyTab.allCases.count)
                        let capsuleWidth = width / tabCount
                        let progress = offsetObserver.offset / collectionViewBounds.width
                        
                        Capsule()
                            .fill(.black)
                            .frame(width: capsuleWidth)
                            .offset(x: progress * capsuleWidth)
                        
                        TabBarView(.white, .semibold)
                            .mask(alignment: .leading) {
                                Capsule()
                                    .frame(width: capsuleWidth)
                                    .offset(x: progress * capsuleWidth)
                            }
                    }
                }
            }
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.2), radius: 5, x: 5, y: 5)
            .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
            .padding([.horizontal, .top], 15)
    }

    @ViewBuilder
    private func TabBarView(_ tint: Color, _ weight: Font.Weight = .regular) -> some View {
        HStack(spacing: 0) {
            ForEach(DummyTab.allCases, id: \.rawValue) { tab in
                Text(tab.rawValue)
                    .font(.callout)
                    .fontWeight(weight)
                    .foregroundStyle(tint)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation() {
                            activeTab = tab
                        }
                    }
            }
        }
    }
}

struct OffsetBackgroundView: View {
    var offsetObserver: PageOffsetObserver

    var body: some View {
        if !offsetObserver.isObserving {
            FindCollectionView() {
                offsetObserver.collectionView = $0
                offsetObserver.observe()
            }
        }
    }
}

// MARK: - CustomTabBarView 使用方式

// 使用 CustomTabBarView
struct CustomTabBarView1: View {
    @State private var activeTab: DummyTab = .home
    var offsetObserver = PageOffsetObserver()

    var body: some View {
        VStack(spacing: 15) {
            CustomTabBarView(activeTab: $activeTab, offsetObserver: offsetObserver)

            TabView(selection: $activeTab) {
                DummyTab.home.color
                    .tag(DummyTab.home)
                    .background {
                        OffsetBackgroundView(offsetObserver: offsetObserver)
                    }

                DummyTab.chats.color
                    .tag(DummyTab.chats)

                DummyTab.calls.color
                    .tag(DummyTab.calls)

                DummyTab.settings.color
                    .tag(DummyTab.settings)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

#Preview {
    CustomTabBarView1()
}

// MARK: - 用uikit 監聽collectionView的offset
import UIKit

@Observable
class PageOffsetObserver: NSObject {
    var collectionView: UICollectionView?
    var offset: CGFloat = 0
    private(set) var isObserving: Bool = false
    
    deinit {
        remove()
    }
    
    func observe() {
        guard !isObserving else { return }
        collectionView?.addObserver(self, forKeyPath: "contentOffset", context: nil)
        isObserving = true
    }
    
    func remove() {
        isObserving = false
        collectionView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentOffset" else { return }
        if let contentOffset = (object as? UICollectionView)?.contentOffset {
            offset = contentOffset.x
        }
    }
}

struct FindCollectionView: UIViewRepresentable {
    var result: (UICollectionView) -> ()
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if let collectionView = view.collectionSuperView {
                result(collectionView)
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
extension UIView {
    var collectionSuperView: UICollectionView? {
        if let collectionView = superview as? UICollectionView {
            return collectionView
        }
        return superview?.collectionSuperView
    }
}

// MARK: - 替代 tab的暫定euem

enum DummyTab: String, CaseIterable {
    case home = "Home"
    case chats = "Chats"
    case calls = "Calls"
    case settings = "Settings"
    
    var color: Color {
        switch self {
        case .home:
            return .red
        case .chats:
            return .blue
        case .calls:
            return .green
        case .settings:
            return .purple
        }
    }
}

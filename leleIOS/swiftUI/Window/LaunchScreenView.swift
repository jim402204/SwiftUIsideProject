//
//  LaunchScreenView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/10.
//

import SwiftUI

struct LaunchScreenModifier: ViewModifier {
    @State private var isLaunching = true

    func body(content: Content) -> some View {
        ZStack {
            // 主內容
            content
                .opacity(isLaunching ? 0 : 1)

            // 啟動畫面
            if isLaunching {
                SplashView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            startLaunchAnimation()
        }
    }

    private func startLaunchAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                isLaunching = false
            }
        }
    }
}

extension View {
    func withLaunchScreen() -> some View {
        self.modifier(LaunchScreenModifier())
    }
}

struct SplashView: View {
    @State private var scale = 0.8
    @State private var opacity = 0.5
    var duration: TimeInterval = 0.4
    
    var body: some View {
        ZStack {
            Color.teal.ignoresSafeArea()
            VStack(spacing: 20) {
                Text("leleApp")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                Text("Welcome!")
                    .foregroundColor(.white)
                    .opacity(opacity)
            }
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeInOut(duration: duration)) {
                    scale = 1.2
                    opacity = 1.0
                }
            }
        }
    }
}

#Preview {
    SplashView(duration: 1)
}



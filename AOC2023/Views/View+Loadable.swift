//
//  View+Loadable.swift
//  AOC2023
//
//  Created by Franciszek Czana on 06/01/2024.
//

import SwiftUI

extension View {
    func loadable(isLoading: Bool, label: String) -> some View {
        modifier(FCActivityIndicator(isLoading: isLoading, label: label))
    }
}

private struct FCActivityIndicator: AnimatableModifier {
    var isLoading: Bool
    let label: String

    init(
        isLoading: Bool,
        label: String
    ) {
        self.isLoading = isLoading
        self.label = label
    }

    var animatableData: Bool {
        get { isLoading }
        set { isLoading = newValue }
    }

    func body(content: Content) -> some View {
        ZStack {
            if isLoading {
                GeometryReader { geometry in
                    ZStack(alignment: .center) {
                        content
                            .disabled(isLoading)
                            .blur(radius: isLoading ? 3 : 0)

                        VStack {
                            ActivityIndicator(isAnimating: .constant(true), style: .large)
                            Text(label)
                        }
                        .frame(width: geometry.size.width / 2,
                               height: geometry.size.height / 5)
                        .background(Color.secondary.colorInvert())
                        .foregroundColor(Color.primary)
                        .cornerRadius(20)
                        .opacity(isLoading ? 1 : 0)
                        .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
                    }
                }
            } else {
                content
            }
        }
    }
}

private struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context _: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context _: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

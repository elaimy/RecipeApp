import SwiftUI

/**
 # ShimmerView
 
 A customizable shimmer effect component that automatically transitions between loading state and content.
 
 ## Usage Options:
 
 ### 1. Using ShimmerView directly:
 ```
 ShimmerView(
     isLoading: viewModel.isLoading,
     content: {
         // Real content to show when loaded
         Text("Content loaded!")
     },
     placeholder: {
         // Placeholder with shimmer effect
         Rectangle()
             .fill(Color.gray.opacity(0.3))
             .frame(height: 30)
             .cornerRadius(8)
     }
 )
 ```
 
 ### 2. Using DI container:
 ```
 @EnvironmentObject var diContainer: DIContainer
 
 diContainer.shimmerService.createShimmerView(
     isLoading: viewModel.isLoading,
     duration: 2.0,
     shimmerColor: Color.blue.opacity(0.3),
     content: { /* real content */ },
     placeholder: { /* placeholder */ }
 )
 ```
 
 ### 3. Using View extension:
 ```
 Text("This has shimmer effect")
     .shimmer(active: viewModel.isLoading)
 ```
 */

/// A view modifier that applies a shimmer effect to any view
struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    var active: Bool
    var duration: Double
    var shimmerColor: Color
    
    func body(content: Content) -> some View {
        if active {
            content
                .overlay(
                    GeometryReader { geometry in
                        shimmerColor
                            .mask(
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(stops: [
                                                .init(color: .clear, location: phase - 0.5),
                                                .init(color: .white.opacity(0.7), location: phase),
                                                .init(color: .clear, location: phase + 0.5)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geometry.size.width * 3)
                                    .offset(x: -2 * geometry.size.width + (2 * geometry.size.width) * phase)
                            )
                    }
                )
                .onAppear {
                    withAnimation(Animation.linear(duration: duration).repeatForever(autoreverses: false)) {
                        phase = 1
                    }
                }
        } else {
            content
        }
    }
}

/// A placeholder view that displays a shimmer effect
struct ShimmerView<Content: View, Placeholder: View>: View {
    var isLoading: Bool
    var content: () -> Content
    var placeholder: () -> Placeholder
    var duration: Double
    var shimmerColor: Color
    
    init(
        isLoading: Bool,
        duration: Double = 1.5,
        shimmerColor: Color = Color.gray.opacity(0.3),
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.isLoading = isLoading
        self.duration = duration
        self.shimmerColor = shimmerColor
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        ZStack {
            if isLoading {
                placeholder()
                    .modifier(ShimmerEffect(
                        active: true,
                        duration: duration,
                        shimmerColor: shimmerColor
                    ))
                    .disabled(true)
            } else {
                content()
            }
        }
    }
}

// Extension for convenient usage
extension View {
    func shimmer(
        active: Bool,
        duration: Double = 1.5,
        shimmerColor: Color = Color.gray.opacity(0.3)
    ) -> some View {
        modifier(ShimmerEffect(
            active: active,
            duration: duration,
            shimmerColor: shimmerColor
        ))
    }
}

// MARK: - DIContainer Integration
protocol ShimmerServiceProtocol {
    func createShimmerView<Content: View, Placeholder: View>(
        isLoading: Bool,
        duration: Double,
        shimmerColor: Color,
        content: @escaping () -> Content,
        placeholder: @escaping () -> Placeholder
    ) -> ShimmerView<Content, Placeholder>
}

class ShimmerService: ShimmerServiceProtocol {
    func createShimmerView<Content: View, Placeholder: View>(
        isLoading: Bool,
        duration: Double = 1.5,
        shimmerColor: Color = Color.gray.opacity(0.3),
        content: @escaping () -> Content,
        placeholder: @escaping () -> Placeholder
    ) -> ShimmerView<Content, Placeholder> {
        ShimmerView(
            isLoading: isLoading,
            duration: duration,
            shimmerColor: shimmerColor,
            content: content,
            placeholder: placeholder
        )
    }
} 
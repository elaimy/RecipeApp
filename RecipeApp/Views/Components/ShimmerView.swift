import SwiftUI

// MARK: - Shimmer Effect Modifier

struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    private let duration: Double = 1.5
    private let baseColor = Color.gray.opacity(0.2)
    private let highlightColor = Color.gray.opacity(0.35)
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    highlightColor
                        .mask(
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(stops: [
                                            .init(color: .clear, location: phase - 0.3),
                                            .init(color: .white, location: phase),
                                            .init(color: .clear, location: phase + 0.3)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * 2)
                                .offset(x: -geometry.size.width + (geometry.size.width * 2 * phase))
                        )
                }
            )
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(
                    Animation.linear(duration: duration)
                        .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerEffect())
    }
}

// MARK: - Skeleton Components

struct SkeletonCard: View {
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.gray.opacity(0.2))
            .frame(width: width, height: height)
            .shimmer()
            .accessibilityHidden(true)
    }
}

struct SkeletonTitle: View {
    let width: CGFloat
    let height: CGFloat
    
    init(width: CGFloat, height: CGFloat = 16) {
        self.width = width
        self.height = height
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray.opacity(0.2))
            .frame(width: width, height: height)
            .shimmer()
            .accessibilityHidden(true)
    }
}

struct SkeletonCircle: View {
    let size: CGFloat
    
    var body: some View {
        Circle()
            .fill(Color.gray.opacity(0.2))
            .frame(width: size, height: size)
            .shimmer()
            .accessibilityHidden(true)
    }
}

// MARK: - Skeleton Card Presets

struct SkeletonMealCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SkeletonCard(width: 180, height: 120, cornerRadius: 12)
            SkeletonTitle(width: 160, height: 14)
            SkeletonTitle(width: 120, height: 12)
        }
        .frame(width: 180)
    }
}

struct SkeletonCategoryCard: View {
    var body: some View {
        SkeletonCard(width: 140, height: 100, cornerRadius: 16)
    }
}

struct SkeletonIngredientCard: View {
    var body: some View {
        SkeletonCard(width: 140, height: 100, cornerRadius: 16)
    }
}


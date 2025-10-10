import SwiftUI

struct FavoritesScreen: View {
    @EnvironmentObject var diContainer: DIContainer
    @EnvironmentObject var favoritesStore: FavoritesStore
    @Binding var showTabBar: Bool
    
    init(showTabBar: Binding<Bool> = .constant(true)) {
        self._showTabBar = showTabBar
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if favoritesStore.favoriteIDs.isEmpty && !favoritesStore.isLoading {
                    // Empty state
                    emptyStateView
                } else if favoritesStore.isLoading && favoritesStore.favoriteMeals.isEmpty {
                    // Loading state
                    favoritesGridSkeleton
                } else if let error = favoritesStore.errorMessage {
                    // Error state
                    errorView(error: error)
                } else {
                    // Content
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(favoritesStore.favoriteMeals) { meal in
                                NavigationLink(value: meal.idMeal) {
                                    FavoriteMealCard(meal: meal)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .contextMenu {
                                    Button(role: .destructive) {
                                        favoritesStore.toggleFavorite(meal.idMeal)
                                    } label: {
                                        Label("Remove from Favorites", systemImage: "heart.slash")
                                    }
                                }
                            }
                        }
                        .padding()
                        .padding(.bottom, 90) // Tab bar clearance
                    }
                    .refreshable {
                        await favoritesStore.loadFavoriteMeals()
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: String.self) { mealId in
                MealDetailView(mealId: mealId)
            }
            .onAppear {
                showTabBar = true
                if favoritesStore.favoriteMeals.isEmpty && !favoritesStore.favoriteIDs.isEmpty {
                    Task {
                        await favoritesStore.loadFavoriteMeals()
                    }
                }
            }
        }
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 70))
                .foregroundColor(.secondary)
            
            Text("No favorites yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap the heart on any meal to save it here")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
    
    // MARK: - Skeleton Grid
    
    private var favoritesGridSkeleton: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(0..<6, id: \.self) { _ in
                    VStack(alignment: .leading, spacing: 8) {
                        SkeletonCard(width: .infinity, height: 140, cornerRadius: 12)
                        SkeletonTitle(width: 120, height: 14)
                    }
                }
            }
            .padding()
        }
        .accessibilityHidden(true)
    }
    
    // MARK: - Error View
    
    private func errorView(error: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text("Error")
                .font(.headline)
            
            Text(error)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Retry") {
                Task {
                    await favoritesStore.retryLoadFavorites()
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

// MARK: - Favorite Meal Card

struct FavoriteMealCard: View {
    let meal: MealDetailDTO
    @EnvironmentObject var favoritesStore: FavoritesStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Meal image
            AsyncImage(url: URL(string: meal.strMealThumb ?? "")) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(ProgressView())
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                @unknown default:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                }
            }
            .frame(height: 140)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                ZStack(alignment: .topTrailing) {
                    LinearGradient(
                        colors: [Color.black.opacity(0.0), Color.black.opacity(0.2)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Favorite button
                    Button(action: {
                        favoritesStore.toggleFavorite(meal.idMeal)
                    }) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .padding(8)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            )
            
            // Meal title
            Text(meal.strMeal)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .lineLimit(2)
        }
    }
}

struct FavoritesScreen_Previews: PreviewProvider {
    @State static var showTabBar = true
    static var previews: some View {
        FavoritesScreen(showTabBar: $showTabBar)
            .environmentObject(DIContainer.preview())
            .environmentObject(DIContainer.preview().favoritesStore)
    }
}


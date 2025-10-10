import SwiftUI

struct MealsListView: View {
    @EnvironmentObject var diContainer: DIContainer
    @EnvironmentObject var favoritesStore: FavoritesStore
    @StateObject private var viewModel: MealsListViewModel
    let title: String
    
    init(category: String) {
        self.title = category
        _viewModel = StateObject(wrappedValue: DIContainer.shared.makeMealsListViewModel(category: category))
    }
    
    init(ingredient: String) {
        self.title = ingredient
        _viewModel = StateObject(wrappedValue: DIContainer.shared.makeMealsListViewModel(ingredient: ingredient))
    }
    
    var body: some View {
        ZStack {
            if viewModel.isLoading && viewModel.meals.isEmpty {
                ProgressView("Loading meals...")
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Text("Error")
                        .font(.headline)
                    Text(error)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        Task {
                            await viewModel.retry()
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(viewModel.meals) { meal in
                            NavigationLink(value: meal.idMeal) {
                                MealsListMealCard(meal: meal)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(for: String.self) { mealId in
            MealDetailView(mealId: mealId)
        }
        .onAppear {
            if viewModel.meals.isEmpty {
                Task {
                    await viewModel.load()
                }
            }
        }
    }
}

// MARK: - Meals List Meal Card

struct MealsListMealCard: View {
    let meal: MealSummaryDTO
    @EnvironmentObject var favoritesStore: FavoritesStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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
                        Image(systemName: favoritesStore.isFavorite(meal.idMeal) ? "heart.fill" : "heart")
                            .foregroundColor(favoritesStore.isFavorite(meal.idMeal) ? .red : .white)
                            .padding(8)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            )
            
            Text(meal.strMeal)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .lineLimit(2)
        }
    }
}


import SwiftUI

struct MealDetailView: View {
    @EnvironmentObject var diContainer: DIContainer
    @EnvironmentObject var favoritesStore: FavoritesStore
    @StateObject private var viewModel: MealDetailViewModel
    let mealId: String
    
    init(mealId: String) {
        self.mealId = mealId
        _viewModel = StateObject(wrappedValue: DIContainer.shared.makeMealDetailViewModel(mealId: mealId))
    }
    
    var body: some View {
        ZStack {
            if viewModel.isLoading && viewModel.meal == nil {
                ProgressView("Loading details...")
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
            } else if let meal = viewModel.meal {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Hero Image
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
                        .frame(height: 300)
                        .clipped()
                        
                        VStack(alignment: .leading, spacing: 16) {
                            // Title
                            Text(meal.strMeal)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            // Category and Area
                            HStack(spacing: 16) {
                                if let category = meal.strCategory {
                                    Label(category, systemImage: "tag")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                if let area = meal.strArea {
                                    Label(area, systemImage: "globe")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                // Favorite button
                                Button(action: {
                                    favoritesStore.toggleFavorite(meal.idMeal)
                                }) {
                                    Image(systemName: favoritesStore.isFavorite(meal.idMeal) ? "heart.fill" : "heart")
                                        .foregroundColor(favoritesStore.isFavorite(meal.idMeal) ? .red : .gray)
                                        .font(.title2)
                                }
                            }
                            
                            Divider()
                            
                            // Ingredients
                            if !meal.ingredients.isEmpty {
                                Text("Ingredients")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(meal.ingredients, id: \.ingredient) { item in
                                        HStack {
                                            Text("•")
                                            Text(item.ingredient)
                                            Spacer()
                                            Text(item.measure)
                                                .foregroundColor(.secondary)
                                        }
                                        .font(.subheadline)
                                    }
                                }
                                .padding(.vertical, 8)
                                
                                Divider()
                            }
                            
                            // Instructions
                            if let instructions = meal.strInstructions, !instructions.isEmpty {
                                Text("Instructions")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Text(instructions)
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding()
                    }
                }
                .ignoresSafeArea(edges: .top)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.meal == nil {
                Task {
                    await viewModel.load()
                }
            }
        }
    }
}


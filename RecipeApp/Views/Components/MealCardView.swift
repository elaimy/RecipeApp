import SwiftUI

struct MealCardView: View {
    let meal: MealSummaryDTO
    @EnvironmentObject var favoritesStore: FavoritesStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Meal image
            AsyncImage(url: URL(string: meal.strMealThumb ?? "")) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            ProgressView()
                        )
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
            .frame(width: 180, height: 120)
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
            
            // Meal title
            Text(meal.strMeal)
                .font(.headline)
                .lineLimit(2)
                .frame(width: 180, alignment: .leading)
        }
        .frame(width: 180)
    }
}


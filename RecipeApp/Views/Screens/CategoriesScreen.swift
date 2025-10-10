import SwiftUI

struct CategoriesScreen: View {
    @EnvironmentObject var diContainer: DIContainer
    @StateObject private var viewModel: CategoriesViewModel
    @Binding var showTabBar: Bool
    
    init(showTabBar: Binding<Bool> = .constant(true)) {
        self._showTabBar = showTabBar
        _viewModel = StateObject(wrappedValue: CategoriesViewModel(repository: DIContainer.shared.recipeRepository))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading && viewModel.categories.isEmpty {
                    // Loading state
                    categoriesGridSkeleton
                } else if let error = viewModel.errorMessage {
                    // Error state
                    errorView(error: error)
                } else {
                    // Content
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ], spacing: 16) {
                            ForEach(viewModel.categories) { category in
                                NavigationLink(value: category.strCategory) {
                                    CategoryCardView(category: category)
                                        .frame(height: 100)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                        .padding(.bottom, 90) // Tab bar clearance
                    }
                    .refreshable {
                        await viewModel.refresh()
                    }
                }
            }
            .navigationTitle("Categories")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: String.self) { category in
                MealsListView(category: category)
            }
            .onAppear {
                showTabBar = true
                if viewModel.categories.isEmpty {
                    Task {
                        await viewModel.load()
                    }
                }
            }
        }
    }
    
    // MARK: - Skeleton Grid
    
    private var categoriesGridSkeleton: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 16) {
                ForEach(0..<12, id: \.self) { _ in
                    SkeletonCategoryCard()
                        .frame(height: 100)
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
                    await viewModel.retry()
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

// MARK: - ViewModel

@MainActor
final class CategoriesViewModel: ObservableObject {
    @Published var categories: [CategoryDTO] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: RecipeRepositoryProtocol
    
    init(repository: RecipeRepositoryProtocol) {
        self.repository = repository
    }
    
    func load() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: CategoriesResponse = try await repository.getCategories()
            categories = response.categories
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Failed to load categories"
        }
    }
    
    func refresh() async {
        await load()
    }
    
    func retry() async {
        await load()
    }
}

struct CategoriesScreen_Previews: PreviewProvider {
    @State static var showTabBar = true
    static var previews: some View {
        CategoriesScreen(showTabBar: $showTabBar)
            .environmentObject(DIContainer.preview())
    }
}


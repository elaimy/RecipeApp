//
//  HomeScreen.swift
//  RecipeApp
//
//  Created by Ahmed Elelaimy
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var diContainer: DIContainer
    @StateObject private var viewModel: HomeViewModel
    @Binding var showTabBar: Bool
    
    init(showTabBar: Binding<Bool> = .constant(true)) {
        self._showTabBar = showTabBar
        _viewModel = StateObject(wrappedValue: DIContainer.shared.makeHomeViewModel())
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Top Dishes section
                    topDishesSection
                    
                    // Chef's Picks section
                    chefsPicksSection
                    
                    // Ingredient Spotlight section
                    ingredientSpotlightSection
                }
                .padding(.vertical, 16)
                .padding(.bottom, 90) // Tab bar clearance
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemBackground))
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .mealDetail(let id):
                    MealDetailView(mealId: id)
                case .categoryList(let category):
                    MealsListView(category: category)
                case .ingredientList(let ingredient):
                    MealsListView(ingredient: ingredient)
                }
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
    
    // MARK: - Top Dishes Section
    
    private var topDishesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top Dishes")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            if let error = viewModel.topDishesError {
                sectionErrorView(message: error) {
                    Task {
                        await viewModel.retryTopDishes()
                    }
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        if viewModel.isLoadingTopDishes {
                            ForEach(viewModel.topDishesPlaceholders, id: \.self) { _ in
                                SkeletonMealCard()
                            }
                        } else {
                            ForEach(viewModel.topMeals) { meal in
                                NavigationLink(value: NavigationDestination.mealDetail(meal.idMeal)) {
                                    MealCardView(meal: meal)
                                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.isLoadingTopDishes)
                }
            }
        }
    }
    
    // MARK: - Chef's Picks Section
    
    private var chefsPicksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Chef's Picks")
                    .font(.title2)
                    .fontWeight(.semibold)
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            .padding(.horizontal)
            
            if let error = viewModel.chefsPicksError {
                sectionErrorView(message: error) {
                    Task {
                        await viewModel.retryChefsPicks()
                    }
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        if viewModel.isLoadingChefsPicks {
                            ForEach(viewModel.chefsPicksPlaceholders, id: \.self) { _ in
                                SkeletonMealCard()
                            }
                        } else {
                            ForEach(viewModel.chefsPicks) { meal in
                                NavigationLink(value: NavigationDestination.mealDetail(meal.idMeal)) {
                                    MealCardView(meal: meal)
                                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.isLoadingChefsPicks)
                }
            }
        }
    }
    
    // MARK: - Ingredient Spotlight Section
    
    private var ingredientSpotlightSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ingredient Spotlight")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            if let error = viewModel.ingredientsError {
                sectionErrorView(message: error) {
                    Task {
                        await viewModel.retryIngredients()
                    }
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        if viewModel.isLoadingIngredients {
                            ForEach(viewModel.ingredientsPlaceholders, id: \.self) { _ in
                                SkeletonIngredientCard()
                            }
                        } else {
                            ForEach(viewModel.ingredients) { ingredient in
                                NavigationLink(value: NavigationDestination.ingredientList(ingredient.strIngredient)) {
                                    IngredientCardView(ingredient: ingredient)
                                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.isLoadingIngredients)
                }
            }
        }
    }
    
    // MARK: - Error View
    
    private func sectionErrorView(message: String, retry: @escaping () -> Void) -> some View {
        HStack {
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: retry) {
                Text("Retry")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(6)
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Navigation Destination

enum NavigationDestination: Hashable {
    case mealDetail(String)
    case categoryList(String)
    case ingredientList(String)
}

struct HomeScreen_Previews: PreviewProvider {
    @State static var showTabBar = true
    static var previews: some View {
        HomeScreen(showTabBar: $showTabBar)
            .environmentObject(DIContainer.preview())
    }
}

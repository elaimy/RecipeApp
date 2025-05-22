//
//  TabBar.swift
//  RecipeApp
//
//  Created by Ahmed Elelaimy
//

import SwiftUI

/// Enum for tab bar items
enum TabBarItem: String, CaseIterable, Identifiable {
    case home, categories, favorites, profile
    
    var id: String { rawValue }
    
    var activeIcon: String {
        switch self {
        case .home: return "homeActive"
        case .categories: return "categoriesActive"
        case .favorites: return "favoritesActive"
        case .profile: return "profileActive"
        }
    }
    
    var inactiveIcon: String {
        switch self {
        case .home: return "homeInactive"
        case .categories: return "categoriesInactive"
        case .favorites: return "favoritesInactive"
        case .profile: return "profileInactive"
        }
    }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .categories: return "Categories"
        case .favorites: return "Favorites"
        case .profile: return "Profile"
        }
    }
}

/// Custom TabBar component
struct TabBar: View {
    @Binding var selected: TabBarItem
    
    var body: some View {
        HStack {
            ForEach(TabBarItem.allCases) { item in
                Spacer()
                Button(action: {
                    selected = item
                }) {
                    VStack(spacing: 0) {
                        Spacer()
                        Image(item == selected ? item.activeIcon : item.inactiveIcon)
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(item == selected ? ColorManager.primary : ColorManager.inActiveIcon)
                        Spacer().frame(height: 8)
                    }
                }
                Spacer()
            }
        }
        .frame(height: 50)
        .background(Color.white.ignoresSafeArea(edges: .bottom))
        .shadow(color: Color.black.opacity(0.04), radius: 8, y: -2)
    }
}

// MARK: - Preview

struct TabBar_Previews: PreviewProvider {
    @State static var selected: TabBarItem = .home
    static var previews: some View {
        TabBar(selected: $selected)
            .previewLayout(.sizeThatFits)
    }
} 

//
//  HomeScreen.swift
//  RecipeApp
//
//  Created by Ahmed Elelaimy
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var diContainer: DIContainer
    @Binding var showTabBar: Bool
    
    // Add an initializer that doesn't require the binding
    init(showTabBar: Binding<Bool> = .constant(true)) {
        self._showTabBar = showTabBar
    }

    var body: some View {
        VStack(spacing: 20) {
            // Home screen content
            Text("Home Screen")
                .font(.largeTitle)
                .padding()
            
            // Button to navigate to detailed home view
            Button("View Recipe Details") {
                diContainer.router.navigateToTab(.home)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onAppear { 
            showTabBar = true
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    @State static var showTabBar = true
    static var previews: some View {
        HomeScreen(showTabBar: $showTabBar)
            .environmentObject(DIContainer.preview())
    }
} 
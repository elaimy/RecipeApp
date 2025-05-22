//
//  WelcomeScreen.swift
//  RecipeApp
//
//  Created by Ahmed Elelaimy
//

import SwiftUI

struct WelcomeScreen: View {
    @EnvironmentObject var diContainer: DIContainer
    
    var body: some View {
        ZStack(alignment: .top) {
            // White background for the entire screen
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            // Background image at the top extending to status bar
            BackgroundImageView()
            
            // Content starts from safe area in a VStack
            VStack(spacing: 0) {
                // Title
                TitleView()
                    .padding(.top, 44)
                
                // Welcome vector with spacing of 12 from title
                WelcomeVectorView()
                    .padding(.top, 12)
                
                // Description text with specified spacing
                DescriptionView()
                    .padding(.top, 28)
                    .padding(.horizontal, 24)
                
                Spacer()
                
                // Get Started button
                MainButton(title: "Get Started") {
                    // Force the navigation to happen
                    DispatchQueue.main.async {
                        diContainer.router.navigateToHome()
                    }
                }
                .padding(.bottom, 40)
            }
            .padding(.top, 20)
        }
    }
}

// MARK: - Component Views

/// Background image that extends to the status bar
struct BackgroundImageView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image("welcomeBG")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width)
        }
        .edgesIgnoringSafeArea(.top)
    }
}

/// Title text component
struct TitleView: View {
    var body: some View {
        Text("Food Recipes")
            .font(.system(size: 32, weight: .semibold))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
    }
}

/// Welcome vector image component
struct WelcomeVectorView: View {
    var body: some View {
        Image("welcomeVector")
            .aspectRatio(contentMode: .fill)
    }
}

/// Description text component
struct DescriptionView: View {
    var body: some View {
        Text("Start your day off right\n with these tasty recipes")
            .font(.system(size: 16))
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .lineSpacing(12)
            .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Preview

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
            .environmentObject(DIContainer.preview())
    }
} 


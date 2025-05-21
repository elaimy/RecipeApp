import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var diContainer: DIContainer
    @State private var selectedTab: TabBarItem = .home
    @State private var showTabBar: Bool = true

    var body: some View {
        NavigationStack(path: $diContainer.router.navPath) {
            ZStack(alignment: .bottom) {
                // Main content
                Group {
                    switch selectedTab {
                    case .home:
                        HomeScreen(showTabBar: $showTabBar)
                    case .categories:
                        Text("Categories Screen")
                            .font(.largeTitle)
                    case .favorites:
                        Text("Favorites Screen")
                            .font(.largeTitle)
                    case .profile:
                        Text("Profile Screen")
                            .font(.largeTitle)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // TabBar at the bottom, respecting safe area
                if showTabBar {
                    TabBar(selected: $selectedTab)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationDestination(for: AppRouter.Destination.self) { destination in
                switch destination {
                case .home:
                    Text("Detailed Home View")
                        .font(.largeTitle)
                case .categories:
                    Text("Detailed Categories View")
                        .font(.largeTitle)
                case .favorites:
                    Text("Detailed Favorites View")
                        .font(.largeTitle)
                case .profile:
                    Text("Detailed Profile View")
                        .font(.largeTitle)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back to Welcome") {
                        diContainer.router.navigateToWelcome()
                    }
                }
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(DIContainer.preview())
    }
} 
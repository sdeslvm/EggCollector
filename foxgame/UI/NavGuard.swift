import Foundation


enum AvailableScreens {
    case MENU
    case SHOP
    case SETTINGS
    case ACHIVE
    case GAME
    case GAMELEVELS
}

class NavGuard: ObservableObject {
    @Published var currentScreen: AvailableScreens = .MENU
    static var shared: NavGuard = .init()
}

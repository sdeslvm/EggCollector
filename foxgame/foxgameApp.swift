import SwiftUI

@main
struct foxgameApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {

        print(OrientationManager.shared.isHorizontalLock)
        if OrientationManager.shared.isHorizontalLock {
            return .landscape
        } else {
            return .allButUpsideDown
        }
    }
}

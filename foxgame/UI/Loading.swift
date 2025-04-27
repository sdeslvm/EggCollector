import SwiftUI

struct Loading: View {
    @State var isShowGreeting: Bool = false
    @State var isLoaded: Bool = false
    @AppStorage("isGreetingShown") var isGreetingShown: Bool?
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            CurrentBackground()
            StrokedText(text: "Loading...", size: 64)
            if isLoaded {
                if isShowGreeting || isGreetingShown ?? false {
                    GreetingWrapper(link: StrokedText.greeting)
                        .background(ignoresSafeAreaEdges: .all)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                UIDevice.current.setValue(UIInterfaceOrientation.unknown.rawValue, forKey: "orientation")
                                UIViewController.attemptRotationToDeviceOrientation()
                            }
                        }
                } else {
                    Main()
                }
            }
        }
        .onAppear {
            inGreetingNeedToBeShown()
        }
    }
    
    private func inGreetingNeedToBeShown() {
        Task {
            if await Network().inGreetingNeedToBeShown() {
                isShowGreeting = true
                isGreetingShown = true
            }
            isLoaded = true
        }
    }
}



#Preview {
    Loading()
}

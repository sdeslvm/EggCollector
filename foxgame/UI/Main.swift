import SwiftUI

struct Main: View {
    @AppStorage("coinscore") var coinscore: Int = 0
    var body: some View {
        ZStack {
            CurrentBackground()
            VStack(alignment: .trailing, spacing: 0) {
                HStack(alignment: .top) {
                    Button {
                        NavGuard.shared.currentScreen = .SETTINGS
                    } label: {
                        Assets.UIElements.settings
                            .frame(width: 60, height: 60)
                    }
                    
                    Spacer()
                    
                    CoinsCounter(text: "\(coinscore)")

                }
                HStack {
                    VStack(spacing: 0) {
                        WoodenButton(text: "Play") {
                            NavGuard.shared.currentScreen = .GAMELEVELS
                        }
                        WoodenButton(text: "Shop") {
                            NavGuard.shared.currentScreen = .SHOP
                        }
                        WoodenButton(text: "Achievements", size: 16) {
                            NavGuard.shared.currentScreen = .ACHIVE
                        }
                    }
                    Rectangle()
                        .opacity(0)
                        .frame(width: 40)
                }
            }.padding(.vertical)
        }
    }
}

#Preview {
    Main()
}

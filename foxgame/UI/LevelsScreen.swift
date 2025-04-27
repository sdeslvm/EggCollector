import SwiftUI

struct LevelsView: View {
    @AppStorage("stage") private var unlockedLevels: Int = 1
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: -350), count: 4)
    let totalLevels = 10
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    HStack {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding()
                            .foregroundStyle(.white)
                            .onTapGesture {
                                NavGuard.shared.currentScreen = .MENU
                            }
                        Spacer()
                    }
                    Spacer()
                }
                
                Image(.levelPlate)
                    .resizable()
                    .scaledToFit()
                    

                VStack {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 0) {
                            ForEach(1...totalLevels, id: \.self) { level in
                                LevelButton(level: level, isUnlocked: level <= unlockedLevels)
    //                                .frame(width: 80, height: 80)
                            }
                        }
                    }
                }
                .padding(.top, 130)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.background1)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
    }
}

struct LevelButton: View {
    let level: Int
    let isUnlocked: Bool
    
    var body: some View {
        Button(action: {
            if isUnlocked {
                NavGuard.shared.currentScreen = .GAME
            }
        }) {
            ZStack {
                Image(String(level))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .opacity(isUnlocked ? 1 : 0.5)
                
                if !isUnlocked {
                    Color.black.opacity(0.1)
                        .frame(width: 60, height: 60)
                }
            }
        }
        .disabled(!isUnlocked)
    }
}

#Preview {
    LevelsView()
}


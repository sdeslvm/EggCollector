

import SwiftUI

struct ContentView: View {
    @AppStorage("whiteegg") var egg1 = 0
    @AppStorage("blueegg") var egg2 = 0
    @AppStorage("pinkegg") var egg3 = 0
    @AppStorage("whiteEggCount") var whiteEggCount = 0
    @AppStorage("blueEggCount") var blueEggCount = 0
    @AppStorage("pinkEggCount") var pinkEggCount = 0
    @AppStorage("lifeBalance") var life = 5
    @AppStorage("lifeBalanceNew") var lifeNew = 20
    @AppStorage("field") var selectedField: Int = 1
    @AppStorage("achievmentA1") var achievmentA1 = false
    
    @State private var isWin = false
    @State private var isLose = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                if isWin {
                                WinView()
                            } else if isLose {
                                LoseView()
                            } else {
                                GameViewController(sceneSize: .init(width: geometry.size.width, height: geometry.size.height))
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                
                                VStack {
                                    HStack {
                                        Image("back")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                            .onTapGesture {
                                                NavGuard.shared.currentScreen = .MENU
                                            }
                                            .zIndex(1000)
                                        Spacer()
                                        PinkEggBalance()
                                        Spacer()
                                        WhiteEggBalance()
                                        Spacer()
                                        BlueEggBalance()
                                        Spacer()
                                        LifeBalance()
                                    }
                                    Spacer()
                                }
                            }
                

            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image("field\(selectedField)2")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
        .onAppear {
            egg1 = 0
            egg2 = 0
            egg3 = 0
            achievmentA1 = true
            if lifeNew == 0 {
                lifeNew = 10
            }
        }
        .onDisappear {
            blueEggCount = 0
            whiteEggCount = 0
            pinkEggCount = 0
            lifeNew -= 1
        }
        .onChange(of: egg1) { _ in checkWinCondition() }
        .onChange(of: egg2) { _ in checkWinCondition() }
        .onChange(of: egg3) { _ in checkWinCondition() }
        .onChange(of: life) { _ in checkLoseCondition() }
    }
    
    private func checkWinCondition() {
            // Проверяем условие победы
            if egg1 != 0 && egg1 == whiteEggCount &&
               egg2 != 0 && egg2 == blueEggCount &&
               egg3 != 0 && egg3 == pinkEggCount {
                isWin = true
            }
        }
    
    
    private func checkLoseCondition() {
            // Проверяем условие поражения
            if life < 5 {
                isLose = true // Устанавливаем состояние поражения
            }
        }
}


struct WinView: View {
    @AppStorage("coinscore") var coinscore: Int = 0
    @AppStorage("stage") var stage: Int = 1

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.winPlate)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .onTapGesture {
                        stage += 1
                        coinscore += 20
                        NavGuard.shared.currentScreen = .MENU
                    }
            }
        }
    }
}

struct LoseView: View {
    @AppStorage("coinscore") var coinscore: Int = 10
    @AppStorage("stage") var stage: Int = 1

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.losePlate)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .onTapGesture {
                        NavGuard.shared.currentScreen = .MENU
                    }
            }
        }
    }
}





struct LifeBalance: View {
    @AppStorage("lifeBalanceNew") var life = 5
    var body: some View {
        ZStack {
            Image(.lifeBalance)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 70)
                .overlay(
                    ZStack {
                        Text("\(life)")
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .font(.title3)
                            .position(x: 90, y: 32)
                    }
                )
        }
    }
}

struct WhiteEggBalance: View {
    @AppStorage("whiteegg") var egg = 0
    @AppStorage("whiteEggCount") var whiteEggCount = 0

    
    var body: some View {
        ZStack {
            Image(.balanceWhiteEgg)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 70)
                .overlay(
                    ZStack {
                        Text("\(egg)/\(whiteEggCount)")
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .font(.title3)
                            .position(x: 90, y: 32)
                    }
                )
        }
    }
}

struct BlueEggBalance: View {
    @AppStorage("blueegg") var egg = 0
    @AppStorage("blueEggCount") var blueEggCount = 0
    
    var body: some View {
        ZStack {
            Image(.balanceBlueEgg)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 70)
                .overlay(
                    ZStack {
                        Text("\(egg)/\(blueEggCount)")
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .font(.title3)
                            .position(x: 90, y: 32)
                    }
                )
        }
    }
}

struct PinkEggBalance: View {
    @AppStorage("pinkegg") var egg = 0
    @AppStorage("pinkEggCount") var pinkEggCount = 0
    
    
    var body: some View {
        ZStack {
            Image(.balancePinkEgg)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 70)
                .overlay(
                    ZStack {
                        Text("\(egg)/\(pinkEggCount)")
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .font(.title3)
                            .position(x: 90, y: 32)
                    }
                )
        }
    }
}

#Preview {
    ContentView()
}

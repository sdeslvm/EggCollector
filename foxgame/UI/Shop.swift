import SwiftUI

struct Shop: View {
enum Section: CaseIterable {
    case field
    case player
    case step
}

@State var currentSection: Section = .field
@State var sectionIndex: Int = 0
@AppStorage("field") var selectedField: Int = 1
@AppStorage("player") var selectedFox: Int = 1
@AppStorage("step") var selectedStep: Int = 1
@AppStorage("coinscore") var coinscore: Int = 0
@State private var showInsufficientFundsAlert = false // Для модального окна

var body: some View {
    GeometryReader { geometry in
        ZStack(alignment: .top) {
            CurrentBackground()
            HStack(alignment: .top) {
                Button {
                    NavGuard.shared.currentScreen = .MENU
                } label: {
                    Assets.UIElements.back
                        .frame(width: 60, height: 60)
                }
                
                Spacer()
                
                CoinsCounter(text: "\(coinscore)")
            }.padding(.vertical)
            ZStack {
                Assets.ShopItems.shopFrame
                    .frame(width: geometry.size.width * 0.6, height: geometry.size.height - 70)
              
                switch currentSection {
                case .field: field
                case .player: player
                case .step: step
                }
                HStack {
                    Button {
                        downIndex()
                    } label: {
                        Assets.UIElements.back
                            .frame(width: 50, height: 50)
                    }
                    Spacer()
                    Button {
                        upIndex()
                    } label: {
                        Assets.UIElements.forward
                            .frame(width: 50, height: 50)
                    }
                }
                .padding(.top, geometry.size.height / 2)
                .frame(width: geometry.size.width * 0.6)
            }.padding(.top, 60)
        }
        // Модальное окно
        .overlay {
            if showInsufficientFundsAlert {
                InsufficientFundsAlert(isPresented: $showInsufficientFundsAlert)
            }
        }
    }
}

var field: some View {
    HStack {
        ZStack {
            Assets.ShopItems.field1
                .frame(width: 80, height: 80)
            SmallButton(selectedIndex: $selectedField, index: 1, coinscore: $coinscore, showAlert: $showInsufficientFundsAlert)
        }
        ZStack {
            Assets.ShopItems.field2
                .frame(width: 80, height: 80)
            SmallButton(selectedIndex: $selectedField, index: 2, coinscore: $coinscore, showAlert: $showInsufficientFundsAlert)
        }
        ZStack {
            Assets.ShopItems.field3
                .frame(width: 80, height: 80)
            SmallButton(selectedIndex: $selectedField, index: 3, coinscore: $coinscore, showAlert: $showInsufficientFundsAlert)
        }
        ZStack {
            Assets.ShopItems.field4
                .frame(width: 80, height: 80)
            SmallButton(selectedIndex: $selectedField, index: 4, coinscore: $coinscore, showAlert: $showInsufficientFundsAlert)
        }
    }.padding(.top, 40)
}

var player: some View {
    VStack {
        HStack {
            ZStack {
                Assets.ShopItems.shopFox
                    .frame(width: 80, height: 80)
                Assets.Player.fox11
                    .frame(width: 45, height: 55)
                SmallButton(selectedIndex: $selectedFox, index: 1, coinscore: $coinscore, showAlert: $showInsufficientFundsAlert)
            }
            ZStack {
                Assets.ShopItems.shopFox
                    .frame(width: 80, height: 80)
                Assets.Player.fox21
                    .frame(width: 45, height: 55)
                SmallButton(selectedIndex: $selectedFox, index: 2, coinscore: $coinscore, showAlert: $showInsufficientFundsAlert)
            }
            ZStack {
                Assets.ShopItems.shopFox
                    .frame(width: 80, height: 80)
                Assets.Player.fox31
                    .frame(width: 45, height: 55)
                SmallButton(selectedIndex: $selectedFox, index: 3, coinscore: $coinscore, showAlert: $showInsufficientFundsAlert)
            }
            ZStack {
                Assets.ShopItems.shopFox
                    .frame(width: 80, height: 80)
                Assets.Player.fox41
                    .frame(width: 45, height: 55)
                SmallButton(selectedIndex: $selectedFox, index: 4, coinscore: $coinscore, showAlert: $showInsufficientFundsAlert)
            }
        }
        HStack {
            ZStack {
                Assets.ShopItems.shopFox
                    .frame(width: 80, height: 80)
                Assets.Player.fox51
                    .frame(width: 45, height: 55)
                SmallButton(selectedIndex: $selectedFox, index: 5, coinscore: $coinscore, showAlert: $showInsufficientFundsAlert)
            }
            ZStack {
                Assets.ShopItems.shopFox
                    .frame(width: 80, height: 80)
                Assets.Player.fox61
                    .frame(width: 45, height: 55)
                SmallButton(selectedIndex: $selectedFox, index: 6, coinscore: $coinscore, showAlert: $showInsufficientFundsAlert)
            }
            ZStack {
                Assets.ShopItems.shopFox
                    .frame(width: 80, height: 80)
                Assets.Player.fox71
                    .frame(width: 45, height: 55)
                SmallButton(selectedIndex: $selectedFox, index: 7, coinscore: $coinscore, showAlert: $showInsufficientFundsAlert)
            }
        }
    }.padding(.top, 60)
}

var step: some View {
    HStack {
        ZStack {
            Assets.ShopItems.shopStep
                .frame(width: 80, height: 80)
            currentPlayer(selectedFox: selectedFox)
                .frame(width: 35, height: 45)
                .offset(x: -10, y: -6)
            Assets.Steps.step1
                .frame(width: 30, height: 8)
                .offset(x: 14, y: 14)
            SmallButton(selectedIndex: $selectedStep, index: 1, coinscore: $coinscore, showAlert: $showInsufficientFundsAlert)
        }
        ZStack {
            Assets.ShopItems.shopStep
                .frame(width: 80, height: 80)
            currentPlayer(selectedFox: selectedFox)
                .frame(width: 35, height: 45)
                .offset(x: -10, y: -6)
            Assets.Steps.step2
                .frame(width: 30, height: 8)
                .offset(x: 14, y: 14)
            SmallButton(selectedIndex: $selectedStep, index: 2, coinscore: $coinscore, showAlert: $showInsufficientFundsAlert)
        }
        ZStack {
            Assets.ShopItems.shopStep
                .frame(width: 80, height: 80)
            currentPlayer(selectedFox: selectedFox)
                .frame(width: 35, height: 45)
                .offset(x: -10, y: -6)
            Assets.Steps.step3
                .frame(width: 30, height: 8)
                .offset(x: 14, y: 14)
            SmallButton(selectedIndex: $selectedStep, index: 3, coinscore: $coinscore, showAlert: $showInsufficientFundsAlert)
        }
        ZStack {
            Assets.ShopItems.shopStep
                .frame(width: 80, height: 80)
            currentPlayer(selectedFox: selectedFox)
                .frame(width: 35, height: 45)
                .offset(x: -10, y: -6)
            Assets.Steps.step4
                .frame(width: 30, height: 8)
                .offset(x: 14, y: 14)
            SmallButton(selectedIndex: $selectedStep, index: 4, coinscore: $coinscore, showAlert: $showInsufficientFundsAlert)
        }
    }.padding(.top, 40)
}

func currentPlayer(selectedFox: Int) -> Image {
    Image("fox\(selectedFox)1")
        .resizable()
}

func upIndex() {
    guard sectionIndex < 2 else {
        sectionIndex = 0
        currentSection = .allCases[sectionIndex]
        return
    }
    sectionIndex += 1
    currentSection = .allCases[sectionIndex]
}

func downIndex() {
    guard sectionIndex > 0 else {
        sectionIndex = 2
        currentSection = .allCases[sectionIndex]
        return
    }
    sectionIndex -= 1
    currentSection = .allCases[sectionIndex]
}
}

struct SmallButton: View {
    @Binding var selectedIndex: Int
    let index: Int
    @Binding var coinscore: Int
    @Binding var showAlert: Bool
    var body: some View {
        Button {
            if coinscore >= 50 {
                coinscore -= 50 // Списываем 50 монет
                selectedIndex = index // Обновляем выбор
            } else {
                showAlert = true // Показываем модальное окно
            }
        } label: {
            ZStack {
                Assets.UIElements.smallButton
                    .frame(width: 70, height: 24)
                StrokedText(text: selectedIndex == index ? "Selected" : "Select", size: 12, strokeWidth: 0.5)
            }
            .padding(.top, 70)
        }
    }
}

struct InsufficientFundsAlert: View { @Binding var isPresented: Bool
    var body: some View {
        ZStack {
            Color.black.opacity(0.4) // Полупрозрачный фон
                .ignoresSafeArea()
            VStack {
                Text("Not enough coins!")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                Button {
                    isPresented = false // Закрываем окно
                } label: {
                    Text("OK")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 100)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
            }
            .frame(width: 200, height: 150)
            .background(Color.black.opacity(0.8))
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
}

#Preview { Shop() }

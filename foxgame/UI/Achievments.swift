import SwiftUI

struct Achievments: View {
    
    @AppStorage("achievmentA1") var achievmentA1 = false
    @AppStorage("achievmentA2") var achievmentA2 = false
    @AppStorage("achievmentA3") var achievmentA3 = false
    @AppStorage("achievmentA4") var achievmentA4 = false
    @AppStorage("achievmentA5") var achievmentA5 = false

    

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CurrentBackground()
                VStack {
                    HStack {
                        Button {
                            NavGuard.shared.currentScreen = .MENU
                        } label: {
                            Assets.UIElements.back
                                .frame(width: 60, height: 60)
                        }
                        
                        Spacer()
                        
    //                    CoinsCounter(text: "100")

                    }
                    Spacer()
                }
                ZStack {
                    Assets.UIElements.bigFrame
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height - 30)
//                    StrokedText(text: "Achievements")
                        .padding(8)
                    VStack(spacing: 0) {
                        HStack(alignment: .top, spacing: -60) {
                            Achievment(isArchieved: achievmentA1, index: 1, title: "First Egg", text: "Collect the first egg")
                            Achievment(isArchieved: achievmentA2, index: 2, title: "First Victory", text: "Complete first level")
                            Achievment(isArchieved: achievmentA3, index: 3, title: "Fox Scout", text: "Complete 10 levels")
                        }
                        
                        HStack(alignment: .top, spacing: -20) {
                            Achievment(isArchieved: achievmentA4, index: 4, title: "Master Hunter", text: "Complete 20 levels")
                            Achievment(isArchieved: achievmentA5, index: 5, title: "Elusive Fox", text: "Run away from the chicken 5 times")
                        }
                    }.padding(.top, 90)
                }.padding(.top, 30)
            }
        }
    }
}

struct Achievment: View {
    var isArchieved: Bool
    let index: Int
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            currentAchievement(index)
                .frame(width: 60, height: 60)
                .colorMultiply(isArchieved ? .white : .gray.opacity(0.4))
            StrokedText(text: title, size: 20)
            StrokedText(text: text, size: 12, strokeWidth: 0.5)
        }
        .frame(width: 200, height: 110)
    }
    
    func currentAchievement(_ ach: Int) -> Image {
        Image("a\(ach)")
            .resizable()
    }
}

#Preview {
    Achievments() 
}

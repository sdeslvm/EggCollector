import SwiftUI

struct Settings: View {

    @ObservedObject var settings = CheckingSound()
    
//    @AppStorage("music") var isMusicOn = true
//    @AppStorage("sound") var isSoundOn = true

    var body: some View {
        GeometryReader { geometry in
            ZStack() {
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
//                    StrokedText(text: "Settings")
                        .padding(8)
                    VStack {
                        sounds
                        music
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            
        }
        
    }
    
    var sounds: some View {
        VStack(spacing: 4) {
            StrokedText(text: "Sound", size: 32)
            HStack {
                Button {
                    settings.isSoundOn = false
                } label: {
                    StrokedText(text: "Off", size: 32)
                }

                Button {
                    settings.isSoundOn.toggle()
                } label: {
                    if settings.isSoundOn {
                        Assets.UIElements.soundOff
                            .frame(width: 120, height: 40)
                    } else {
                        Assets.UIElements.soundOn
                            .frame(width: 120, height: 40)
                    }
                }
                
                Button {
                    settings.isSoundOn = true
                } label: {
                    StrokedText(text: "On", size: 32)
                }
            }
        }
    }
    
    var music: some View {
        VStack(spacing: 4) {
            StrokedText(text: "Music", size: 32)
            HStack {
                Button {
                    settings.isMusicOn = false
                } label: {
                    StrokedText(text: "Off", size: 32)
                }

                Button {
                    settings.isMusicOn.toggle()
                } label: {
                    if settings.isMusicOn {
                        Assets.UIElements.soundOff
                            .frame(width: 120, height: 40)
                    } else {
                        Assets.UIElements.soundOn
                            .frame(width: 120, height: 40)
                    }
                }
                
                Button {
                    settings.isMusicOn = true
                } label: {
                    StrokedText(text: "On", size: 32)
                }
            }
        }
    }
}

#Preview {
    Settings() 
}

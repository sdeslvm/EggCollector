import Foundation
import SwiftUI

class CheckingSound: ObservableObject {
    @AppStorage("music") var isMusicOn = true {
        didSet {
            SoundManager.shared.isSoundOn = isMusicOn
        }
    }
    @AppStorage("sound") var isSoundOn = true
}

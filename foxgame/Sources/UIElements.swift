import SwiftUI

struct CurrentBackground: View {
    var body: some View {
        GeometryReader { geo in
            Assets.UIElements.background
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
        }.ignoresSafeArea()
    }
}

struct WoodenButton: View {
    var text: String
    var size: CGFloat
    var onTap: () -> Void
    
    init(text: String, size: CGFloat = 30, onTap: @escaping () -> Void) {
        self.text = text
        self.size = size
        self.onTap = onTap
    }
    
    var body: some View {
        Button {
            onTap()
        } label: {
            ZStack {
                Assets.UIElements.mainButtonFrame
                    .frame(width: 140, height: 90)
                StrokedText(text: text, size: size)
                    .offset(x: 0, y: -6)
            }
        }
    }
}

struct CoinsCounter: View {
    var text: String
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Assets.UIElements.coinsFrame
                .frame(width: 160, height: 70)
            HStack {
                Assets.UIElements.coin
                    .frame(width: 40, height: 40)
                    .padding()
                StrokedText(text: text, size: 24)
            }.offset(x: 0, y: -4)
        }
    }
}


#Preview {
    WoodenButton(text: "100") { }
}

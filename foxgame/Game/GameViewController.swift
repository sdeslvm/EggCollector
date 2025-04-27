import Foundation
import SwiftUI
import SpriteKit

struct GameViewController: UIViewControllerRepresentable {
    var sceneSize: CGSize

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let skView = SKView(frame: CGRect(origin: .zero, size: sceneSize))
        skView.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(skView)

        // Устанавливаем constraints для SKView
        NSLayoutConstraint.activate([
            skView.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            skView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            skView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            skView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
        ])

        // Создаём сцену с правильным размером
        let scene = GameScene(size: sceneSize)
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)

        // Добавляем джойстик
        let joystickSize: CGFloat = 120
        let joystick = Joystick(frame: CGRect(
            x: sceneSize.width - joystickSize - 20,
            y: sceneSize.height - joystickSize - 50,
            width: joystickSize, height: joystickSize))
        joystick.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        viewController.view.addSubview(joystick)
        scene.joystick = joystick

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

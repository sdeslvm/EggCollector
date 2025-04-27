import Foundation
import UIKit

class Joystick: UIView {
    var x: CGFloat = 0 // Горизонтальное смещение (-1.0 до 1.0)
    var y: CGFloat = 0 // Вертикальное смещение (-1.0 до 1.0)
    private let centerCircle = UIView() // Центральный кружок

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        self.layer.cornerRadius = frame.width / 2
        isUserInteractionEnabled = true

        // Настройка центрального кружка
        centerCircle.frame = CGRect(x: 0, y: 0, width: frame.width / 3, height: frame.height / 3)
        centerCircle.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        centerCircle.backgroundColor = UIColor.darkGray
        centerCircle.layer.cornerRadius = centerCircle.frame.width / 2
        self.addSubview(centerCircle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        updateJoystickPosition(touch: touch)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        updateJoystickPosition(touch: touch)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetJoystick()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetJoystick()
    }

    private func updateJoystickPosition(touch: UITouch) {
        let location = touch.location(in: self)

        // Вычисляем смещение от центра джойстика
        let dx = location.x - self.bounds.midX
        let dy = location.y - self.bounds.midY

        // Ограничиваем движение кружка в пределах джойстика
        let distance = sqrt(dx * dx + dy * dy)
        let maxDistance = self.bounds.width / 2 - centerCircle.bounds.width / 2
        if distance > maxDistance {
            let angle = atan2(dy, dx)
            centerCircle.center = CGPoint(
                x: self.bounds.midX + cos(angle) * maxDistance,
                y: self.bounds.midY + sin(angle) * maxDistance
            )
        } else {
            centerCircle.center = CGPoint(
                x: self.bounds.midX + dx,
                y: self.bounds.midY + dy
            )
        }

        // Нормализуем значения x и y в диапазон от -1.0 до 1.0
        x = dx / maxDistance
        y = -dy / maxDistance // Инвертируем y для правильного направления
    }

    private func resetJoystick() {
        // Возвращаем центральный кружок в исходное положение
        centerCircle.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        x = 0
        y = 0
    }
}

import UIKit
import SnapKit

class Theme {
    // MARK: - Colors
    enum Colors {
        // Primary Gradient
        static let primary = UIColor(hex: "#7C5CFF")        // Vibrant Purple
        static let primaryLight = UIColor(hex: "#A78BFA")   // Light Purple
        static let secondary = UIColor(hex: "#06D6A0")      // Mint Green
        static let accent = UIColor(hex: "#FF6B9D")          // Coral Pink
        static let accentOrange = UIColor(hex: "#FF9F43") // Warm Orange

        // Backgrounds
        static let backgroundDark = UIColor(hex: "#0A0A12")   // Near Black
        static let backgroundCard = UIColor(hex: "#14141F")  // Dark Card
        static let backgroundElevated = UIColor(hex: "#1E1E2D") // Elevated Surface

        // Text
        static let textPrimary = UIColor.white
        static let textSecondary = UIColor(hex: "#9090A5")
        static let textMuted = UIColor(hex: "#6B6B80")

        // Semantic
        static let success = UIColor(hex: "#34D399")
        static let warning = UIColor(hex: "#FBBF24")
        static let error = UIColor(hex: "#F87171")

        // Mood Colors
        static let moodHappy = UIColor(hex: "#34D399")
        static let moodCalm = UIColor(hex: "#06D6A0")
        static let moodAnxious = UIColor(hex: "#FBBF24")
        static let moodSad = UIColor(hex: "#60A5FA")
        static let moodAngry = UIColor(hex: "#F87171")
    }

    // MARK: - Gradients
    enum Gradients {
        static let primaryGradient: [UIColor] = [Colors.primary, Colors.secondary]
        static let accentGradient: [UIColor] = [Colors.accent, Colors.accentOrange]
        static let purpleBlue: [UIColor] = [UIColor(hex: "#667EEA"), UIColor(hex: "#764BA2")]
    }

    // MARK: - Spacing
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }

    // MARK: - Corner Radius
    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xl: CGFloat = 24
        static let full: CGFloat = 9999
    }

    // MARK: - Shadows
    enum Shadow {
        static func apply(to view: UIView, opacity: Float = 0.3, radius: CGFloat = 16, offset: CGSize = CGSize(width: 0, height: 8)) {
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = opacity
            view.layer.shadowRadius = radius
            view.layer.shadowOffset = offset
            view.layer.masksToBounds = false
        }

        static func glow(to view: UIView, color: UIColor, radius: CGFloat = 20) {
            view.layer.shadowColor = color.cgColor
            view.layer.shadowOpacity = 0.6
            view.layer.shadowRadius = radius
            view.layer.shadowOffset = .zero
        }
    }

    // MARK: - Fonts
    enum Font {
        static func largeTitle() -> UIFont { return .systemFont(ofSize: 34, weight: .bold) }
        static func title1() -> UIFont { return .systemFont(ofSize: 28, weight: .bold) }
        static func title2() -> UIFont { return .systemFont(ofSize: 22, weight: .semibold) }
        static func title3() -> UIFont { return .systemFont(ofSize: 20, weight: .semibold) }
        static func headline() -> UIFont { return .systemFont(ofSize: 17, weight: .semibold) }
        static func body() -> UIFont { return .systemFont(ofSize: 17, weight: .regular) }
        static func callout() -> UIFont { return .systemFont(ofSize: 16, weight: .regular) }
        static func subhead() -> UIFont { return .systemFont(ofSize: 15, weight: .regular) }
        static func footnote() -> UIFont { return .systemFont(ofSize: 13, weight: .regular) }
        static func caption() -> UIFont { return .systemFont(ofSize: 12, weight: .regular) }
    }
}

// UIColor Hex Extension
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

// Gradient Layer Helper
extension CAGradientLayer {
    static func primaryGradient(frame: CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = Theme.Gradients.primaryGradient.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }
}
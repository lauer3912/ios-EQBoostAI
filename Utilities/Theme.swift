import UIKit

enum Theme {

    enum Colors {
        static let primary = UIColor(hex: "#6C63FF")
        static let secondary = UIColor(hex: "#4ECDC4")
        static let accent = UIColor(hex: "#FF6B9D")
        static let backgroundDark = UIColor(hex: "#0F0F1A")
        static let backgroundLight = UIColor(hex: "#F8F9FF")
        static let surfaceDark = UIColor(hex: "#1A1A2E")
        static let surfaceLight = UIColor.white
        static let textPrimaryDark = UIColor.white
        static let textPrimaryLight = UIColor(hex: "#1A1A2E")
        static let textSecondaryDark = UIColor(hex: "#A0A0B2")
        static let textSecondaryLight = UIColor(hex: "#6B6B80")
        static let success = UIColor(hex: "#34D399")
        static let warning = UIColor(hex: "#FBBF24")
        static let error = UIColor(hex: "#F87171")
    }

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }

    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
    }

    enum Font {
        static func heading1() -> UIFont {
            return UIFont.systemFont(ofSize: 32, weight: .bold)
        }

        static func heading2() -> UIFont {
            return UIFont.systemFont(ofSize: 24, weight: .semibold)
        }

        static func heading3() -> UIFont {
            return UIFont.systemFont(ofSize: 20, weight: .semibold)
        }

        static func body() -> UIFont {
            return UIFont.systemFont(ofSize: 17, weight: .regular)
        }

        static func caption() -> UIFont {
            return UIFont.systemFont(ofSize: 13, weight: .regular)
        }

        static func button() -> UIFont {
            return UIFont.systemFont(ofSize: 17, weight: .semibold)
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
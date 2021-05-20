import UIKit

public protocol LayoutConstrainable {
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    var heightAnchor: NSLayoutDimension { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }

    @available(iOS 10.0, tvOS 10.0, *)
    var hasAmbiguousLayout: Bool { get }

    @available(iOS 10.0, tvOS 10.0, *)
    func constraintsAffectingLayout(for axis: NSLayoutConstraint.Axis) -> [NSLayoutConstraint]
}

extension UIView: LayoutConstrainable {}
extension UILayoutGuide: LayoutConstrainable {}

extension LayoutConstrainable {

    @discardableResult public func constrainEdges(to other: LayoutConstrainable, insetBy insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        (self as? UIView)?.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            topAnchor.constraint(equalTo: other.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: -insets.bottom),
            leftAnchor.constraint(equalTo: other.leftAnchor, constant: insets.left),
            rightAnchor.constraint(equalTo: other.rightAnchor, constant: -insets.right),
        ]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    @discardableResult public func constrainEdges(to other: LayoutConstrainable, insetBy inset: CGFloat) -> [NSLayoutConstraint] {
        let insets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        return constrainEdges(to: other, insetBy: insets)
    }

    @available(iOS 11.0, tvOS 11.0, *)
    @discardableResult public func constrainEdges(to other: LayoutConstrainable, insetBy insets: NSDirectionalEdgeInsets) -> [NSLayoutConstraint] {
        (self as? UIView)?.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            topAnchor.constraint(equalTo: other.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: -insets.bottom),
            leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: insets.leading),
            trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: -insets.trailing),
        ]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    @discardableResult public func constrainCenter(to other: LayoutConstrainable, offsetBy offset: CGPoint = .zero) -> [NSLayoutConstraint] {
        (self as? UIView)?.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            centerXAnchor.constraint(equalTo: other.centerXAnchor, constant: offset.x),
            centerYAnchor.constraint(equalTo: other.centerYAnchor, constant: offset.y),
        ]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    @discardableResult public func constrainSize(toEqual other: LayoutConstrainable, scale: CGFloat = .zero) -> [NSLayoutConstraint] {
        (self as? UIView)?.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            widthAnchor.constraint(equalTo: other.widthAnchor, multiplier: scale),
            heightAnchor.constraint(equalTo: other.heightAnchor, multiplier: scale),
        ]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}

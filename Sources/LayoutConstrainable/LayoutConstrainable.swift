import UIKit

/// One or more edges of a rectangle.
public struct LayoutEdges: OptionSet {

    public static let top = LayoutEdges(rawValue: 1 << 0)
    public static let bottom = LayoutEdges(rawValue: 1 << 1)
    public static let left = LayoutEdges(rawValue: 1 << 2)
    public static let right = LayoutEdges(rawValue: 1 << 3)

    public static let all: LayoutEdges = [.top, .bottom, .left, .right]
    public static let horizontal: LayoutEdges = [.left, .right]
    public static let vertical: LayoutEdges = [.top, .bottom]

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

/// One or more edges of a rectangle, taking reading direction into account.
///
/// For LTR languages (e.g. English), `.leading` is equivalent to left, and `.trailing` is equivalent to right.
/// For RTL languages (e.g. Arabic) these are reversed.
///
public struct DirectionalLayoutEdges: OptionSet {

    public static let top = DirectionalLayoutEdges(rawValue: 1 << 0)
    public static let bottom = DirectionalLayoutEdges(rawValue: 1 << 1)
    public static let leading = DirectionalLayoutEdges(rawValue: 1 << 2)
    public static let trailing = DirectionalLayoutEdges(rawValue: 1 << 3)

    public static let all: DirectionalLayoutEdges = [.top, .bottom, .leading, .trailing]
    public static let horizontal: DirectionalLayoutEdges = [.leading, .trailing]
    public static let vertical: DirectionalLayoutEdges = [.top, .bottom]

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

/// A type that participates in auto layout.
///
/// Contains the auto layout properties and methods common to UIView and UILayoutGuide.
///
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

    /// Creates and activates constraints between the specified edges of the receiver and `other`.
    ///
    /// - Parameters:
    ///   - edges: Which edges to add constraints for. Defaults to all edges.
    ///   - other: The other view or layout guide to constrain the receiver's edges to.
    ///   - insets: Offsets the receiver's edges towards the rectangle's center
    ///             (or away from center if values are negative).
    ///             Edges not in `edges` are ignored.
    ///             Defaults to zero.
    ///
    /// - Returns: The added constraints.
    ///            The constraints are already active,
    ///            but you may wish to hold references to deactivate or modify them later.
    ///
    @discardableResult public func constrainEdges(_ edges: LayoutEdges = .all, to other: LayoutConstrainable, insetBy insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        let constraints = [
            edges.contains(.top) ? topAnchor.constraint(equalTo: other.topAnchor, constant: insets.top) : nil,
            edges.contains(.bottom) ? bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: -insets.bottom) : nil,
            edges.contains(.left) ? leftAnchor.constraint(equalTo: other.leftAnchor, constant: insets.left) : nil,
            edges.contains(.right) ? rightAnchor.constraint(equalTo: other.rightAnchor, constant: -insets.right) : nil,
        ].compactMap { $0 }

        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    /// Creates and activates constraints between the specified edges of the receiver and `other`.
    ///
    /// - Parameters:
    ///   - edges: Which edges to add constraints for. Defaults to all edges.
    ///   - other: The other view or layout guide to constrain the receiver's edges to.
    ///   - inset: Offsets the receiver's edges towards the rectangle's center
    ///            (or away from center if values are negative).
    ///            Edges not in `edges` are ignored.
    ///
    /// - Returns: The added constraints.
    ///            The constraints are already active,
    ///            but you may wish to hold references to deactivate or modify them later.
    ///
    @discardableResult public func constrainEdges(_ edges: LayoutEdges = .all, to other: LayoutConstrainable, insetBy inset: CGFloat) -> [NSLayoutConstraint] {
        let insets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        return constrainEdges(edges, to: other, insetBy: insets)
    }

    /// Creates and activates constraints between the specified edges of the receiver and `other`,
    /// taking reading direction into account.
    ///
    /// - Parameters:
    ///   - edges: Which edges to add constraints for. Defaults to all edges.
    ///   - other: The other view or layout guide to constrain the receiver's edges to.
    ///   - insets: Offsets the receiver's edges towards the rectangle's center
    ///             (or away from center if values are negative).
    ///             Edges not in `edges` are ignored.
    ///
    /// - Returns: The added constraints.
    ///            The constraints are already active,
    ///            but you may wish to hold references to deactivate or modify them later.
    ///
    @available(iOS 11.0, tvOS 11.0, *)
    @discardableResult public func constrainEdges(_ edges: DirectionalLayoutEdges = .all, to other: LayoutConstrainable, insetBy insets: NSDirectionalEdgeInsets) -> [NSLayoutConstraint] {
        let constraints = [
            edges.contains(.top) ? topAnchor.constraint(equalTo: other.topAnchor, constant: insets.top) : nil,
            edges.contains(.bottom) ? bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: -insets.bottom) : nil,
            edges.contains(.leading) ? leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: insets.leading) : nil,
            edges.contains(.trailing) ? trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: -insets.trailing) : nil,
        ].compactMap { $0 }

        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    /// Creates and activates constraints between the centers of the receiver and `other`.
    ///
    /// - Parameters:
    ///   - other: The other view or layout guide to constrain the receiver's center to.
    ///   - offset: Offsets the receiver's center to the left for positive `x` values,
    ///             and down for postive `y` values.
    ///             Defaults to zero.
    ///
    /// - Returns: The added constraints.
    ///            The constraints are already active,
    ///            but you may wish to hold references to deactivate or modify them later.
    ///
    @discardableResult public func constrainCenter(to other: LayoutConstrainable, offsetBy offset: CGPoint = .zero) -> [NSLayoutConstraint] {
        let constraints = [
            centerXAnchor.constraint(equalTo: other.centerXAnchor, constant: offset.x),
            centerYAnchor.constraint(equalTo: other.centerYAnchor, constant: offset.y),
        ]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    /// Creates and activates constraints between the size of the receiver and `other`.
    ///
    /// - Parameters:
    ///   - other: The other view or layout guide to constrain the receiver's size to.
    ///   - scale: Multiplier applied to the receiver's size.
    ///            e.g. `2.0` will constrain the size of the receiver
    ///            to twice the width and height of `other.`
    ///
    /// - Returns: The added constraints.
    ///            The constraints are already active,
    ///            but you may wish to hold references to deactivate or modify them later.
    ///
    @discardableResult public func constrainSize(toEqual other: LayoutConstrainable, scale: CGFloat = 1.0) -> [NSLayoutConstraint] {
        let constraints = [
            widthAnchor.constraint(equalTo: other.widthAnchor, multiplier: scale),
            heightAnchor.constraint(equalTo: other.heightAnchor, multiplier: scale),
        ]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}

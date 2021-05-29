import SnapshotTesting
import UIKit
import XCTest

import LayoutConstrainable

final class LayoutConstrainableTests: XCTestCase {

    var view: UIView!
    var layoutGuide: UILayoutGuide!

    var parent: UIView!
    var sibling: UIView!

    override func setUp() {
        super.setUp()

        view = UIView()
        layoutGuide = UILayoutGuide()
        parent = UIView()
        sibling = UIView()

        [view, parent, sibling].forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
        parent.addSubview(sibling)

        parent.backgroundColor = .white
        sibling.backgroundColor = .orange
        view.backgroundColor = .blue

        NSLayoutConstraint.activate([
            parent.widthAnchor.constraint(equalToConstant: 150),
            parent.heightAnchor.constraint(equalToConstant: 150),

            sibling.widthAnchor.constraint(equalToConstant: 50),
            sibling.heightAnchor.constraint(equalToConstant: 50),
            sibling.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
            sibling.centerYAnchor.constraint(equalTo: parent.centerYAnchor),
        ])

        parent.addSubview(view)
    }

    func testWithoutView() {
        view.removeFromSuperview()

        XCTAssertFalse(sibling.hasAmbiguousLayout)
        assertSnapshot(matching: parent, as: .image)
    }

    func testConstrainAllEdges() {
        view.constrainEdges(to: sibling)

        XCTAssertFalse(view.hasAmbiguousLayout)
        assertSnapshot(matching: parent, as: .image)
    }

    func testConstrainAllEdgesWithFloatInset() {
        view.constrainEdges(to: sibling, insetBy: 5.0)

        XCTAssertFalse(view.hasAmbiguousLayout)
        assertSnapshot(matching: parent, as: .image)
    }

    func testConstrainAllEdgesWithInsets() {
        let insets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 15.0, right: 20.0)
        view.constrainEdges(to: sibling, insetBy: insets)

        XCTAssertFalse(view.hasAmbiguousLayout)
        assertSnapshot(matching: parent, as: .image)
    }

    func testConstrainAllEdgesWithDirectionalInsets() {
        let insets = NSDirectionalEdgeInsets(top: 5.0, leading: 10.0, bottom: 15.0, trailing: 20.0)
        view.constrainEdges(to: sibling, insetBy: insets)

        XCTAssertFalse(view.hasAmbiguousLayout)
        assertSnapshot(matching: parent, as: .image)
    }

    func testConstrainCenter() {
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 25.0),
            view.heightAnchor.constraint(equalToConstant: 25.0),
        ])
        view.constrainCenter(to: sibling)

        XCTAssertFalse(view.hasAmbiguousLayout)
        assertSnapshot(matching: parent, as: .image)
    }

    func testConstrainCenterWithOffset() {
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 25.0),
            view.heightAnchor.constraint(equalToConstant: 25.0),
        ])
        view.constrainCenter(to: sibling, offsetBy: CGPoint(x: 10.0, y: 15.0))

        XCTAssertFalse(view.hasAmbiguousLayout)
        assertSnapshot(matching: parent, as: .image)
    }

    func testConstrainSize() {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: parent.topAnchor),
            view.leftAnchor.constraint(equalTo: parent.leftAnchor),
        ])
        view.constrainSize(toEqual: sibling)

        XCTAssertFalse(view.hasAmbiguousLayout)
        assertSnapshot(matching: parent, as: .image)
    }

    func testConstrainSizeWithScale() {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: parent.topAnchor),
            view.leftAnchor.constraint(equalTo: parent.leftAnchor),
        ])
        view.constrainSize(toEqual: sibling, scale: 0.5)

        XCTAssertFalse(view.hasAmbiguousLayout)
        assertSnapshot(matching: parent, as: .image)
    }
}

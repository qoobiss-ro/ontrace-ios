import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swiftUIView = AnyView(ContentView())
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.autoPin()
        hostingController.didMove(toParent: self)
    }
}

public extension UIView {
    func autoPin(top: CGFloat = 0,
                 leading: CGFloat = 0,
                 trailing: CGFloat = 0,
                 bottom: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let view = superview else { fatalError("View must be added to superview") }
        topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
    }
}

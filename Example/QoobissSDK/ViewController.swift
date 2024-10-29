//
//  ViewController.swift
//  QoobissSDK
//
//  Created by 144892271 on 05/09/2024.
//  Copyright (c) 2024 144892271. All rights reserved.
//

import UIKit
import QoobissSDK
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            AnyView(ReplaceMe().aaaa())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .foregroundColor(.blue)
    }
}

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let swiftUIView = AnyView(ContentView())
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .red
        view.backgroundColor = .yellow
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.autoPin()
        hostingController.didMove(toParent: self)
    }
}

public extension UIView {
    ///  adds topAnchor  leadingAnchor  trailingAnchor and bottomAnchor constrsaints to a view that already belonging to a view hierarchy
    ///   with default padding of 16
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

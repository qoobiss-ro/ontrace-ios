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
import QoobissCoreIdentificationSDK

struct ContentView: View {
    var body: some View {
        AnyView(IdentificationFlow.startFlow(apiKey: "your_key"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.red)
            .foregroundColor(.white)
            .ignoresSafeArea()
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

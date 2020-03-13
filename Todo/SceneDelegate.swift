//
//  SceneDelegate.swift
//  Todo
//
//  Created by Muhannad Alnemer on 2/20/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let color : UIColor = .secondaryLabel
        
        let listViewController = ListTableViewController()
        let initialViewController = UINavigationController(rootViewController: listViewController)
        initialViewController.view.tintColor                         = color 
        initialViewController.navigationBar.shadowImage              = UIImage()
        initialViewController.navigationBar.prefersLargeTitles       = true
        
        #if targetEnvironment(macCatalyst)
         if let titlebar = windowScene.titlebar {
             titlebar.titleVisibility = .hidden
             titlebar.toolbar = nil
         }
         #endif
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        DataManager.shared.saveContext{}
    }
}


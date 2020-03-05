//
//  SceneDelegate.swift
//  Todo
//
//  Created by Muhannad Alnemer on 2/20/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let userDefaults = UserDefaults.standard
        let color : UIColor = .secondaryLabel
        
        
//        let initialViewController = UINavigationController(rootViewController: ViewController())
//        let initialViewController = GoalSetterViewController()
//        let initialViewController = GoalSetterViewController2()
//        let initialViewController = ListTableViewController()
        let initialViewController = UINavigationController(rootViewController: ListTableViewController())
        initialViewController.view.tintColor                         = color 
        initialViewController.navigationBar.shadowImage              = UIImage()
        initialViewController.navigationBar.prefersLargeTitles       = true
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()

    }
}


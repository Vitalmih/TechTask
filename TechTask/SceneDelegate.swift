//
//  SceneDelegate.swift
//  TechTask
//
//  Created by Виталий on 05.01.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "CurrenciesViewController") as! CurrenciesViewController
                initialViewController.networkManager = CurrencyNetworkManager()
                let navigationController = UINavigationController(rootViewController: initialViewController)
                self.window = UIWindow(windowScene: windowScene)
                self.window?.rootViewController = navigationController
                self.window?.makeKeyAndVisible()
    }
}


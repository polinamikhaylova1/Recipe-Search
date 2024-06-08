//
//  SceneDelegate.swift
//  Recipe Search
//
//  Created by Полина Михайлова on 06.06.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let recipePresenter = RecipePresenter(view: nil)
        let recipeViewController = RecipeViewController(presenter: recipePresenter)
        
        let navigationController = UINavigationController(rootViewController: recipeViewController)
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }



}


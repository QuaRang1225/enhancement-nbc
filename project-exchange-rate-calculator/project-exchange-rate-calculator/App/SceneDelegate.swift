//
//  SceneDelegate.swift
//  project-exchange-rate-calculator
//
//  Created by 유영웅 on 4/14/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let DIContainer = ExchangeRateDIContainer()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        let window = UIWindow(windowScene: scene as! UIWindowScene)
        
        let navController = UINavigationController()
        let rootVC = MainViewController(DIContainer: DIContainer)
        navController.viewControllers = [rootVC]

        window.rootViewController = navController
        window.makeKeyAndVisible()
        self.window = window
        
        if let (type, id) = DIContainer.makeLastScreenUseCase.fetch() {
            if type == .calculator, let id = id {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let calculatorVC = CalculatorViewController(id: id, DIContainer: self.DIContainer)
                    navController.pushViewController(calculatorVC, animated: true)
                }
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    // 앱 종료 시에도 상태 저장
    func sceneWillResignActive(_ scene: UIScene) {
        guard let rootNav = window?.rootViewController as? UINavigationController else { return }
        Task {
            if let topVC = rootNav.topViewController {
                if topVC is MainViewController {
                    try await DIContainer.makeLastScreenUseCase.save(type: .list, currencyID: nil)
                } else if let calculatorVC = topVC as? CalculatorViewController {
                    try await DIContainer.makeLastScreenUseCase.save(type: .calculator, currencyID: calculatorVC.id)
                }
            }
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

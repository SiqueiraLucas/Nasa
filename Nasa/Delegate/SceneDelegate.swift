//import UIKit
//import LogVieweriOS
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//    var window: UIWindow?
//    let appBuilder = AppBuilder()
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        
//        let window = UIWindow(windowScene: windowScene)
//        
//        let rootViewController = appBuilder.returnInitialController()
//
//        window.rootViewController = rootViewController
//        self.window = window
//        window.makeKeyAndVisible()
//        
//        LogViewerProvider.setEnableInDebug(true)
//        LogViewerProvider.setEnableInRelease(false)
//    }
//
//    func sceneDidEnterBackground(_ scene: UIScene) {
//        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
//    }
//}

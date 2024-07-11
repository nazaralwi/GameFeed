import UIKit
import Swinject
import SwinjectStoryboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let container = Container { container in
            container.register(Networking.self) { _ in AlamofireNetworking() }
            container.register(RAWGService.self) { resolver in
                RAWGService(networking: resolver.resolve(Networking.self)!)
            }

            container.storyboardInitCompleted(ViewController.self) { resolver, viewController in
                viewController.rawgService = resolver.resolve(RAWGService.self)
            }

            container.storyboardInitCompleted(DetailGameViewController.self) { resolver, detailViewController in
                detailViewController.rawgService = resolver.resolve(RAWGService.self)
            }
            
            container.storyboardInitCompleted(SearchGameViewController.self) { resolver, searchGameViewController in
                searchGameViewController.rawgService = resolver.resolve(RAWGService.self)
            }

            container.storyboardInitCompleted(NewGameViewController.self) { resolver, newGameViewController in
                newGameViewController.rawgService = resolver.resolve(RAWGService.self)
            }

            container.storyboardInitCompleted(FavoritesViewController.self) { resolver, favoritesViewController in
                favoritesViewController.rawgService = resolver.resolve(RAWGService.self)
            }
        }

        SwinjectStoryboard.defaultContainer = container

        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication,
                     configurationForConnecting
                     connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }
}

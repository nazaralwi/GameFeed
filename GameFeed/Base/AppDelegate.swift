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
            container.register(RAWGClient.self) { resolver in
                RAWGClient(networking: resolver.resolve(Networking.self)!)
            }

            container.storyboardInitCompleted(ViewController.self) { resolver, viewController in
                viewController.rawgClient = resolver.resolve(RAWGClient.self)
            }

            container.storyboardInitCompleted(DetailGameViewController.self) { resolver, detailViewController in
                detailViewController.rawgClient = resolver.resolve(RAWGClient.self)
            }
            
            container.storyboardInitCompleted(SearchGameViewController.self) { resolver, searchGameViewController in
                searchGameViewController.rawgClient = resolver.resolve(RAWGClient.self)
            }

            container.storyboardInitCompleted(NewGameViewController.self) { resolver, newGameViewController in
                newGameViewController.rawgClient = resolver.resolve(RAWGClient.self)
            }

            container.storyboardInitCompleted(FavoritesViewController.self) { resolver, favoritesViewController in
                favoritesViewController.rawgClient = resolver.resolve(RAWGClient.self)
            }
        }

        // Set the default container
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

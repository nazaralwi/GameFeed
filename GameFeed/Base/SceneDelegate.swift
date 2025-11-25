import UIKit
import GameFeedDomain

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        let networking = AlamofireNetworking()
        let remoteDataSource = GameRemoteDataSource(networking: networking)
        let gameFeedUseCase = GameFeedUseCase(gameRemoteDataSource: remoteDataSource)

        let favoriteProvider = CoreDataFavoriteDataSource()
        let favoriteUseCase = FavoriteUseCase(favoriteProvider: favoriteProvider)

        let profileDataSource = UserDefaultProfileDataSource()
        let profileUseCase = ProfileUseCase(profileProvider: profileDataSource)

        window.rootViewController = TabBarViewController(
            networking: networking,
            remoteDataSource: remoteDataSource,
            gameFeedUseCase: gameFeedUseCase,
            favoriteProvider: favoriteProvider,
            favoriteUseCase: favoriteUseCase,
            profileDataSource: profileDataSource,
            profileUseCase: profileUseCase
        )
        
        self.window = window
        window.makeKeyAndVisible()
    }
}

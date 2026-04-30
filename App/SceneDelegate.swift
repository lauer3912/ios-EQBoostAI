import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = createMainTabBarController()
        window?.makeKeyAndVisible()
    }

    private func createMainTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()

        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)

        let journalVC = UINavigationController(rootViewController: JournalViewController())
        journalVC.tabBarItem = UITabBarItem(title: "Journal", image: UIImage(systemName: "book.fill"), tag: 1)

        let rolePlayVC = UINavigationController(rootViewController: RolePlayViewController())
        rolePlayVC.tabBarItem = UITabBarItem(title: "Practice", image: UIImage(systemName: "person.2.fill"), tag: 2)

        let tasksVC = UINavigationController(rootViewController: TasksViewController())
        tasksVC.tabBarItem = UITabBarItem(title: "Tasks", image: UIImage(systemName: "checkmark.circle.fill"), tag: 3)

        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 4)

        tabBarController.viewControllers = [homeVC, journalVC, rolePlayVC, tasksVC, profileVC]
        tabBarController.selectedIndex = 0

        return tabBarController
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		window = UIWindow(frame: UIScreen.main.bounds)

		let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
		let userListViewController = storyboard.instantiateViewController(withIdentifier: String(describing: UserListViewController.self)) as! UserListViewController
		userListViewController.viewModel = UserListViewModel()
		userListViewController.loadintType = .fakePlaceholder
		window?.rootViewController = UINavigationController.init(rootViewController: userListViewController)
		window?.makeKeyAndVisible()
		
		return true
	}
}


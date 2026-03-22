import UIKit
import AceSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let aceViewController = AceViewController(instanceName: "HelloApp", entry: "pages/Index")
        aceViewController.abilityDelegate = self

        window?.rootViewController = aceViewController
        window?.makeKeyAndVisible()

        return true
    }
}

extension AppDelegate: AceAbilityDelegate {
    func onAbilityCreate(_ ability: AceAbility) {
        print("AceAbility created")
    }

    func onAbilityDestroy(_ ability: AceAbility) {
        print("AceAbility destroyed")
    }

    func onAbilityForeground(_ ability: AceAbility) {
        print("AceAbility foreground")
    }

    func onAbilityBackground(_ ability: AceAbility) {
        print("AceAbility background")
    }
}

import UIKit
import libarkui_ios

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        StageApplication.configModule(withBundleDirectory: "arkui-x")
        StageApplication.launch()

        window = UIWindow(frame: UIScreen.main.bounds)
        let instanceName = "com.example.hmrdp:entry:EntryAbility"
        let stageVC = StageViewController(instanceName: instanceName)
        window?.rootViewController = stageVC
        window?.makeKeyAndVisible()

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        StageApplication.callCurrentAbilityOnForeground()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        StageApplication.callCurrentAbilityOnBackground()
    }
}

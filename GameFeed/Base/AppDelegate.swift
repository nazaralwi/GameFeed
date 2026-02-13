import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        NSLog("AppSuitPremium: Application did finish launching")

        // 🔐 Jalankan AppSuit Security Check
        performSecurityCheck()

        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {

        NSLog("AppSuitPremium: Configuring scene session")
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
        NSLog("AppSuitPremium: Discarded scene sessions")
    }

    // MARK: - 🔐 AppSuit LocalHandler Integration
    func performSecurityCheck() {

        // Full security check (tanpa flags)
        guard let errorPtr = AS_Check() else {
            NSLog("AppSuitPremium: No result returned from AS_Check()")
            return
        }

        // Convert C string ke Swift String
        guard let fullCode = String(utf8String: errorPtr) else {
            NSLog("AppSuitPremium: Failed to convert error code")
            return
        }

        // Ambil 4 digit pertama sebagai error category
        let errorCode = String(fullCode.prefix(4))

        // Analisis hasil
        if fullCode != "00000000" {

            switch errorCode {
            case "1000":
                NSLog("AppSuitPremium: [STEALIEN] Debugging detected")
                showSecurityAlert(message: "Debugging detected!")

            case "1100":
                NSLog("AppSuitPremium: [STEALIEN] Jailbreak detected")
                showSecurityAlert(message: "This device is jailbroken!")

            case "1200":
                NSLog("AppSuitPremium: [STEALIEN] Integrity issue detected")
                showSecurityAlert(message: "App integrity compromised!")

            case "1300":
                NSLog("AppSuitPremium: [STEALIEN] Threat detected")
                showSecurityAlert(message: "Security threat detected!")

            default:
                NSLog("AppSuitPremium: [STEALIEN] Unknown security code: \(fullCode)")
                showSecurityAlert(message: "Unknown security issue detected!")
            }

        } else {
            NSLog("AppSuitPremium: [STEALIEN] Success – No threats found ✅")
        }
    }

    // MARK: - ⚠️ Alert Helper
    func showSecurityAlert(message: String) {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {

                let alert = UIAlertController(
                    title: "Security Warning",
                    message: message,
                    preferredStyle: .alert
                )

                alert.addAction(
                    UIAlertAction(title: "Exit", style: .destructive) { _ in
                        exit(0)
                    }
                )

                rootVC.present(alert, animated: true)
            }
        }
    }
}

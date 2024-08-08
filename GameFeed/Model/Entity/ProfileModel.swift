import Foundation

public final class ProfileModel {
    public static let stateEditKey = "state"
    public static let nameKey = "name"
    public static let companyKey = "company"
    public static let emailKey = "email"

    public static var name: String {
        get {
            return UserDefaults.standard.string(forKey: nameKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: nameKey)
        }
    }

    public static var company: String {
        get {
            return UserDefaults.standard.string(forKey: companyKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: companyKey)
        }
    }

    public static var email: String {
        get {
            return UserDefaults.standard.string(forKey: emailKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: emailKey)
        }
    }

    public static func deleteAll() -> Bool {
        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            return true
        } else {
            return false
        }
    }

    public static func synchronize() {
        UserDefaults.standard.synchronize()
    }
}

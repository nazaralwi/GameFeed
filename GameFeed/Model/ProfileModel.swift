import Foundation

class ProfileModel {
    static let stateEditKey = "state"
    static let nameKey = "name"
    static let companyKey = "company"
    static let emailKey = "email"

    static var stateEdit: Bool {
        get {
            return UserDefaults.standard.bool(forKey: stateEditKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: stateEditKey)
        }
    }

    static var name: String {
        get {
            return UserDefaults.standard.string(forKey: nameKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: nameKey)
        }
    }

    static var company: String {
        get {
            return UserDefaults.standard.string(forKey: companyKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: companyKey)
        }
    }

    static var email: String {
        get {
            return UserDefaults.standard.string(forKey: emailKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: emailKey)
        }
    }

    static func deleteAll() -> Bool {
        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            return true
        } else {
            return false
        }
    }

    static func synchronize() {
        UserDefaults.standard.synchronize()
    }
}

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

public struct Profile {
    public var name: String
    public var company: String
    public var email: String
}

public protocol ProfileProviderProtocol {
    func getProfile() -> Profile
    func saveProfile(_ profile: Profile)
}

public final class UserDefaultProfileRepository: ProfileProviderProtocol {
    private let nameKey = "profile_name"
    private let companyKey = "profile_company"
    private let emailKey = "profile_email"

    public init() {}

    public func getProfile() -> Profile {
        let data = UserDefaults.standard
        return Profile(
            name: data.string(forKey: nameKey) ?? "Muhammad Nazar Alwi",
            company: data.string(forKey: companyKey) ?? "IT Telkom Purwokerto",
            email: data.string(forKey: emailKey) ?? "alwinazar75@gmail.com"
        )
    }

    public func saveProfile(_ profile: Profile) {
        let data = UserDefaults.standard
        data.set(profile.name, forKey: nameKey)
        data.set(profile.company, forKey: companyKey)
        data.set(profile.email, forKey: emailKey)
    }
}

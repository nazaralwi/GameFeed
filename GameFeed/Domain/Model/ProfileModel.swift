import Foundation

public struct ProfileModel: Equatable {
    public var name: String
    public var company: String
    public var email: String

    public init(name: String, company: String, email: String) {
        self.name = name
        self.company = company
        self.email = email
    }
}

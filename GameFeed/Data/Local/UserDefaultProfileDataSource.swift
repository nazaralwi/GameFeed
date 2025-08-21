//
//  ProfileProvider.swift
//  GameFeed
//
//  Created by Macintosh on 12/08/25.
//  Copyright © 2025 Dicoding Indonesia. All rights reserved.
//

import Foundation
import GameFeedDomain

public final class UserDefaultProfileDataSource: UserDefaultProfileDataSourceProtocol {
    private let nameKey = "profile_name"
    private let companyKey = "profile_company"
    private let emailKey = "profile_email"

    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func getProfile() -> ProfileModel {
        let data = UserDefaults.standard
        return ProfileModel(
            name: data.string(forKey: nameKey) ?? "Muhammad Nazar Alwi",
            company: data.string(forKey: companyKey) ?? "IT Telkom Purwokerto",
            email: data.string(forKey: emailKey) ?? "alwinazar75@gmail.com"
        )
    }

    public func saveProfile(_ profile: ProfileModel) {
        let data = UserDefaults.standard
        data.set(profile.name, forKey: nameKey)
        data.set(profile.company, forKey: companyKey)
        data.set(profile.email, forKey: emailKey)
    }
}

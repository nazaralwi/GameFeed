//
//  ProfileUseCase.swift
//  GameFeed
//
//  Created by Macintosh on 13/08/25.
//  Copyright © 2025 Dicoding Indonesia. All rights reserved.
//

import Foundation

public protocol UserDefaultProfileDataSourceProtocol {
    func getProfile() -> ProfileModel
    func saveProfile(_ profile: ProfileModel)
}

public final class ProfileUseCase {

    private let profileProvider: UserDefaultProfileDataSourceProtocol

    public init(profileProvider: UserDefaultProfileDataSourceProtocol) {
        self.profileProvider = profileProvider
    }

    public func getProfile() -> ProfileModel {
        return profileProvider.getProfile()
    }

    public func saveProfile(_ profile: ProfileModel) {
        profileProvider.saveProfile(profile)
    }
}

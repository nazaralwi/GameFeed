//
//  MyProfileViewModel.swift
//  GameFeed
//
//  Created by Macintosh on 07/08/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import Foundation
import GameFeedDomain

public final class MyProfileViewModel {
    private var profileUseCase: ProfileUseCase

    public var onChange: ((ProfileUIModel) -> Void)?

    public init(profileUseCase: ProfileUseCase) {
        self.profileUseCase = profileUseCase
    }

    public func load() {
        let profile = profileUseCase.getProfile()
        let viewData = ProfileUIModel(name: profile.name, company: profile.company, email: profile.email)

        onChange?(viewData)
    }

    public func save(name: String, company: String, email: String) -> Bool {
        guard !name.isEmpty, !company.isEmpty, !email.isEmpty else { return false }

        let profile = ProfileModel(name: name, company: company, email: email)
        profileUseCase.saveProfile(profile)
        load()

        return true
    }
}

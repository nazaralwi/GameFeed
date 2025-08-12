//
//  MyProfileViewModel.swift
//  GameFeed
//
//  Created by Macintosh on 07/08/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import Foundation

public struct ProfileViewData {
    public let name: String
    public let company: String
    public let email: String
}

public final class MyProfileViewModel {
    private var rawgUseCase: GameFeedUseCase

    public var onChange: ((ProfileViewData) -> Void)?

    public init(rawgUseCase: GameFeedUseCase) {
        self.rawgUseCase = rawgUseCase
    }

    public func load() {
        let profile = rawgUseCase.getProfile()
        let viewData = ProfileViewData(name: profile.name, company: profile.company, email: profile.email)

        onChange?(viewData)
    }

    public func save(name: String, company: String, email: String) -> Bool {
        guard !name.isEmpty, !company.isEmpty, !email.isEmpty else { return false }

        let profile = Profile(name: name, company: company, email: email)
        rawgUseCase.saveProfile(profile)
        load()

        return true
    }
}

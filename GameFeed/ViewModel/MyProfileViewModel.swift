//
//  MyProfileViewModel.swift
//  GameFeed
//
//  Created by Macintosh on 07/08/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import Foundation

public struct DeveloperProfile {
    let name: String
    let company: String
    let email: String
}

public final class MyProfileViewModel {
    private var rawgUseCase: RAWGUseCase

    public init(rawgUseCase: RAWGUseCase) {
        self.rawgUseCase = rawgUseCase
    }

    public func synchronize() {
        rawgUseCase.synchronizeProfileModel()
    }

    public func getProfile() -> DeveloperProfile {
        return rawgUseCase.getProfileModelData()
    }

    public func saveProfile(name: String, company: String, email: String) -> Bool {
        guard !name.isEmpty, !company.isEmpty, !email.isEmpty else { return false }

        rawgUseCase.setProfileModellData(name: name, company: company, email: email)

        return true
    }
}

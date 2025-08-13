//
//  ProfileUseCase.swift
//  GameFeed
//
//  Created by Macintosh on 13/08/25.
//  Copyright © 2025 Dicoding Indonesia. All rights reserved.
//

import XCTest
import Combine
@testable import GameFeed

class MockProfileProvider: UserDefaultProfileDataSourceProtocol {
    var getProfileCalled = false
    var saveProfileCalled = false
    var savedProfile: Profile?

    var stubProfile = Profile(
        name: "Stub name",
        company: "Stub company",
        email: "stub@email.com")

    func getProfile() -> GameFeed.Profile {
        getProfileCalled = true
        return stubProfile
    }

    func saveProfile(_ profile: GameFeed.Profile) {
        saveProfileCalled = true
        savedProfile = profile
    }
}

final class ProfileUseCaseTest: XCTestCase {

    var profileUseCase: ProfileUseCase!
    var mockProfileProvider: MockProfileProvider!

    override func setUp() {
        super.setUp()
        mockProfileProvider = MockProfileProvider()
        profileUseCase = ProfileUseCase(profileProvider: mockProfileProvider)
    }

    func testGetProfile() {
        _ = profileUseCase.getProfile()
        XCTAssertTrue(mockProfileProvider.getProfileCalled)
    }

    func testSaveProfile() {
        profileUseCase.saveProfile(mockProfileProvider.stubProfile)
        XCTAssertTrue(mockProfileProvider.saveProfileCalled)
        XCTAssertEqual(mockProfileProvider.stubProfile, mockProfileProvider.savedProfile)
    }
}

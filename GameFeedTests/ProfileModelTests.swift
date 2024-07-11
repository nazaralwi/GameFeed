//
//  ProfileModelTests1.swift
//  GameFeedTests
//
//  Created by Macintosh on 11/07/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import XCTest
@testable import GameFeed

final class ProfileModelTests: XCTestCase {

    var testUserDefaults: UserDefaults!
    let stateEditKey = "state"
    let nameKey = "name"
    let companyKey = "company"
    let emailKey = "email"

    override func setUp() {
        super.setUp()
        testUserDefaults = UserDefaults(suiteName: "TestDefaults")
    }

    override func tearDown() {
        testUserDefaults.removePersistentDomain(forName: "TestDefaults")
        super.tearDown()
    }

    func testDeleteAll() {
        ProfileModel.name = "Nazar Alwi"
        ProfileModel.company = "Dicoding"
        ProfileModel.email = "alwinazar75@gmail.com"
        ProfileModel.stateEdit = true

        XCTAssertTrue(ProfileModel.deleteAll())

        XCTAssertEqual(ProfileModel.name, "")
        XCTAssertEqual(ProfileModel.company, "")
        XCTAssertEqual(ProfileModel.email, "")
        XCTAssertFalse(ProfileModel.stateEdit)
    }

    func testSynchronize() {
        ProfileModel.name = "Nazar Alwi"
        ProfileModel.synchronize()
        XCTAssertEqual(ProfileModel.name, "Nazar Alwi")
    }
}

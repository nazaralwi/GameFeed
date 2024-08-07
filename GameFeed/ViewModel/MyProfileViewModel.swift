//
//  MyProfileViewModel.swift
//  GameFeed
//
//  Created by Macintosh on 07/08/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import Foundation

class MyProfileViewModel {
    var name: String {
        didSet {
            ProfileModel.name = name
        }
    }

    var company: String {
        didSet {
            ProfileModel.company = company
        }
    }

    var email: String {
        didSet {
            ProfileModel.email = email
        }
    }

    init(name: String, company: String, email: String) {
        self.name = name
        self.company = company
        self.email = email
    }

    func synchronize() {
        ProfileModel.synchronize()
        name = ProfileModel.name
        company = ProfileModel.company
        email = ProfileModel.email
    }

    func saveProfile(name: String, company: String, email: String) -> Bool {
        guard !name.isEmpty, !company.isEmpty, !email.isEmpty else { return false }

        ProfileModel.name = name
        ProfileModel.company = company
        ProfileModel.email = email

        return true
    }
}

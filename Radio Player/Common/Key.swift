//
//  Key.swift
//  Open Movie Database
//
//  Created by Chandresh Kachariya on 03/06/21.
//

import Foundation

struct Key  {
    struct API {
        enum status: String {
            case success
            case unauthorized
            case interServerError
            case dataNotFound
        }
    }
}

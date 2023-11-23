//
//  User.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/23/23.
//

import Foundation

struct User: Hashable {
    let userID: String = UUID().uuidString
    let imageURL: String
    let name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(userID)
    }
    
    static let mock: [User] = [
        User(imageURL: "", name: "kim"),
        User(imageURL: "", name: "lee"),
        User(imageURL: "", name: "park"),
        User(imageURL: "", name: "heo"),
        User(imageURL: "", name: "nam"),
        User(imageURL: "", name: "choi"),
        User(imageURL: "", name: "yoon"),
    ]
}

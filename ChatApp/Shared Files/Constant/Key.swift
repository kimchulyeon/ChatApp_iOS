//
//  DBKey.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/21/23.
//

import Foundation

enum Key {
    case Name
    case Email
    case DocID
    case UID
    case CreatedAt
    case Provider
    case Image 
    
    var value: String {
        switch self {
        case .Name: "Name"
        case .Email: "Email"
        case .DocID: "DocumentId"
        case .UID: "UserId"
        case .CreatedAt: "CreatedAt"
        case .Provider: "Provider"
        case .Image: "Image"
        }
    }
}

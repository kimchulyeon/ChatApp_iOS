//
//  Chat.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/22/23.
//

import Foundation

struct Chat: Hashable {
    let chatID: String = UUID().uuidString
    let imageURL: String
    let name: String
    let lastChat: String
    let date: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(chatID)
    }
    
    static let mock: [Chat] = [
        Chat(imageURL: "", name: "kim", lastChat: "잘들어갔냐?", date: "2023-11-11"),
        Chat(imageURL: "", name: "홀리몰리", lastChat: "전달드릴게 있습니다. 12시 이후에 통화 가능하실까요?", date: "2023-11-01"),
        Chat(imageURL: "", name: "park", lastChat: ".....", date: "2023-11-11"),
        Chat(imageURL: "", name: "라온이", lastChat: "밥 주시오~", date: "2023-11-11"),
        Chat(imageURL: "", name: "내사랑", lastChat: "퇴근하자 퇴근~~~~", date: "2023-11-11"),
        Chat(imageURL: "", name: "yoon", lastChat: "밥 뭐 먹?", date: "2023-11-11"),
    ]
}

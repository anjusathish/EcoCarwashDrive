//
//  SendChatMessageResponse.swift
//  EcoCarWash
//
//  Created by Indium Software on 10/09/21.
//

import Foundation

// MARK: - SendChatMessageResponse
struct SendChatMessageResponse: Codable {
    let status: Bool?
    let errorID: Int?
    let chatMessages: ChatMessages?

    enum CodingKeys: String, CodingKey {
        case status
        case errorID = "errorId"
        case chatMessages
    }
}

// MARK: - ChatMessages
struct ChatMessages: Codable {
    let id, senderID, message, type: String?
    let subType, patientID, consultID, senderName: String?
    let time, receiver: String?
    let urgent, important: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case senderID = "senderId"
        case message, type, subType
        case patientID = "patientId"
        case consultID = "consultId"
        case senderName, time, receiver, urgent, important
    }
}

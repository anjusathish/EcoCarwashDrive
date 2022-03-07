//
//  SendChatMessageViewModel.swift
//  EcoCarWash
//
//  Created by Indium Software on 10/09/21.
//

import Foundation

protocol SendChatMessageDelegate {
    func sendChatMessageSuccess(attendanceList: ChatMessages)
    func failure(message : String)
}

class SendChatMessageViewModel {
    
    var delegate: SendChatMessageDelegate!
    
    func sendChatMessage(info: ChatMessageRequest, provId: String, token: String) {
        
        PatientDetailServiceHelper.request(router: PatientDetailServiceManager.sendChatMessage(info, provId: provId, token: token), completion: { (result : Result<SendChatMessageResponse, CustomError>) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let data) :
                    if let _data = data.chatMessages {
                        self.delegate.sendChatMessageSuccess(attendanceList: _data)
                    }
                case .failure(let error):
                    self.delegate.failure(message: "\(error)")
                }
            }
        })
    }
}

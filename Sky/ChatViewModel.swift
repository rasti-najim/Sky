//
//  ChatViewModel.swift
//  Sky
//
//  Created by rasti najim on 4/24/22.
//

import Foundation
import Alamofire
import SocketIO
import KeychainSwift

class ChatViewModel: ObservableObject {
    let manager = SocketManager(socketURL: URL(string: "ws://10.197.13.73:3000")!, config: [.log(true)])
    @Published var chatID = ""
    @Published var socket: SocketIOClient!
    @Published var message = ""
    @Published var showImage = false
    @Published var base64 = ""
    
    func load(friend: Friend) async {
        let keychain = KeychainSwift()
        guard let token = keychain.get("token") else { return }
        let headers: HTTPHeaders = [
            "x-auth-token": token
        ]
        
        AF.request("http://10.197.13.73:3000/api/chats/\(friend.friendID)", headers: headers).validate().responseDecodable(of: Chat.self) { response in
            switch response.result {
            case .success:
                if let data = response.value {
                    print(data)
                    self.chatID = data.chatID
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func connect() {
//        let manager = SocketManager(socketURL: URL(string: "ws://10.197.17.171:3000")!, config: [.log(true)])

        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in
            print("socket connected")
            self.socket.emit("join", self.chatID)
        }
        
        socket.on("message") { data, ack in
            print("message recieved")
            print(data)
            
            if let data = data[0] as? String {
                self.message += data
            }
        }
        
        socket.on("image") { data, ack in
            if let data = data[0] as? String {
                self.base64 = data
                self.showImage = true
            }
        }
        
        socket.connect()
        
    }
}

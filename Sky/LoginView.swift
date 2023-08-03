//
//  LoginView.swift
//  Sky
//
//  Created by rasti najim on 4/11/22.
//

import SwiftUI
import KeychainSwift
import Alamofire

struct Login: Codable {
    var email: String
    var password: String
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("email")
                    .fontWeight(.semibold)
                TextField("email", text: $email)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text("password")
                    .fontWeight(.semibold)
                SecureField("password", text: $password)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
            
            Button {
                Task {
                    await loadData()
                }
            } label: {
                Text("Log in")
                    .font(.body.weight(.semibold))
                    .padding(.horizontal, 100)
            }
            .buttonStyle(.borderedProminent)
            .padding()

            
            Spacer()
        }
        .navigationTitle("Log in")
    }
    
    func loadData() async {
        guard let url = URL(string: "http://10.197.13.73:3000/api/auth") else {
            print("invalid url")
            return
        }
        
        let login = Login(email: email, password: password)
        
        AF.request("http://10.197.13.73:3000/api/auth", method: .post, parameters: login, encoder: .json).validate().responseString { response in
            switch response.result {
            case .success:
                if let token = response.value {
                    print(token)
                    let keychain = KeychainSwift()
                    keychain.set(token, forKey: "token")
                }
                
            case let .failure(error):
                print(error)
            }
        }
        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        guard let encoded = try? JSONEncoder().encode(Login(email: email, password: password)) else {
//            print("Failed to encode order")
//            return
//        }
//
//        do {
//            let (data, metadata) = try await URLSession.shared.upload(for: request, from: encoded)
//            let token = String(decoding: data, as: UTF8.self)
//
//            let keychain = KeychainSwift()
//            keychain.set(token, forKey: "token")
//        } catch {
//        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

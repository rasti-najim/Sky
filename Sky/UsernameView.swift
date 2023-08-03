//
//  UsernameView.swift
//  Sky
//
//  Created by rasti najim on 3/29/22.
//

import SwiftUI

struct UsernameView: View {
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            Text("username & password")
                .font(.largeTitle.weight(.bold))
                .padding(.top)
            
            VStack(alignment: .leading) {
                Text("username")
                    .fontWeight(.bold)
                TextField("username", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom)
                
                Text("password")
                    .fontWeight(.bold)
                SecureField("password", text: $password)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
            
            Button(action: {}) {
                Text("next")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width * 0.8)
            }
            .buttonStyle(.bordered)
//            .tint(.black)
//            .controlSize(.large)
            
            Spacer()
        }
    }
}

struct UsernameView_Previews: PreviewProvider {
    static var previews: some View {
        UsernameView()
    }
}

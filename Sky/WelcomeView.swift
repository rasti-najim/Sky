//
//  WelcomeView.swift
//  Sky
//
//  Created by rasti najim on 3/26/22.
//

import SwiftUI

struct WelcomeView: View {
    @State private var isActive = false
    @State private var login = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("dookie")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 1)
                
                Text("messaging, in the moment")
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                NavigationLink(isActive: $isActive, destination: { ContentView() }, label: { EmptyView() })
                
                NavigationLink(isActive: $login, destination: { LoginView() }, label: { EmptyView() })
                
                Button(action: {isActive.toggle()}) {
                    Text("Sign up")
                        .padding(.horizontal)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .padding(.top)
                
                Button(action: {
                    login.toggle()
                }) {
                    Text("Login")
                        .padding(.horizontal)
                }
                .buttonStyle(.bordered)
                .tint(.blue)
                .padding(.top, 5)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(Color(""))
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

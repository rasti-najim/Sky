//
//  EmailView.swift
//  Sky
//
//  Created by rasti najim on 3/28/22.
//

import SwiftUI

struct EmailView: View {
    @State private var email = ""
    @State private var isActive = false
    
    var body: some View {
        VStack {
            Text("enter your email")
                .font(.largeTitle.weight(.bold))
                .padding(.top)
            
            VStack(alignment: .leading) {
                Text("email")
                    .fontWeight(.bold)
                TextField("email", text: $email)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
            
            Button(action: {isActive.toggle()}) {
                Text("next")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width * 0.8)
            }
            .buttonStyle(.bordered)
//            .tint(.black)
//            .controlSize(.large)
            
            NavigationLink(destination: EmailConfirmationView(), isActive: $isActive, label: {EmptyView()})
            
            Spacer()
        }
    }
}

struct EmailView_Previews: PreviewProvider {
    static var previews: some View {
        EmailView()
    }
}

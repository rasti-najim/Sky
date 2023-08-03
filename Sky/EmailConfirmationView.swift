//
//  EmailConfirmationView.swift
//  Sky
//
//  Created by rasti najim on 3/29/22.
//

import SwiftUI

struct EmailConfirmationView: View {
    @State private var code = ""
    var body: some View {
        VStack {
            Text("confirm your email")
                .font(.largeTitle.weight(.bold))
                .padding(.top)
            
            VStack(alignment: .leading) {
                Text("code")
                    .fontWeight(.bold)
                TextField("6 digit code", text: $code)
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

struct EmailConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        EmailConfirmationView()
    }
}

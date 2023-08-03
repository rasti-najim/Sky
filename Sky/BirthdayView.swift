//
//  BirthdayView.swift
//  Sky
//
//  Created by rasti najim on 3/29/22.
//

import SwiftUI

struct BirthdayView: View {
    @State private var birthDate = Date()
    
    var body: some View {
        VStack {
            Text("birthday")
                .font(.largeTitle.weight(.bold))
                .padding(.top)
            
            VStack(alignment: .leading) {
                Text("choose your birthday")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                DatePicker(selection: $birthDate, in: ...Date(), displayedComponents: .date) {
                    Text("selece your bithday")
                }
                .datePickerStyle(.graphical)
                .frame(width: 300, height: 300, alignment: .center)
            }
            .padding()
            
            Button(action: {}) {
                Text("sign up")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width * 0.8)
            }
            .buttonStyle(.borderedProminent)
//            .tint(.black)
//            .controlSize(.large)
            
            Text("Date is \(birthDate.formatted(date: .long, time: .omitted))")
            
            Spacer()
        }
    }
}

struct BirthdayView_Previews: PreviewProvider {
    static var previews: some View {
        BirthdayView()
    }
}

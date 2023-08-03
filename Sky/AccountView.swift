//
//  AccountView.swift
//  Sky
//
//  Created by rasti najim on 4/6/22.
//

import SwiftUI

struct AccountView: View {
    let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack(spacing: 4) {
                        Image(systemName: "person.crop.circle")
                            .symbolVariant(.circle.fill)
                            .font(.system(size: 32))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .blue.opacity(0.3))
    //                        .foregroundStyle(.blue, .blue.opacity(0.3))
                            .padding()
                            .background(Hexagon().fill(.ultraThinMaterial))
                            .background(
                                Hexagon()
                                    .fill(.linearGradient(Gradient(colors: [gradientStart, gradientEnd]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 200, height: 200)
                                    .offset(x: -50, y: -80)
                            )
                        
                        Text("Zaha Hadid")
                            .fontWeight(.semibold)
                        
                        HStack {
                            Image(systemName: "quote.opening")
                                .imageScale(.small)
                            
                            Text("let's get this bread")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            
                            Image(systemName: "quote.closing")
                                .imageScale(.small)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                
                Section {
                    NavigationLink {
                        Text("Profile")
                    } label: {
                        Label("Profile", systemImage: "person.crop.circle.badge.checkmark")
                    }

                    NavigationLink {
                        Text("Settings")
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }

                    NavigationLink {
                        Text("")
                    } label: {
                        Label("Help", systemImage: "questionmark")
                    }

                }
                .listRowSeparator(.hidden)
                .accentColor(.black)
            }
            .navigationTitle("Account")
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}

//
//  NavigationBar.swift
//  Sky
//
//  Created by rasti najim on 4/1/22.
//

import SwiftUI

struct AnimatableFontModifier: AnimatableModifier {
    var size: Double
    var weight: Font.Weight = .regular
    var design: Font.Design = .default
    
    var animatableData: Double {
        get { size }
        set { size = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: weight, design: design))
    }
}

extension View {
    func animatableFont(size: Double, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        self.modifier(AnimatableFontModifier(size: size, weight: weight, design: design))
    }
}

struct NavigationBar: View {
    @Binding var hasScrolled: Bool
    @State private var showingSheet = false
    @State private var showAccount = false
    
    let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
    
    var body: some View {
        ZStack {
            Color.clear
                .background(.ultraThinMaterial)
                .blur(radius: 10)
                .opacity(hasScrolled ? 1 : 0)
                .ignoresSafeArea()
            
            Text("Messages")
//                .font(.largeTitle.weight(.bold))
                .animatableFont(size: hasScrolled ? 22 : 34, weight: .bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .padding(.top)
                .offset(y: hasScrolled ? -4 : 0)
            
            HStack(spacing: 16) {
                Spacer()
                
                Button(action: {showingSheet.toggle()}) {
                    Image(systemName: "magnifyingglass")
                        .font(.body.weight(.bold))
                        .foregroundColor(.gray)
                        .frame(width: 36, height: 36)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .sheet(isPresented: $showingSheet) {
                    SearchView()
                }
                
                Button(action: {
                    showAccount.toggle()
                }) {
                    Hexagon()
                        .fill(.linearGradient(Gradient(colors: [gradientStart, gradientEnd]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 0.6)))
                        .frame(width: 26, height: 26)
                        .padding(8)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .sheet(isPresented: $showAccount) {
                    AccountView()
                }
            }
            .padding(.trailing)
            .padding(.top)
            .offset(y: hasScrolled ? -4 : 0)
        }
        .frame(height: hasScrolled ? 44 : 70)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(hasScrolled: .constant(false))
    }
}

//
//  SearchView.swift
//  Sky
//
//  Created by rasti najim on 4/2/22.
//

import SwiftUI

struct SearchView: View {
    @State var text = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(0 ..< 5) { item in

                        Button {
                        } label: {
                            HStack {
                                Image("Zaha")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    
                                
                                VStack(alignment: .leading) {
                                    Text("Zaha")
                                        .fontWeight(.semibold)
                                    
                                    Text("yesterday")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.secondary)
                                        .opacity(0)
                                }
                                
                                Spacer()
                                
                                Button {
                                    
                                } label: {
                                    Text("add")
                                        .font(.body.weight(.semibold))
                                        .padding(.horizontal)
                                    
//                                    Image(systemName: "plus")
//                                        .font(.body.weight(.semibold))
//                                        .frame(width: 28, height: 28)
//                                        .background(
//                                            Hexagon().fill(.ultraThinMaterial)
//                                        )
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.blue)

                            }
                            .padding(.vertical)
                            .padding(.horizontal, 5)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                .padding()
            }
            .navigationTitle("Search")
            .searchable(text: $text, placement: .navigationBarDrawer(displayMode: .always))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

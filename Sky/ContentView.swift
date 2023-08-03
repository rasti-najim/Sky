//
//  ContentView.swift
//  Sky
//
//  Created by rasti najim on 3/14/22.
//

import SwiftUI
import LinkPresentation
import Alamofire
import KeychainSwift

struct ScrollPrefernceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct LinkPreview: UIViewRepresentable {
    var metadata: LPLinkMetadata
    
    func makeUIView(context: Context) -> LPLinkView {
        let preview = LPLinkView(metadata: metadata)
        preview.sizeToFit()
        return preview
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.metadata = metadata
    }
}

struct ContentView: View {
    @State private var path = NavigationPath()
    @State private var isActive = false
    @State private var searchableText = ""
    @State private var hasScrolled = false
    @State private var friends: [Friend] = []
    
    var body: some View {
//            FrameView()
//                .edgesIgnoringSafeArea(.all)
        NavigationStack(path: $path) {
            ScrollView {
                GeometryReader { geo in
//                    Text("\(geo.frame(in: .named("scroll")).minY)")
                    Color.clear.preference(key: ScrollPrefernceKey.self, value: geo.frame(in: .named("scroll")).minY)
                }
                .frame(height: 0)
                .onPreferenceChange(ScrollPrefernceKey.self, perform: { value in
                    withAnimation(.easeInOut) {
                        if value < 0 {
                            hasScrolled = true
                        } else {
                            hasScrolled = false
                        }
                    }
                })
                
                
                LazyVStack {
                    ForEach(friends, id: \.self) { friend in
//                        NavigationLink(destination: ChatView(friend: friend), isActive: $isActive, label: { EmptyView() })
                        
                        NavigationLink(value: friend) {
                            Image("Zaha")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                
                            
                            VStack(alignment: .leading) {
                                Text(friend.username)
                                    .fontWeight(.semibold)
                                
                                Text("yesterday")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
//                                    AsyncImage(url: URL(string: "https://picsum.photos/200"))
//                                        .clipShape(Hexagon())
//
//                                    Image(systemName: "chevron.right")
                        }

//                        Button {
//                            isActive.toggle()
//                        } label: {
//                            HStack {
////                                    Image(systemName: "person.circle")
////                                        .font(.largeTitle)
//
////                                    HexagonView()
////                                        .frame(width: 50, height: 50)
////                                        .overlay(Text("R").foregroundColor(.white).font(.title3).fontWeight(.bold))
//
////                                    Hexagon()
////                                        .fill(.gray)
////                                        .frame(width: 50, height: 50)
////                                        .overlay(Text("R").foregroundColor(.white).font(.title3).fontWeight(.bold))
//
//                                Image("Zaha")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 50, height: 50)
//                                    .clipShape(Hexagon())
//
//
//                                VStack(alignment: .leading) {
//                                    Text(friend.username)
//                                        .fontWeight(.semibold)
//
//                                    Text("yesterday")
//                                        .font(.system(size: 14, weight: .semibold))
//                                        .foregroundColor(.secondary)
//                                }
//
//                                Spacer()
//
////                                    AsyncImage(url: URL(string: "https://picsum.photos/200"))
////                                        .clipShape(Hexagon())
////
////                                    Image(systemName: "chevron.right")
//                            }
//                            .padding(.vertical)
//                        }
//                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .buttonStyle(.plain)

            }
            .navigationDestination(for: Friend.self, destination: { friend in
                ChatView(friend: friend, path: $path)
            })
            .navigationBarHidden(true)
//            .listStyle(.plain)
            .coordinateSpace(name: "scroll")
            .safeAreaInset(edge: .top, content: {
                Color.clear.frame(height: 70)
            })
            .overlay(
                NavigationBar(hasScrolled: $hasScrolled)
            )
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        let keychain = KeychainSwift()
        guard let token = keychain.get("token") else { return }
        let headers: HTTPHeaders = [
            "x-auth-token": token
        ]
        
        AF.request("http://10.197.13.73:3000/api/friends", headers: headers).validate().responseDecodable(of: [Friend].self) { response in
            switch response.result {
            case .success:
                if let data = response.value {
                    print(data[0].email)
                    friends = data
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
}

struct Friend: Codable, Hashable {
    let userID, friendID, createdAt, id: String
    let username, email, password, birthDate: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case friendID = "friend_id"
        case createdAt = "created_at"
        case id, username, email, password
        case birthDate = "birth_date"
    }
}


extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}

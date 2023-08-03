//
//  ChatView.swift
//  Sky
//
//  Created by rasti najim on 3/22/22.
//

import SwiftUI
import LinkPresentation
import KeychainSwift
import Alamofire
import SocketIO
import WrappingHStack

struct ChatView: View {
    @State var friend: Friend
    @Binding var path: NavigationPath
    @State private var name = ""
    @State private var showOverlay = false
    @State private var metadata: LPLinkMetadata?
    @State var safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets
    @State var isURL = false
    @State var showingCamera = false
    @State var showingSheet = false
    @State private var showImage = false
    @State private var showSnap = false
    @State private var animateText = false
    @State private var size = 22.0
    @Namespace private var namespace
    @State private var drag: CGSize = .zero
    @StateObject var camera = CameraManager()
    @StateObject var viewModel = ChatViewModel()
    
//    let manager = SocketManager(socketURL: URL(string: "ws://192.168.0.101:3000")!, config: [.log(true)])
    
    let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
    
//    init(friend: Friend) {
//        UITextView.appearance().backgroundColor = .clear
//        self.friend = friend
////        self.path = path
//    }
    
    private var starOverlay: some View {
            Image(systemName: "star")
        .foregroundColor(.white)
        .padding([.top, .trailing], 5)
        }
    
    var frame: CGFloat {
        showImage ? .infinity : 100
    }
    
    var chars: [Character] {
        Array(viewModel.message)
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                HStack {
                    Button {
                        path.removeLast(path.count)
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                    }

                    
                    Spacer()
                    
//                    Text(friend.username)
//                        .font(.title3.weight(.semibold))
//
//                    Spacer()

                    
                    Button(action: {showingSheet.toggle()}) {
                        ZStack {
                            Circle()
                                .fill(.gray)
//                                .fill(.linearGradient(Gradient(colors: [gradientStart, gradientEnd]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 0.6)))
                                .frame(width: 50, height: 50)
                                .overlay(Text("R").foregroundColor(.white).font(.title3).fontWeight(.bold))
                            
//                            Hexagon()
//                                .stroke(.blue, lineWidth: 2)
//                                .frame(width: 50, height: 50)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom)
    //            .padding(.top, safeAreaInsets?.top)
    //            .background(Color.black)
    //            Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.2)
                        .foregroundColor(Color("ChatBubbleGray"))
                    
                    Text("\(viewModel.message)")
                        .fontWeight(.bold)
                        .lineSpacing(4)
                        .frame(width: UIScreen.main.bounds.width * 0.9 - 20, height: UIScreen.main.bounds.height * 0.2)
                    
//                    WrappingHStack(0..<chars.count, id: \.self, spacing: .constant(0), lineSpacing: 10) { index in
//                        Text(String(chars[index]))
//                            .fontWeight(.bold)
////                            .animatableFont(size: index == (chars.count-1) ? size : 16, weight: .bold)
//                            .id(index)
//                    }
//                    .frame(width: UIScreen.main.bounds.width * 0.9 - 20, height: UIScreen.main.bounds.height * 0.2)
//                    .onChange(of: viewModel.message) { newValue in
//                        print("chars:", chars)
////                        print(chars.last)
//                        size = 22
//                        withAnimation {
////                            animateText.toggle()
//                            size = 16
//                        }
//                    }
                    
                    
                    if viewModel.showImage {
                        if let data = Data(base64Encoded: viewModel.base64), let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .matchedGeometryEffect(id: "snap", in: namespace)
                                .mask(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
    //                                    .matchedGeometryEffect(id: "mask", in: namespace)
                                )
                                .frame(width: 100, height: 100)
                            onTapGesture {
                                withAnimation {
                                    showSnap.toggle()
                                }
                            }
                        }
                    }
                }
                        

                TextView(text: $name, showingCamera: $showingCamera, chatID: $viewModel.chatID, socket: $viewModel.socket)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 140)
                    .background(RoundedRectangle(cornerRadius: 32, style: .continuous).stroke(Color.gray))
//                    .cornerRadius(32)
                    .padding()
//                    .overlay(
//                        Text("type something here").bold().foregroundColor(.white).opacity(0.6)
//                    )
    //                .overlay(showOverlay ? starOverlay : nil)
                    .overlay(
                        camera.image != nil ?
                        camera.image
                            .resizable()
                            .scaledToFit()
                            .mask(
                                RoundedRectangle(cornerRadius: !showImage ? 20 : drag.width / 3, style: .continuous)
//                                    .matchedGeometryEffect(id: "mask", in: namespace)
                            )
                            .matchedGeometryEffect(id: "image", in: namespace)
                            .frame(width: 100, height: 100)
                            .scaleEffect(!showImage ? 1 :  drag.width / -500 + 1)
                            .onTapGesture {
                                withAnimation {
                                    showImage.toggle()
                                }
                            } : nil
                    )
//                    .overlay(
//                        Circle()
//                            .fill(.blue)
//                            .frame(width: 20, height: 20)
//                            .padding([.bottom, .trailing], 16)
//                            .overlay(
//                                Circle()
//                                    .fill(.blue)
//                                    .frame(width: 10, height: 10)
//                                    .padding([.bottom, .trailing], 8)
//                                , alignment: .bottomTrailing)
//                        , alignment: .bottomTrailing)

    //            Button {
    //                showOverlay.toggle()
    //            } label: {
    //                Text("Show overlay")
    //            }
                
                Text("\(name.count)")

                Spacer()
            }
            .overlay(.black.opacity(!showImage ? 0 : 0.8 + drag.width / -500))
            
            if showImage {
                ImageView(image: camera.image, namespace: namespace, drag: $drag, showImage: $showImage)
                    .zIndex(1)
                    .transition(.asymmetric(insertion: .opacity.animation(.easeInOut(duration: 0.1)), removal: .opacity.animation(.easeInOut(duration: 0.3).delay(0.2))))
            }
            
            if showSnap {
                if let data = Data(base64Encoded: viewModel.base64), let uiImage = UIImage(data: data) {
                    ImageView(image: Image(uiImage: uiImage), namespace: namespace, drag: $drag, showImage: $showSnap)
                }
            }
        }
        .task {
            await viewModel.load(friend: friend)
            viewModel.connect()
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingCamera) {
            FrameView()
                .environmentObject(viewModel)
        }
        .sheet(isPresented: $showingSheet) {
            Text("sheet")
    }
    }
    
    func fetch(data: String) {
        let metadataProvider = LPMetadataProvider()
        guard let url = URL(string: data) else { return }
        if UIApplication.shared.canOpenURL(url) {
            isURL = true
        } else {
            isURL = false
        }
        
        metadataProvider.startFetchingMetadata(for: url) { metadata, error in
            DispatchQueue.main.async {
                if error != nil {
                    return
                }
                
                DispatchQueue.main.async {
                    if let metadata = metadata {
                        self.metadata = metadata
                    }
                }
            }
        }
        
        
    }
}

struct Chat: Codable {
    let chatID, friendOneID, friendTwoID: String

    enum CodingKeys: String, CodingKey {
        case chatID = "chat_id"
        case friendOneID = "friend_one_id"
        case friendTwoID = "friend_two_id"
    }
}


struct TextView: UIViewRepresentable {
    
    @Binding var text: String
    @Binding var showingCamera: Bool
    @Binding var chatID: String
    @Binding var socket: SocketIOClient?
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = .boldSystemFont(ofSize: 16)
        textView.textColor = .white
//        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        let deadSpace = textView.bounds.size.height - textView.contentSize.height
        let inset = max(0, deadSpace / 2.0)
        textView.contentInset = UIEdgeInsets(top: inset, left: textView.contentInset.left, bottom: inset, right: textView.contentInset.right)
        textView.textAlignment = .center
        textView.text = "type somthing here"
        textView.textColor = .lightGray
        textView.returnKeyType = .next
        textView.backgroundColor = .clear
        textView.delegate = context.coordinator
        
//        let inputAccessoryView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
//        inputAccessoryView.backgroundColor = .clear
//        inputAccessoryView.addSubview(UIImageView(image: UIImage(systemName: "camera.fill")!))
//
//        textView.inputAccessoryView = inputAccessoryView
        
        let inputAccessoryView = UIHostingController(rootView: InputAccessoryView(showingCamera: $showingCamera, chatID: $chatID, socket: $socket))
        inputAccessoryView.view.frame = CGRect(x: 0, y: 0, width: 10, height: 44)
        textView.inputAccessoryView = inputAccessoryView.view
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView
        
        init(_ uiTextView: TextView) {
            parent = uiTextView
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == .lightGray {
                textView.text = nil
                textView.textColor = .black
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = "type something here"
                textView.textColor = .lightGray
            }
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                parent.text = ""
                textView.text = ""
//                if let socket = parent.socket {s
//                    socket.emit("message", textView.text, parent.chatID)
//                }
                return false
            }
            
            return textView.text.count + (text.count - range.length) <= 140
        }
        
        func textViewDidChange(_ textView: UITextView) {
            if textView.text.count <= 140 {
                parent.text = textView.text
                
                if let socket = parent.socket {
                    socket.emit("message", String(textView.text.last ?? "\0"), parent.chatID)
                }
            }
            
            let deadSpace = textView.bounds.size.height - textView.contentSize.height
            let inset = max(0, deadSpace / 2.0)
            textView.contentInset = UIEdgeInsets(top: inset, left: textView.contentInset.left, bottom: inset, right: textView.contentInset.right)
        }
    }
}

struct InputAccessoryView: View {
    @Binding var showingCamera: Bool
    @Binding var chatID: String
    @Binding var socket: SocketIOClient?
    
    var body: some View {
        HStack(spacing: 15) {
//            Button(action: {showingCamera.toggle()}) {
//                Image(systemName: "camera.fill")
//                    .font(.title3.weight(.semibold))
//                    .foregroundColor(.gray)
//                    .frame(width: 42, height: 42)
//                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
//
////                Circle()
////                    .fill(.ultraThinMaterial)
////                    .frame(width: 42, height: 42)
////                    .overlay(Image(systemName: "camera.fill").font(.title3.weight(.semibold)).foregroundColor(.gray))
//            }
            
            Spacer()
            
            Button(action: {}) {
                Text("heyyy")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .buttonStyle(.bordered)
            .tint(.gray)
//            .tint(.yellow)
            
            Button(action: {}) {
                Text("heyyy")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            
//            Circle()
//                .fill(Color("ChatBubbleGray"))
//                .frame(width: 42, height: 42)
//                .overlay(Text("169").fontWeight(.heavy).foregroundColor(.secondary))
            
            Text("169")
                .font(.title3.weight(.semibold))
                .foregroundColor(.gray)
            
//            Circle()
//                .fill(Color("ChatBubbleGray"))
//                .frame(width: 42, height: 42)
//                .overlay(Image(systemName: "trash"))
            
            Button {
                if let socket = socket {
                    socket.emit("message", "", chatID)
                }
            } label: {
                Image(systemName: "trash")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.gray)
                    .frame(width: 42, height: 42)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }

        }
        .padding(.horizontal)
        .padding(.bottom)
//        .frame(width: UIScreen.main.bounds.width * 0.9)
    }
}

//struct LinkPreviewOverlay: View {
//    @Binding var metadata: LPLinkMetadata?
//
//    var body: some View {
//        if let metadata = metadata {
//            Image(metadata.imageProvider)
//        }
//    }
//
//    func loadData() {
//
//    }
//}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView(friend: Friend(userID: "", friendID: "", createdAt: "", id: "", username: "", email: "", password: "", birthDate: ""))
//            .previewInterfaceOrientation(.portrait)
//    }
//}

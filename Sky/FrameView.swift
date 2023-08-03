//
//  CameraView.swift
//  Sky
//
//  Created by rasti najim on 3/17/22.
//

import SwiftUI
import AVFoundation
import SocketIO

struct FrameView : View {
    @EnvironmentObject var viewModel: ChatViewModel
    @StateObject var camera = CameraManager()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            if camera.isConfigured {
                CameraView(camera: camera)
                    .ignoresSafeArea(.all, edges: .all)
            }
            
            if !camera.isTaken {
                VStack {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.down")
                                .foregroundColor(.secondary)
                                .font(.title3.weight(.bold))
                                .frame(width: 42, height: 42)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        Spacer()
                        
                        Button(action: {
                            camera.position = camera.position == .front ? .back : .front
                        }) {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.gray)
                                .frame(width: 42, height: 42)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        camera.capture()
                    } label: {
                        Circle()
                            .stroke(.ultraThinMaterial, lineWidth: 5)
                            .frame(width: 75, height: 75)
                    }

                }
                .padding()
            } else {
//                GeometryReader { geo in
//                    camera.image
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
//                        .clipped()
//                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
//                }
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Button(action: camera.retake) {
                            Image(systemName: "multiply")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.secondary)
                                .frame(width: 42, height: 42)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }

                    }
                    .padding()
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            camera.send()
                            dismiss()
                        }, label: {
                            Text("send")
                                .foregroundColor(.black)
                                .font(.title3.weight(.semibold))
                            
                            Image(systemName: "arrow.up")
                                .foregroundColor(.black)
                                .imageScale(.large)
                        })
                            .buttonStyle(.borderedProminent)
                            .tint(.yellow)

                    }
                    .padding()
                }
            }
        }
        .task {
            camera.chatID = viewModel.chatID
            camera.socket = viewModel.socket
            camera.checkPermissions()
        }
        
    }
}

struct CameraView: UIViewRepresentable {
    @ObservedObject var camera: CameraManager
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        camera.preview.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(camera.preview)
        camera.session.startRunning()
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView()
    }
}

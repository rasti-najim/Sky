//
//  CameraManager.swift
//  Sky
//
//  Created by rasti najim on 3/17/22.
//

import Foundation
import AVFoundation
import SwiftUI
import SocketIO

class CameraManager: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
//    static let shared = CameraManager()
    
    
//    @Published var error: CameraError?
    var chatID = ""
    var socket: SocketIOClient?
    
    @Published var session = AVCaptureSession()
    @Published var photoOutput = AVCapturePhotoOutput()
    @Published var preview: AVCaptureVideoPreviewLayer!
    @Published var position: AVCaptureDevice.Position = .front
    @Published var image: Image!
    @Published var isTaken = false
    @Published var isConfigured = false
    private var imageData = Data()
    
//    private func configure() {
//        checkPermissions()
//        configureCaptureSession()
//    }
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureCaptureSession()
            return
        
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                if authorized {
                    self.configureCaptureSession()
                }
//                self.sessionQueue.resume()
            }
            
        case .restricted:
//            self.status = .unauthorized
            return
            
        case .denied:
//            self.status = .unauthorized
            return
            
        default:
//            status = .unauthorized
            return
        }
        }
    
    private func configureCaptureSession() {
//        guard status == .unconfigured else { return }
        
        do {
            session.beginConfiguration()
                
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
                
            guard let camera = device else {
                return
            }
                
            
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            if session.canAddInput(cameraInput) {
                session.addInput(cameraInput)
            }
                
            if session.canAddOutput(photoOutput) {
                session.addOutput(photoOutput)
    //            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
    //
    //            let videoConnection = videoOutput.connection(with: .video)
    //            videoConnection?.videoOrientation = .portrait
                
            }
            
            
            session.commitConfiguration()
            
            isConfigured = true
            print("configured")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func capture() {
        DispatchQueue.global(qos: .background).async {
            self.photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            guard let connection =  self.photoOutput.connection(with: .video) else { return }
            connection.isVideoMirrored = self.position == .front
            self.session.stopRunning()
            
            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken.toggle()
                }
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else { return }
//        print(imageData.base64EncodedString())
        self.imageData = imageData
        guard let uiImage = UIImage(data: imageData) else { return }
        self.image = Image(uiImage: uiImage)
    }
    
    func send() {
        socket?.emit("image", imageData.base64EncodedString(), chatID)
    }
    
    func retake() {
        print("retake")
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken.toggle()
                }
            }
        }
    }
}

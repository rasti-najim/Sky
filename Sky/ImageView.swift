//
//  ImageView.swift
//  Sky
//
//  Created by rasti najim on 4/5/22.
//

import SwiftUI

struct ImageView: View {
    var image: Image
    var namespace: Namespace.ID
    @Binding var drag: CGSize
    @Binding var showImage: Bool
    
    var body: some View {
        ZStack {
            image
                .resizable()
                .scaledToFill()
                .mask(
                    RoundedRectangle(cornerRadius: drag.width / 3, style: .continuous)
                )
                .matchedGeometryEffect(id: "image", in: namespace)
                .frame(width: UIScreen.main.bounds.width)
                .scaleEffect(drag.width / -500 + 1)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            guard value.translation.width > 0 else { return }
                            if value.startLocation.x < 100 {
                                drag = value.translation
                            }
                        }
                        .onEnded { value in
                            if drag.width > 80 {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.9)) {
                                    showImage.toggle()
                                }
                            }

                            withAnimation(.spring(response: 0.6, dampingFraction: 0.9)) {
                                drag = .zero
                            }
                        }
                )
            
//                RoundedRectangle(cornerRadius: 20, style: .continuous)
//                    .fill(.red)
//                    .matchedGeometryEffect(id: "image", in: namespace, properties: .frame)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .scaleEffect(drag.width / -500 + 1)
//                    .onTapGesture {
//                        withAnimation(.spring(response: 0.6, dampingFraction: 0.9)) {
//                            showImage.toggle()
//                        }
//                    }
//                    .gesture(
//                        DragGesture()
//                            .onChanged { value in
//                                guard value.translation.width > 0 else { return }
//                                if value.startLocation.x < 100 {
//                                    drag = value.translation
//                                }
//                            }
//                            .onEnded { value in
////                                if drag.width > 80 {
////                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.9)) {
////                                        showImage.toggle()
////                                    }
////                                    return
////                                }
//
//                                withAnimation(.spring()) {
//                                    drag = .zero
//                                }
//                            }
//                    )
        }
    }
}

//struct ImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageView()
//    }
//}

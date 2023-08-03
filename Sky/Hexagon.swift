//
//  Hexagon.swift
//  Sky
//
//  Created by rasti najim on 3/27/22.
//

import SwiftUI

struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        var width: CGFloat = rect.width
        let height = width
        let xScale: CGFloat = 0.832
        let xOffset = (width * (1.0 - xScale)) / 2.0
                        width *= xScale
                        path.move(
                            to: CGPoint(
                                x: width * 0.95 + xOffset,
                                y: height * (0.20 + HexagonParameters.adjustment)
                            )
                        )

                        HexagonParameters.segments.forEach { segment in
                            path.addLine(
                                to: CGPoint(
                                    x: width * segment.line.x + xOffset,
                                    y: height * segment.line.y
                                )
                            )

                            path.addQuadCurve(
                                to: CGPoint(
                                    x: width * segment.curve.x + xOffset,
                                    y: height * segment.curve.y
                                ),
                                control: CGPoint(
                                    x: width * segment.control.x + xOffset,
                                    y: height * segment.control.y
                                )
                            )
                        }
        return path
    }
}

struct HexagonView: View {
    
    static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
    
    var body: some View {
        GeometryReader { geo in
            Path { path in
                var width: CGFloat = min(geo.size.width, geo.size.height)
                let height = width
                let xScale: CGFloat = 0.832
                let xOffset = (width * (1.0 - xScale)) / 2.0
                                width *= xScale
                                path.move(
                                    to: CGPoint(
                                        x: width * 0.95 + xOffset,
                                        y: height * (0.20 + HexagonParameters.adjustment)
                                    )
                                )

                                HexagonParameters.segments.forEach { segment in
                                    path.addLine(
                                        to: CGPoint(
                                            x: width * segment.line.x + xOffset,
                                            y: height * segment.line.y
                                        )
                                    )

                                    path.addQuadCurve(
                                        to: CGPoint(
                                            x: width * segment.curve.x + xOffset,
                                            y: height * segment.curve.y
                                        ),
                                        control: CGPoint(
                                            x: width * segment.control.x + xOffset,
                                            y: height * segment.control.y
                                        )
                                    )
                                }

            }
            .fill(.linearGradient(Gradient(colors: [Self.gradientStart, Self.gradientEnd]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 0.6)))
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct Hexagon_Previews: PreviewProvider {
    static var previews: some View {
        HexagonView()
    }
}

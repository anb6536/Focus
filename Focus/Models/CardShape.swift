//
//  CardShape.swift
//  Focus
//
//  Created by Aahish Balimane on 5/2/22.
//

import Foundation
import SwiftUI

struct CardShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(CardShape(radius: radius, corners: corners))
    }
}

//
//  DetailImageModifier.swift
//  AshMusic
//
//  Created by Ashwin A U on 05/05/23.
//

import SwiftUI

struct DetailImageModifier: ViewModifier {
    init(cornerRadius: Double = 12, height: Double = 200) {
        self.cornerRadius = cornerRadius
        self.height = height
    }

    var cornerRadius: Double = 12
    var height: Double = 200
    var horizontalPadding: Double = 20
    func body(content: Content) -> some View {
        content
            .cornerRadius(cornerRadius)
            .frame(height: height)
            .aspectRatio(contentMode: .fill)
            
    }
}

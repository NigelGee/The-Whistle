//
//  Modifier.swift
//  The Whistle
//
//  Created by Nigel Gee on 20/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct Buttons: ViewModifier {
    var colour: Color
    
    func body(content: Content) -> some View{
        content
            .foregroundColor(.white)
            .frame(width: 200, height: 50)
            .background(colour)
            .clipShape(Capsule())
            .padding(.top)
    }
}

extension View {
    func buttonStyle(colour: Color) -> some View {
        self.modifier(Buttons(colour: colour))
    }
}

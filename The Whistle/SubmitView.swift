//
//  SubmitView.swift
//  The Whistle
//
//  Created by Nigel Gee on 19/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct SubmitView: View {
    @State var text = ""
    @State var height: CGFloat = 0
    var genre: String
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ResizableTextField(text: $text, height: $height)
                .frame(height: height)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(15)
                
            Spacer()
        }
        .navigationBarItems(trailing: NavigationLink(destination: LoadingView(genre: genre, comments: text)) {
            Text("Submit")
        })
        
    }
}

struct SubmitView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitView(genre: "")
    }
}

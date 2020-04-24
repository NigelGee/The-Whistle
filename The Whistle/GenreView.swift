//
//  GenreView.swift
//  The Whistle
//
//  Created by Nigel Gee on 19/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct GenreView: View {
    static var genres = ["Unknown", "Blues", "Classical", "Electronic", "Jazz", "Metal", "Pop", "Reggae", "RnB", "Rock", "Soul"]
    
    var genre: String = ""
    
    var body: some View {
        List {
            ForEach(GenreView.genres, id: \.self) { genre in
                NavigationLink(destination: SubmitView(genre: genre)) {
                    Text(genre)
                }
            }
        }
    }
}

struct GenreView_Previews: PreviewProvider {
    static var previews: some View {
        GenreView()
    }
}

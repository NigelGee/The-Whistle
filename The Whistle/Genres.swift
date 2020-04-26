//
//  MyGenres.swift
//  The Whistle
//
//  Created by Nigel Gee on 25/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import Foundation

class Genres: ObservableObject {
    @Published var list: [Genre]!
}

struct Genre: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var checkmark = false
}

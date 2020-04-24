//
//  Whistle.swift
//  The Whistle
//
//  Created by Nigel Gee on 20/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import Foundation
import CloudKit

class Whistles: ObservableObject {
    @Published var list: [Whistle] = []
}

struct Whistle: Identifiable, Hashable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var genre: String?
    var comments: String?
    var audio: URL?
}

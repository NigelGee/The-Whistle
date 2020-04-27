//
//  ResultsView.swift
//  The Whistle
//
//  Created by Nigel Gee on 23/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
import AVFoundation
import CloudKit

enum status {
    case download, loading, listen
}

struct ResultsView: View {
    var whistle: Whistle!
    @State private var whistlePlayer: AVAudioPlayer!
    @State private var audio: URL!
    @State private var suggestions = [String]()
    @State private var textField = ""
    @State private var downloadStatus: status = .download
    
    var body: some View {
        List {
            Text("\(whistle.comments == "" ? "Comments: None" : whistle.comments!)")
                .font(.title)
            Section(header: Text("Suggested songs")) {
                HStack {
                    TextField("Add suggestion", text: $textField)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Add") {
                        self.add()
                    }
                }
                
                ForEach(suggestions, id: \.self) {
                    Text($0)
                }
            }
        }
    .onAppear(perform: fetch)
        .navigationBarTitle("Genre: \(whistle.genre!)")
        .navigationBarItems(
            leading: EmptyView(),
            trailing: Button(action: {
                if self.downloadStatus == . download {
                    self.fetchWhistle()
                } else if self.downloadStatus == .listen {
                    self.listen()
                }
            }) {
                if downloadStatus == .download {
                    Text("Download")
                } else if downloadStatus == .loading {
                    Spinner(isAnimating: true, style: .medium, color: .gray)
                } else if downloadStatus == .listen {
                    Text("Listen")
                }
            })
    }
    
    func add() {
        let whistleRecord = CKRecord(recordType: "Suggestions")
        if let recordID = whistle.recordID {
            let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
            whistleRecord["text"] = textField as CKRecordValue
            whistleRecord["owningWhistle"] = reference as CKRecordValue
            
            CKContainer.default().publicCloudDatabase.save(whistleRecord) { record, error in
                DispatchQueue.main.async {
                    if error == nil {
                        self.suggestions.append(self.textField)
                    } else {
                        print(error!.localizedDescription)
                    }
                }
            }
        }
    }
    
    func fetch() {
        if let recordID = whistle.recordID {
            let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
            let predicate = NSPredicate(format: "owningWhistle == %@", reference)
            let sort = NSSortDescriptor(key: "creationDate", ascending: true)
            let query = CKQuery(recordType: "Suggestions", predicate: predicate)
            query.sortDescriptors = [sort]
            
            CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (results, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let results = results {
                        var newSuggestions = [String]()
                        
                        for record in results {
                            newSuggestions.append(record["text"] as! String)
                        }
                        
                        DispatchQueue.main.async {
                            self.suggestions = newSuggestions
                        }
                    }
                }
            }
        }
    }
    
    func fetchWhistle() {
        downloadStatus = .loading
        
        if let recordID = whistle.recordID {
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                        self.downloadStatus = .download
                    }
                } else {
                    if let record = record {
                        if let asset = record["audio"] as? CKAsset {
                            self.audio = asset.fileURL
                            
                            DispatchQueue.main.async {
                                self.downloadStatus = .listen
                            }
                        }
                    }
                }
            }
        }
    }
    
    func listen() {
        do {
            whistlePlayer = try AVAudioPlayer(contentsOf: audio)
            whistlePlayer.play()
        } catch {
            print("Playback failed")
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
    }
}

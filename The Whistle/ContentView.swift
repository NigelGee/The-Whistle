//
//  ContentView.swift
//  The Whistle
//
//  Created by Nigel Gee on 19/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
import CloudKit

struct ContentView: View {
    @ObservedObject var whistles = Whistles()
    
    @State private var myGenres = [String]()
    @State private var showingAddWhistleView = false
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(whistles.list, id: \.id) { whistle in
                    NavigationLink(destination: ResultsView(whistle: whistle)) {
                        VStack(alignment: .leading) {
                            Text(whistle.genre ?? "")
                                .font(.headline)
                                .foregroundColor(.purple)
                            Text(whistle.comments ?? "")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .onAppear(perform: loadWhistles)
            .sheet(isPresented: $showingAddWhistleView, content: {
                AddWhistleView()
            })
            .navigationBarTitle("What's that Whistle?", displayMode: .inline)
            .navigationBarItems(
                leading:
                NavigationLink(destination: MyGenresView(myGenres: myGenres)) {
                    Text("Genres")
                },
                trailing:
                NavigationLink(destination: AddWhistleView()) {
                    Image(systemName: "plus")
            })
        }
    }
    
    func loadWhistles() {
        let predicate = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: "Whistles", predicate: predicate)
        query.sortDescriptors = [sort]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["genre", "comments"]
        operation.resultsLimit = 50
        
        var newWhistles = [Whistle]()
        
        operation.recordFetchedBlock = { record in
            var whistle = Whistle()
            whistle.recordID = record.recordID
            whistle.genre = record["genre"]
            whistle.comments = record["comments"]
            newWhistles.append(whistle)
        }
        
        operation.queryCompletionBlock = { (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    self.whistles.list = newWhistles
                } else {
                    print(error?.localizedDescription ?? "Unknown Error")
                }
            }
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
        
        let defaults = UserDefaults.standard
        if let savedGenres = defaults.object(forKey: "myGenres") as? [String] {
            self.myGenres = savedGenres
        } else {
            self.myGenres = [String]()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

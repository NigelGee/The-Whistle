//
//  MyGenresView.swift
//  The Whistle
//
//  Created by Nigel Gee on 25/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
import CloudKit

struct MyGenresView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var myGenres: [String]
    
    var body: some View {
        List {
            ForEach(GenreView.genres, id: \.self) { genre in
                HStack {
                    Text(genre)
                    Spacer()
                    if self.myGenres.contains(genre) {
                        Image(systemName: "checkmark")
                    }
                }
                .onTapGesture {
                    if !self.myGenres.contains(genre) {
                        self.myGenres.append(genre)
                    } else {
                        for i in 0..<self.myGenres.count {
                            if genre == self.myGenres[i] {
                                self.myGenres.remove(at: i)
                                break
                            }
                        }
                    }
                    print(self.myGenres)
                }
            }
        }
        .navigationBarTitle("Notify me about...")
        .navigationBarItems(trailing: Button("Save") {
            self.saveTapped()
        })
    }
        
    func saveTapped() {
        let defaults = UserDefaults.standard
        defaults.set(myGenres, forKey: "myGenres")
        
        
        let database = CKContainer.default().publicCloudDatabase
        
        database.fetchAllSubscriptions { subscriptions, error in
            if error == nil {
                if let subscriptions = subscriptions {
                    for subscription in subscriptions {
                        database.delete(withSubscriptionID: subscription.subscriptionID) { (str, error) in
                            if error != nil {
                                print(error!.localizedDescription)
                            }
                        }
                    }
                    print("Genre")
                    for genre in self.myGenres {
                        let predicate = NSPredicate(format: "genre = %@", genre)
                        let subscription = CKQuerySubscription(recordType: "Whistles", predicate: predicate, options: .firesOnRecordCreation)
                        
                        let notification = CKSubscription.NotificationInfo()
                        notification.shouldBadge = true
                        notification.subtitle = "\(genre) genre"
                        notification.alertBody = "There's a new whistle in the \(genre) genre."
                        notification.soundName = "default"
                        
                        subscription.notificationInfo = notification
                        
                        database.save(subscription) { result, error in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct MyGenresView_Previews: PreviewProvider {
    static var previews: some View {
        MyGenresView(myGenres: [])
    }
}

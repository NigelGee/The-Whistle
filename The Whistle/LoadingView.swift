//
//  LoadingView.swift
//  The Whistle
//
//  Created by Nigel Gee on 20/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
import CloudKit

struct LoadingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showLoading = true
    var genre: String
    var comments: String
    
    var body: some View {
        Group {
            if showLoading {
                ZStack {
                    Color.gray
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Text("Submitting...")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        
                        Spinner(isAnimating: true, style: .large, color: .white)
                        
                    }
                }.onAppear(perform: doSubmission)
            } else {
                ZStack {
                    Color.green
                        .edgesIgnoringSafeArea(.all)
                    Button("Done!") {
                        //MARK:- TODO: Return to Content View
                    }
                    .font(.largeTitle)
                }
            }
        }
        .navigationBarBackButtonHidden(showLoading ? true : false)
    }
    
    func doSubmission() {
        let whistleRecord = CKRecord(recordType: "Whistles")
        
        whistleRecord["genre"] = genre as CKRecordValue
        whistleRecord["comments"] = comments as CKRecordValue
        
        let audioURL = Helper.getWhistleURL()
        let whistleAsset = CKAsset(fileURL: audioURL)
        whistleRecord["audio"] = whistleAsset
        
        CKContainer.default().publicCloudDatabase.save(whistleRecord) { record, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.showLoading = false
                }
            }
        }
        
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(genre: "Unknown", comments: "")
    }
}

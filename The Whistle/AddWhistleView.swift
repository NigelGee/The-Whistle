//
//  AddWhistleView.swift
//  The Whistle
//
//  Created by Nigel Gee on 19/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
import AVFoundation

enum recordingState {
    case record, stop, reRecord
}

struct AddWhistleView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingState: recordingState = .record
    @State private var whistleRecorder: AVAudioRecorder!
    @State private var whistlePlayer: AVAudioPlayer!
    @State private var nextDisabled = true
    @State private var showingAlert = false
    @State private var message = ""
    @State private var title = ""
    
    var body: some View {
        VStack {
            if showingState == .record {
                ZStack {
                    Color.gray
                        .edgesIgnoringSafeArea(.all)
                    Button(action: {
                        self.recordSession()
                    }) {
                        Text("Tap to Record")
                            
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    
                }
            } else if showingState == .stop {
                ZStack {
                    Color.blue
                        .edgesIgnoringSafeArea(.all)
                    Button(action: {
                        self.finishRecording(success: true)
                    }) {
                        Text("Tap to Stop")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                }
            } else if showingState == .reRecord {
                ZStack {
                    
                    Color.yellow
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Button(action: {
                            self.startRecording()
                        }) {
                            Text("Tap to Re-Record")
                        }
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        
                        if whistleRecorder != nil {
                            
                            Button(action: {
                                self.playWhistle()
                            }) {
                                Text("Tap to Play")
                            }
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .padding(.top, 20)
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK")))
        })
        .navigationBarTitle("Record your whistle", displayMode: .inline)
        .navigationBarItems(leading: Button("Home") {
            self.presentationMode.wrappedValue.dismiss()
            }, trailing: NavigationLink(destination: GenreView()) {
                Text("Next")
            }.disabled(nextDisabled))
        
    }
    
    func recordSession() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.startRecording()
                    } else {
                        self.title = "Record Failed"
                        self.message = "Please ensure the app has access to your microphone."
                        self.showingAlert.toggle()
                    }
                }
            }
        } catch {
            self.title = "Record Failed"
            self.message = "Please ensure the app has access to your microphone."
            self.showingAlert.toggle()
        }
    }
    
    func startRecording() {
        showingState = .stop
        whistleRecorder = nil
        
        let audioURL = Helper.getWhistleURL()
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            whistleRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            whistleRecorder.record()
        } catch {
            self.finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        
        whistleRecorder.stop()
        
        if success {
            showingState = .reRecord
            nextDisabled.toggle()
        } else {
            showingState = .record
            title = "Recording Failed"
            message = "There was problem recording your whistle, please try again"
            showingAlert.toggle()
        }
    }
    
    func playWhistle() {
        let audioURL = Helper.getWhistleURL()
        
        do {
            whistlePlayer = try AVAudioPlayer(contentsOf: audioURL)
            whistlePlayer.play()
        } catch {
            title = "Playback failed"
            message = "There was a problem playing your whistle, please try re-recording."
            showingAlert.toggle()
        }
    }
}

struct AddWhistleView_Previews: PreviewProvider {
    static var previews: some View {
        AddWhistleView()
    }
}

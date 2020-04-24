//
//  ResizableTextField.swift
//  The Whistle
//
//  Created by Nigel Gee on 22/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct ResizableTextField: UIViewRepresentable {
    let placeHolder = "If you have any additional comments that might help identify your tune, enter them here."
    
    @Binding var text: String
    @Binding var height: CGFloat
    
    func makeCoordinator() -> Coordinator {
        return ResizableTextField.Coordinator(parent1: self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isEditable = true
        view.isScrollEnabled = true
        view.text = placeHolder
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.textColor = .gray
        view.backgroundColor = .clear
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        DispatchQueue.main.async {
            self.height = uiView.contentSize.height
        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        var parent: ResizableTextField
        
        init(parent1: ResizableTextField) {
            parent = parent1
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if self.parent.text == "" {
                textView.text = ""
                textView.textColor = .black
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.height = textView.contentSize.height
                self.parent.text = textView.text
            }
        }
    }
}

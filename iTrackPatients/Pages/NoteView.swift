//
//  NoteView.swift
//  iTrackPatients
//
//  Created by Guren Icim on 8.05.2023.
//

import SwiftUI

func inputBackgroundCreator(color: Color) -> some View {
    RoundedRectangle(cornerRadius: 15).fill(color.opacity(0.8))
        .padding(.horizontal, -16)
        .padding(.vertical,-8)
}

struct NoteView: View {
    @Binding var notes: String
    @Binding var isShown: Bool
    @FocusState var isInputActive
    var edgeTransition: AnyTransition = .move(edge: .bottom)
    var body: some View {
        ZStack {
            if isShown {
                Color.white
                    .ignoresSafeArea()
                VStack {
                    Section (header: Text("Notlar")) {
                        TextEditor(text: $notes).frame(maxWidth: 300, minHeight: 50.0, maxHeight: 200).background(inputBackgroundCreator(color: .yellow)).scrollContentBackground(.hidden)
                            .padding(20)
                    }.multilineTextAlignment(.leading)
                        .focused($isInputActive)
                    HStack {
                        Button {
                            notes = ""
                            isInputActive = false
                            isShown = false
                        } label: {
                            Label("İptal Et",systemImage: "camera.circle").background(inputBackgroundCreator(color: .red))
                                .labelStyle(.titleOnly)
                        }.padding(.bottom,16)
                            .padding(.horizontal,16)
                            .foregroundColor(Color.black)
                        Button {
                            isInputActive = false
                            isShown = false
                        } label: {
                            Label("Kaydet",systemImage: "camera.circle").background(inputBackgroundCreator(color: .green))
                                .labelStyle(.titleOnly)
                        }.padding(.bottom,16)
                            .padding(.horizontal,16)
                            .foregroundColor(Color.black)
                    }.onTapGesture {
                        isInputActive = false
                    }
                }.background(RoundedRectangle(cornerRadius: 0).fill(Color.white)).ignoresSafeArea(.all)
            }
        }.animation(.easeInOut(duration: 0.5) , value: isShown)
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        @State var notes: String = "hello"
        @State var isShown: Bool = true
        NoteView(notes: $notes, isShown: $isShown)
    }
}

//
//  PDFView.swift
//  iTrackPatients
//
//  Created by Guren Icim on 8.06.2023.
//

import SwiftUI

struct PDFView: View {
    var name = "", surname = "", mobile = "", id = "", notes = ""
    @Binding var date: Date
    var scans: [UIImage] = [UIImage]()
    
    func inputBackgroundCreator(color: Color) -> some View {
        RoundedRectangle(cornerRadius: 50).fill(color.opacity(0.8))
            .padding(.horizontal, -16)
            .padding(.vertical,-8)
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height: 16)
            let image = Image(systemName: "cross.case.fill")
            image.foregroundColor(.red).font(.largeTitle)
            HStack {
                Text("Patient Record").font(.largeTitle)
            }
            Text(name + " " + surname).font(.title).background(inputBackgroundCreator(color: .red)).padding(8).onTapGesture {
                print(notes)
            }
            HStack {
                Text("TCKN: " + id).background(RoundedRectangle(cornerRadius: 200).fill(Color.green.opacity(0.8))
                    .padding(.horizontal, -8)
                    .padding(.vertical,-8)).padding(8)
                Text("Tel: " + mobile).background(RoundedRectangle(cornerRadius: 200).fill(Color.yellow.opacity(0.8))
                    .padding(.horizontal, -8)
                    .padding(.vertical,-8)).padding(8)
            }
            Text(date.formatted(date: .numeric, time: .shortened)).background(RoundedRectangle(cornerRadius: 200).fill(Color.blue.opacity(0.8))
                .padding(.horizontal, -16)
                .padding(.vertical,-8)).padding(6)
            VStack {
                Text(notes).background(RoundedRectangle(cornerRadius: 200).fill(Color.orange.opacity(0.8))
                    .padding(.horizontal, -16)
                    .padding(.vertical,-8)).padding(20)
            }.frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                ForEach(0..<scans.count, id: \.self) { i in
                    HStack {
                        Image(uiImage: scans[i])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: 200, minHeight: 0, maxHeight: 300)
                            .clipped()
                            .aspectRatio(1, contentMode: .fit).background(inputBackgroundCreator(color: .indigo))
                    }
                }
            }
        }
        
    }
}

struct PDFView_Previews: PreviewProvider {
    static var previews: some View {
        @State var date = Date()
        PDFView(name: "Guren", surname: "Icim", mobile: "0542xxxxxxx", id: "55555555555",notes: "Hello, here is some notes...",date: $date)
    }
}

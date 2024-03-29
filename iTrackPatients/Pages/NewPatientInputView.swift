//
//  NewPatientInputView.swift
//  iTrackPatients
//
//  Created by Guren Icim on 8.05.2023.
//

import Foundation
import SwiftUI
import PhotosUI
import VisionKit

@MainActor struct NewPatientInputView: View {
    @State private var date = Date()
    @State private var name: String = String()
    @State private var surname: String = String()
    @State private var id: String = String()
    @State private var mobile: String = String()
    @State var notes: String = String()
    @State var scans = [UIImage]()
    @State var isClicked: Bool = false
    @State private var showingShareLink: Bool = false
    @State private var clearColor: Color = Color.clear
    @State private var isCameraShown: Bool = false
    @State private var isNotePageShown: Bool = false
    @State var pdfURL: URL = URL(fileURLWithPath: "null")
    @FocusState var isInputActive
    
    func getDirName() -> String {
        return self.name + self.surname + "-" + self.id
    }
    
    func getFileName() -> String {
        return self.name + self.surname + "-" + self.mobile + self.date.formatted(date: .numeric, time: .shortened) + ".pdf"
    }
    
    func createPDFView () -> any View {
        PDFViewX(name: name, surname: surname,mobile: mobile, id: id,notes: notes, date: $date, scans: scans)
    }
    
    func render(dirName: String, content: PDFViewX) -> URL {
        // 1: Render Hello World with some modifiers
        let renderer = ImageRenderer(content: content)
                
        // 2: Save it to our documents directory
        let folderUrl = createDirWithName(dirName: dirName)
        let url = URL.documentsDirectory.appending(path:dirName + "/" + date.formatted(date: .numeric, time: .omitted) + "-" + date.formatted(date: .omitted, time: .shortened) + ".pdf")
        
        // 3: Start the rendering process
        renderer.render { size, context in
            // 4: Tell SwiftUI our PDF should be the same size as the views we're rendering
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            // 5: Create the CGContext for our PDF pages
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }
            
            // 6: Start a new PDF page
            pdf.beginPDFPage(nil)
            
            // 7: Render the SwiftUI view data onto the page
            context(pdf)
            
            // 8: End the page and close the file
            pdf.endPDFPage()
            pdf.closePDF()
            
        }
        
        return url
    }
    
    private func createDirWithName(dirName: String) -> URL {
        let pathUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(dirName, conformingTo: .folder)
        let folderExists = (try? pathUrl.checkResourceIsReachable()) ?? false
        if !folderExists {
            try? FileManager.default.createDirectory(atPath: pathUrl.path, withIntermediateDirectories: false)
        }
        return pathUrl
    }
    
    func inputBackgroundCreatorFromTrailing(color: Color) -> some View {
        RoundedRectangle(cornerRadius: 15).fill(color.opacity(0.8)).padding(.trailing,-50).padding(.leading,-10).padding(.vertical,-5)
    }
    
    func inputBackgroundCreator(color: Color) -> some View {
        RoundedRectangle(cornerRadius: 15).fill(color.opacity(0.8))
            .padding(.horizontal, -16)
            .padding(.vertical,-8)
    }
    
    var inputs: some View {
        Section (header: Text("Basic Info"), footer: Text("* fields are required").padding(16)) {
            TextField("Name *", text: $name)
                .tag(0)
                .focused($isInputActive)
                .background {
                    inputBackgroundCreatorFromTrailing(color: .yellow)
                }.padding(8)
            TextField("Surname *", text: $surname)
                .tag(1)
                .focused($isInputActive)
                .background {
                    inputBackgroundCreatorFromTrailing(color: .green)
                }.padding(8)
            TextField("ID *", text: $id)
                .tag(2)
                .focused($isInputActive)
                .keyboardType(.numberPad)
                .background {
                    inputBackgroundCreatorFromTrailing(color: .red)
                }.padding(8)
            TextField("Phone *", text: $mobile)
                .tag(3)
                .focused($isInputActive)
                .keyboardType(.numberPad)
                .background {
                    inputBackgroundCreatorFromTrailing(color: .mint)
                }.padding(8)
        }
    }
    
    var body: some View {
        NavigationView() {
            ZStack {
                VStack {
                    ScrollView {
                        VStack {
                            inputs
                            DatePicker(selection: $date, label: { Text("Date") }).padding(8).onTapGesture {
                                isInputActive = false
                            }
                        }.padding(16)
                        VStack {
                            //Scans
                            ForEach(0..<scans.count, id: \.self) { i in
                                HStack {
                                    Image(uiImage: scans[i])
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(minWidth: 0, maxWidth: 300, minHeight: 0, maxHeight: 300)
                                        .clipped()
                                        .aspectRatio(1, contentMode: .fit)
                                    Button(action: {
                                        scans.remove(at: i)
                                    }, label: {
                                        Text("Delete")
                                        
                                    })
                                }
                            }
                            HStack {
                                Button {
                                    isCameraShown.toggle()
                                } label: {
                                    Label("Take Photo",systemImage: "camera.circle").background(inputBackgroundCreator(color: .indigo))
                                        .labelStyle(.titleOnly)
                                }.padding(.vertical,16)
                                    .padding(.horizontal,16)
                                    .foregroundColor(Color.black)
                                
                                Button {
                                    isNotePageShown.toggle()
                                } label: {
                                    Label("Add Note",systemImage: "camera.circle").background(inputBackgroundCreator(color: .indigo))
                                        .labelStyle(.titleOnly)
                                }.padding(.vertical,16)
                                    .padding(.horizontal,16)
                                    .foregroundColor(Color.black)
                            }
                        }.navigationTitle("Patient Record")
                            .navigationBarTitleDisplayMode(.inline)
                            .multilineTextAlignment(.center)
                            .padding(16)
                            .onTapGesture {
                                isInputActive = false
                            }
                    }
                    Group {
                        HStack {
                            NavigationLink(destination: BrowseView()) {
                                Text ("Search").foregroundStyle(Color((UIColor(named: "MainTextColor")!)))

                                }
                            Button(action: {
                                if(isClicked) {
                                    name = ""
                                    surname = ""
                                    id = ""
                                    mobile = ""
                                    notes = ""
                                    scans.removeAll(keepingCapacity: false)
                                    clearColor = .clear
                                    showingShareLink = false
                                    isClicked.toggle()
                                } else {
                                    clearColor = .red
                                    isClicked.toggle()
                                }
                            }, label: {
                                Text ("Clear").foregroundStyle(Color((UIColor(named: "MainTextColor")!)))
                            })
                            .background(inputBackgroundCreator(color: clearColor))
                                .foregroundColor(Color.black)
                                .disabled(name.isEmpty && surname.isEmpty && mobile.isEmpty && id.isEmpty)
                                .padding(16)
                            
                            if !showingShareLink {
                                Button(action: {
                                    pdfURL = render(dirName: getDirName(), content: createPDFView() as! PDFViewX)
                                    showingShareLink = true
                                }, label: {
                                    Text ("Create PDF").foregroundStyle(Color((UIColor(named: "MainTextColor")!)))
                                })
                                .background(inputBackgroundCreator(color: clearColor))
                                .foregroundColor(Color.black)
                                .disabled(name.isEmpty && surname.isEmpty && mobile.isEmpty && id.isEmpty)
                                .padding(16)
                            } else {
                                ShareLink("Export PDF", item: pdfURL)
                                    .background(inputBackgroundCreator(color: .green))
                                    .foregroundColor(Color.black)
                                    .padding(16)
                                    .disabled((name.isEmpty || surname.isEmpty || mobile.isEmpty || id.isEmpty) || pdfURL == URL(fileURLWithPath: "null"))
                            }
                        }
                    }.frame(alignment: .bottom)
                        .onTapGesture {
                            isInputActive = false
                        }
                }
                
                
                NoteView(notes: $notes, isShown: $isNotePageShown)
            }.sheet(isPresented: $isCameraShown) {
                DocumentCamera(scans: $scans)
            }
        }.ignoresSafeArea(.all)
    }
}

struct DocumentCamera: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var isPresented
    @Binding var scans: [UIImage]
    
    func makeCoordinator() -> DocCamCoordinator {
        return DocumentCamera.DocCamCoordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller: VNDocumentCameraViewController = VNDocumentCameraViewController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

extension DocumentCamera {
    class DocCamCoordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: DocumentCamera
        init(parent: DocumentCamera) {
            self.parent = parent
        }
        public func documentCameraViewControllerDidCancel(
            _ controller: VNDocumentCameraViewController) {
                self.parent.isPresented.wrappedValue.dismiss()
            }
        
        public func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFailWithError error: Error) {
                self.parent.isPresented.wrappedValue.dismiss()
            }
        
        public func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFinishWith scan: VNDocumentCameraScan) {
                for i in 0 ..< scan.pageCount {
                    self.parent.scans.append(scan.imageOfPage(at: i))
                }
                self.parent.isPresented.wrappedValue.dismiss()
            }
    }
    
}

/*func getDocumentsDirectory() -> URL { // returns your application folder
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

let path = getDocumentsDirectory().absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://")
let url = URL(string: path)!

UIApplication.shared.open(url)*/

struct NewPatientInputView_Previews: PreviewProvider {
    static var previews: some View {
        NewPatientInputView()
    }
}

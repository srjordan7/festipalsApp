//
//  SetsView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/13/23.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestoreSwift

struct SetlistsView: View {
    @State var selectedTab: Tabs = .setlists
    @State var event: Event
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var uiImageSelected = UIImage()
    @State private var showSetlistPhotoSheet = false
    @FirestoreQuery(collectionPath: "users/\(Auth.auth().currentUser?.uid ?? "")/events") var setlistPhotos: [SetlistPhoto]
    var previewRunning = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("setlist")
                    .font(.system(size: 26))
                SetlistPhotosScrollView(photos: setlistPhotos, event: event)
                Spacer()
                EventTabBar(selectedTab: $selectedTab, event: event)
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: AllEventsView()) {
                        Text("events")
                            .foregroundColor(.green)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                        Image(systemName: "plus")
                            .foregroundColor(.green)
                    }
                    .tint(.green)
                    .onChange(of: selectedPhoto) { newValue in
                        Task {
                            do {
                                if let data = try await newValue?.loadTransferable(type: Data.self) {
                                    if let selectedPhoto = UIImage(data: data) {
                                        uiImageSelected = selectedPhoto
                                        print("successfully selected image")
                                    }
                                    showSetlistPhotoSheet.toggle()
                                }
                            } catch {
                                print("selecting image failed \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
            .background(Color("BackgroundColor")
                .ignoresSafeArea()) // background color
        }
        .sheet(isPresented: $showSetlistPhotoSheet) {
            SetlistPhotoView(uiImage: uiImageSelected, event: event)
        }
        .onAppear {
            if !previewRunning {
                $setlistPhotos.path = "users/\(Auth.auth().currentUser?.uid ?? "")/events/\(event.id ?? "")/setlistPhotos"
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct SetsView_Previews: PreviewProvider {
    static var previews: some View {
        SetlistsView(event: Event(), previewRunning: true)
    }
}

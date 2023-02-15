//
//  VenueView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/14/23.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestoreSwift

struct VenueView: View {
    @State var selectedTab: Tabs = .venue
    @State var event: Event
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var uiImageSelected = UIImage()
    @State private var showVenuePhotoSheet = false
    @FirestoreQuery(collectionPath: "users/\(Auth.auth().currentUser?.uid ?? "")/events") var venuePhotos: [VenuePhoto]
    var previewRunning = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("venue map")
                    .font(.custom("Righteous-Regular", size: 30))
                    .padding(25)
                    .foregroundColor(Color("MainColor"))
                
                ZStack {
                    Text("add a map!")
                        .font(.custom("SofiaSans-Regular", size: 18))
                    
                    VenuePhotosScrollView(photos: venuePhotos, event: event)
                }
                
                Spacer()
                
                EventTabBar(selectedTab: $selectedTab, event: event)
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: AllEventsView()) {
                        Text("events")
                            .font(.custom("SofiaSans-Regular", size: 18))
                            .foregroundColor(Color("MainColor"))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                        Image(systemName: "plus")
                            .foregroundColor(Color("MainColor"))
                    }
                    .tint(Color("MainColor"))
                    .onChange(of: selectedPhoto) { newValue in
                        Task {
                            do {
                                if let data = try await newValue?.loadTransferable(type: Data.self) {
                                    if let selectedPhoto = UIImage(data: data) {
                                        uiImageSelected = selectedPhoto
                                        print("successfully selected image")
                                    }
                                    showVenuePhotoSheet.toggle()
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
        .sheet(isPresented: $showVenuePhotoSheet) {
            VenuePhotoView(uiImage: uiImageSelected, event: event)
        }
        .onAppear {
            if !previewRunning {
                $venuePhotos.path = "users/\(Auth.auth().currentUser?.uid ?? "")/events/\(event.id ?? "")/venuePhotos"
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct VenueView_Previews: PreviewProvider {
    static var previews: some View {
        VenueView(event: Event(), previewRunning: true)
    }
}

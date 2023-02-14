//
//  SetsView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/13/23.
//

import SwiftUI
import PhotosUI

struct SetsView: View {
    @State var selectedTab: Tabs = .sets
    @State var event: Event
    @State private var selectedPhoto: PhotosPickerItem?
    
    var body: some View {
        NavigationView {
            VStack {
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
                                    if let uiImage = UIImage(data: data) {
                                        print("successfully selected imgage")
                                    }
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
        .navigationBarBackButtonHidden()
    }
}

struct SetsView_Previews: PreviewProvider {
    static var previews: some View {
        SetsView(event: Event())
    }
}

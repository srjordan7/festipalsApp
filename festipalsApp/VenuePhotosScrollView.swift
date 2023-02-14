//
//  VenuePhotosScrollView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/14/23.
//

import SwiftUI

struct VenuePhotosScrollView: View {
    var photos: [VenuePhoto]
    var event: Event
    @State var showDeleteOption = false
    @EnvironmentObject var eventVM: NewEventViewModel
    @State var selectedVenueId = ""
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach(photos) { photo in
                    let imageURL = URL(string: photo.imageURLString) ?? URL(string: "")
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                selectedVenueId = photo.id ?? ""
                                showDeleteOption.toggle()
                            }
                        Text("meet here at end of day:")
                        Text("\(photo.eodLocation)")
                    } placeholder: {
                        ProgressView()
                    }
                    .padding()
                }
            }
            .actionSheet(isPresented: $showDeleteOption) {
                .init(title: Text("delete map"), message: Text("are you sure you want to delete this map?"), buttons: [
                    .destructive(Text("yes"), action: {
                        Task {
                            await eventVM.deleteVenueImage(event: event, venue: selectedVenueId)
                        }
                    }),
                    .cancel(Text("nevermind"))
                ])
            }
        }
    }
}

struct VenuePhotosScrollView_Previews: PreviewProvider {
    static var previews: some View {
        VenuePhotosScrollView(photos: [VenuePhoto()], event: Event())
    }
}

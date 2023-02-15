//
//  SetlistPhotosScrollView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/14/23.
//

import SwiftUI

struct SetlistPhotosScrollView: View {
    var photos: [SetlistPhoto]
    var event: Event
    @State var showDeleteOption = false
    @EnvironmentObject var eventVM: NewEventViewModel
    @State var selectedSetlistId = ""
    
    var body: some View {
        let sortedPhotos = photos.sorted { $0.description < $1.description }
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach(sortedPhotos) { photo in
                    let imageURL = URL(string: photo.imageURLString) ?? URL(string: "")
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                selectedSetlistId = photo.id ?? ""
                                showDeleteOption.toggle()
                            }
                        if photo.description == "0" {
                            Text("all days")
                                .font(.custom("SofiaSans-Regular", size: 18))
                        } else {
                            Text("day \(photo.description)")
                                .font(.custom("SofiaSans-Regular", size: 18))
                        }
                    } placeholder: {
                        Text("add a setlist!")
                            .font(.custom("SofiaSans-Regular", size: 18))
                    }
                    .padding()
                }
            }
            .actionSheet(isPresented: $showDeleteOption) {
                .init(title: Text("delete setlist"), message: Text("are you sure you want to delete this setlist?"), buttons: [
                    .destructive(Text("yes"), action: {
                        Task {
                            await eventVM.deleteSetlistImage(event: event, setlist: selectedSetlistId)
                        }
                    }),
                    .cancel(Text("nevermind"))
                ])
            }
        }
        .background(Color("BackgroundColor")
            .ignoresSafeArea()) // background color
    }
}

struct SetlistPhotosScrollView_Previews: PreviewProvider {
    static var previews: some View {
        SetlistPhotosScrollView(photos: [SetlistPhoto()], event: Event())
    }
}

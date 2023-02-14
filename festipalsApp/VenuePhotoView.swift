//
//  VenuePhotoView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/14/23.
//

import SwiftUI

struct VenuePhotoView: View {
    @EnvironmentObject var eventVM: NewEventViewModel
    @State private var venuePhoto = VenuePhoto()
    var uiImage: UIImage
    @Environment(\.dismiss) private var dismiss
    var event: Event
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                ZStack {
                    Text("please cancel and select again")
                        .font(.system(size: 13))
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
                TextField("end of day meeting spot", text: $venuePhoto.eodLocation)
                    .padding(.all, 25)
                Spacer()
            }
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button("cancel") {
                        dismiss()
                    }
                    .foregroundColor(.green)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("save") {
                        Task {
                            let success = await eventVM.saveVenueImage(event: event, venuePhoto: venuePhoto, image: uiImage)
                            if success {
                                dismiss()
                            }
                        }
                    }
                    .foregroundColor(.green)
                }
            }
            .background(Color("BackgroundColor")
                .ignoresSafeArea()) // background color
        }
    }
}

struct VenuePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        VenuePhotoView(uiImage: UIImage(), event: Event())
            .environmentObject(NewEventViewModel())
    }
}

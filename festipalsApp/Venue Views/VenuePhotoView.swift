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
                        .font(.custom("SofiaSans-Regular", size: 13))
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
                Text("where are we meeting?")
                    .font(.custom("Righteous-Regular", size: 30))
                    .foregroundColor(Color("MainColor"))
                TextField("end of day", text: $venuePhoto.eodLocation)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .font(.custom("SofiaSans-Regular", size: 18))
                    .padding(5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
                    .padding()
                
                Spacer()
            }
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button("cancel") {
                        dismiss()
                    }
                    .font(.custom("SofiaSans-Regular", size: 18))
                    .foregroundColor(Color("MainColor"))
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
                    .font(.custom("SofiaSans-Regular", size: 18))
                    .foregroundColor(Color("MainColor"))
                }
            }
            .background(Color("BackgroundColor")
                .ignoresSafeArea()) // background color
        }
        .navigationBarBackButtonHidden()
    }
}

struct VenuePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        VenuePhotoView(uiImage: UIImage(), event: Event())
            .environmentObject(NewEventViewModel())
    }
}

//
//  SetlistPhotoView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/14/23.
//

import SwiftUI

struct SetlistPhotoView: View {
    @EnvironmentObject var eventVM: NewEventViewModel
    @State private var setlistPhoto = SetlistPhoto()
    var uiImage: UIImage
    @Environment(\.dismiss) private var dismiss
    var event: Event
    var setDays = ["0", "1", "2", "3", "4", "5", "6", "7"]
    
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
                Text("pick day")
                    .font(.custom("Righteous-Regular", size: 30))
                    .foregroundColor(Color("MainColor"))
                Picker("select day", selection: $setlistPhoto.description) {
                    ForEach(setDays, id: \.self) {
                        if $0 == "0" {
                            Text("all")
                                .font(.custom("SofiaSans-Regular", size: 18))
                        } else {
                            Text($0)
                                .font(.custom("SofiaSans-Regular", size: 18))
                        }
                    }
                }
                .pickerStyle(.inline)
                .frame(height: 85)
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
                            let success = await eventVM.saveSetlistImage(event: event, setlistPhoto: setlistPhoto, image: uiImage)
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

struct SetlistPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        SetlistPhotoView(uiImage: UIImage(), event: Event())
            .environmentObject(NewEventViewModel())
    }
}

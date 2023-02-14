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
                        .font(.system(size: 13))
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
                Text("pick day")
                Picker("select day", selection: $setlistPhoto.description) {
                    ForEach(setDays, id: \.self) {
                        if $0 == "0" {
                            Text("all")
                        } else {
                            Text($0)
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
                    .foregroundColor(.green)
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
                    .foregroundColor(.green)
                }
            }
            .background(Color("BackgroundColor")
                .ignoresSafeArea()) // background color
        }
    }
}

struct SetlistPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        SetlistPhotoView(uiImage: UIImage(), event: Event())
            .environmentObject(NewEventViewModel())
    }
}

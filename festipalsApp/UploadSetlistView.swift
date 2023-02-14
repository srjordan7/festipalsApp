//
//  UploadSetlistView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/13/23.
//

import SwiftUI

struct UploadSetlistView: View {
    var uiImage: UIImage
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var eventVM: NewEventViewModel
    @State var event: Event
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                Spacer()
            }
            .background(Color("BackgroundColor")
                .ignoresSafeArea()) // background color
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("cancel")
                    }

                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            let url = await eventVM.saveSetlistImage(event: event, image: uiImage)
                            event.setlistUrl = url
                            let success = await eventVM.saveEvent(event: event)
                            if success {
                                dismiss()
                            }
                        }
                    } label: {
                        Text("save")
                    }
                }
            }
        }
    }
}

struct UploadSetlistView_Previews: PreviewProvider {
    static var previews: some View {
        UploadSetlistView(uiImage: UIImage(), event: Event())
            .environmentObject(NewEventViewModel())
    }
}

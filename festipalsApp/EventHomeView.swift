//
//  EventHomeView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/10/23.
//

import SwiftUI

struct EventHomeView: View {
    @State var event: Event
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("get ready for")
                    Text("\(event.eventName)!")
                }
            }
            .background(Color("BackgroundColor")
                .ignoresSafeArea()) // background color
            .toolbar {
                // back to all events button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("all events")
                            .foregroundColor(.green)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: NewEventView(event: event)) {
                        Text("update event")
                            .foregroundColor(.green)             
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct EventHomeView_Previews: PreviewProvider {
    static var previews: some View {
        EventHomeView(event: Event())
    }
}

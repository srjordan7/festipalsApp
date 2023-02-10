//
//  NewEventView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/10/23.
//

import SwiftUI
import Firebase

struct NewEventView: View {
    @State var event: Event
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var eventVM: NewEventViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("plan a new event")
                    .font(.system(size: 24))
                    .padding(.bottom)
                VStack {
                    // event name entry
                    TextField("event name", text: $event.eventName)
                        .font(.system(size: 26))
                        .textInputAutocapitalization(.never)
                    // venue name entry
                    TextField("venue", text: $event.venue)
                        .textInputAutocapitalization(.never)
                    // multi day selection
                    Toggle("multi day?", isOn: $event.multiDay)
                    // if not multi day, select date
                    if !event.multiDay {
                        DatePicker("date", selection: $event.firstDay, displayedComponents: [.date])
                        DatePicker("time", selection: $event.firstDay, displayedComponents: [.hourAndMinute])
                    // if multi day, select dates
                    } else {
                        DatePicker("first day", selection: $event.firstDay, displayedComponents: [.date])
                        DatePicker("time", selection: $event.firstDay, displayedComponents: [.hourAndMinute])
                        DatePicker("last day", selection: $event.lastDay, displayedComponents: [.date])
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            .background(Color("BackgroundColor")
                .ignoresSafeArea()) // background color
            .toolbar {
                // cancel button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("cancel")
                            .foregroundColor(.green)
                    }

                }
                // save button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            let success = await eventVM.saveEvent(event: event)
                            if success {
                                dismiss()
                            } else {
                                print("error saving event")
                            }
                        }
                    } label: {
                        Text("save")
                            .foregroundColor(.green)
                    }

                }
            }
        }
        
    }
}

struct NewEventView_Previews: PreviewProvider {
    static var previews: some View {
        NewEventView(event: Event())
            .environmentObject(NewEventViewModel())
    }
}

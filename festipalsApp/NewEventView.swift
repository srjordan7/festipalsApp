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
                VStack {
                    Text("where to?")
                        .font(.custom("Righteous-Regular", size: 30))
                        .foregroundColor(Color("MainColor"))
                    
                    Group {
                        // event name entry
                        TextField("event name", text: $event.eventName)
                            .font(.custom("SofiaSans-Regular", size: 26))
                            .textInputAutocapitalization(.never)
                        
                        // venue name entry
                        TextField("venue", text: $event.venue)
                            .textInputAutocapitalization(.never)
                    }
                    .padding(5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
                    
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
                .font(.custom("SofiaSans-Regular", size: 18))
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
                            .font(.custom("SofiaSans-Regular", size: 18))
                            .foregroundColor(Color("MainColor"))
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
                            .font(.custom("SofiaSans-Regular", size: 18))
                            .foregroundColor(Color("MainColor"))
                    }

                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct NewEventView_Previews: PreviewProvider {
    static var previews: some View {
        NewEventView(event: Event())
            .environmentObject(NewEventViewModel())
    }
}

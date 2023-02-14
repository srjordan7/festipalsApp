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
    var today = Date()
    
    @State var selectedTab: Tabs = .home
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    VStack {
                        Text("get ready for")
                        Text("\(event.eventName)")
                        Text("at \(event.venue)!")
                    }
                    Spacer()
                    VStack {
                        let toDate = stringToDate()
                        let daysLeft = countdown(toDate: toDate)
                        Text("\(daysLeft)")
                        Text("days left")
                    }
                    Spacer()
                    EventTabBar(selectedTab: $selectedTab, event: event)
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
                        Text("events")
                            .foregroundColor(.green)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: NewEventView(event: event)) {
                        Image(systemName: "pencil")
                            .foregroundColor(.green)             
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    // convert string to date
    func stringToDate() -> Date {
        let string = event.firstDayString
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, y"
        guard let eventDate = dateFormatter.date(from: string) else { return event.firstDay }
        return eventDate
    }
    
    // countdown to event
    func countdown(toDate: Date) -> Int {
        let today = Date()

        let diffs = Calendar.current.dateComponents([.day], from: today, to: toDate)

        return diffs.day!
    }
}

struct EventHomeView_Previews: PreviewProvider {
    static var previews: some View {
        EventHomeView(event: Event())
    }
}

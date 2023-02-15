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
                            .font(.custom("Righteous-Regular", size: 30))
                        Text("at \(event.venue)!")
                    }
                    .font(.custom("SofiaSans-Regular", size: 18))
                    .padding(.top, 25)
                    
                    VStack {
                        let toDate = stringToDate()
                        let daysLeft = countdown(toDate: toDate)
                        if daysLeft == 0 {
                            Text("today")
                                .font(.custom("Righteous-Regular", size: 75))
                                .foregroundColor(Color("MainColor"))
                        } else if daysLeft == 1 {
                            Text("tomorrow")
                                .font(.custom("Righteous-Regular", size: 75))
                                .foregroundColor(Color("MainColor"))
                        } else {
                            Text("\(daysLeft)")
                                .font(.custom("Righteous-Regular", size: 75))
                                .foregroundColor(Color("MainColor"))
                            Text("days left")
                                .font(.custom("SofiaSans-Regular", size: 18))
                        }
                        
                    }
                    .padding(.top, 175)
                    
                    Spacer()
                    
                    EventTabBar(selectedTab: $selectedTab, event: event)
                }
            }
            .background(Color("BackgroundColor")
                .ignoresSafeArea()) // background color
            .toolbar {
                // back to all events button
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: AllEventsView()) {
                        Text("events")
                            .font(.custom("SofiaSans-Regular", size: 18))
                            .foregroundColor(Color("MainColor"))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: NewEventView(event: event)) {
                        Image(systemName: "pencil")
                            .foregroundColor(Color("MainColor"))             
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

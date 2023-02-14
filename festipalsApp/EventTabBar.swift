//
//  EventTabBar.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/13/23.
//

import SwiftUI

enum Tabs: Int {
    case home = 0
    case setlists = 1
    case venue = 2
    case group = 3
}

struct EventTabBar: View {
    @Binding var selectedTab: Tabs
    @State var event: Event
    
    var body: some View {
        HStack {
            Spacer()
            NavigationLink(destination: EventHomeView(event: event)) {
                Image(systemName: "info.circle")
                    .font(.system(size: 24))
                    .foregroundColor(selectedTab == .home ? .black : .green)
            }

            Spacer()
            NavigationLink(destination: SetlistsView(event: event)) {
                Image(systemName: "hifispeaker.2")
                    .font(.system(size: 24))
                    .foregroundColor(selectedTab == .setlists ? .black : .green)
            }
            
            Spacer()
            NavigationLink(destination: VenueView(event: event)) {
                Image(systemName: "map")
                    .font(.system(size: 24))
                    .foregroundColor(selectedTab == .venue ? .black : .green)
            }
            
            Spacer()
            NavigationLink(destination: GroupView(event: event)) {
                Image(systemName: "person.2")
                    .font(.system(size: 24))
                    .foregroundColor(selectedTab == .group ? .black : .green)
            }
            
            Spacer()
        }
    }
}

struct EventTabBar_Previews: PreviewProvider {
    static var previews: some View {
        EventTabBar(selectedTab: .constant(.home), event: Event())
    }
}

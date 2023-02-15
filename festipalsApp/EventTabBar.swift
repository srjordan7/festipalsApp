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
    @EnvironmentObject var eventVM: NewEventViewModel
    @State var showDeleteOption = false
    
    var body: some View {
        HStack {
            Group {
                Spacer()
                NavigationLink(destination: SetlistsView(event: event)) {
                    Image(systemName: "hifispeaker.2")
                        .font(.system(size: 24))
                        .foregroundColor(selectedTab == .setlists ? .green : Color("MainColor"))
                }
            }
            
            Group {
                Spacer()
                NavigationLink(destination: VenueView(event: event)) {
                    Image(systemName: "map")
                        .font(.system(size: 24))
                        .foregroundColor(selectedTab == .venue ? .green : Color("MainColor"))
                }
            }
            
            Group {
                Spacer()
                NavigationLink(destination: EventHomeView(event: event)) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 24))
                        .foregroundColor(selectedTab == .home ? .green : Color("MainColor"))
                }
            }
            
            Group {
                Spacer()
                NavigationLink(destination: GroupView(event: event)) {
                    Image(systemName: "person.2")
                        .font(.system(size: 24))
                        .foregroundColor(selectedTab == .group ? .green : Color("MainColor"))
                }
            }
            
            Group {
                Spacer()
                Button {
                    showDeleteOption.toggle()
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 24))
                        .foregroundColor(Color("MainColor"))
                }
            }
            
            Spacer()
        }
        .actionSheet(isPresented: $showDeleteOption) {
            .init(title: Text("delete event"), message: Text("are you sure you want to delete this event?"), buttons: [
                .destructive(Text("yes"), action: {
                    Task {
                        await eventVM.deleteEvent(event: event)
                    }
                }),
                .cancel(Text("nevermind"))
            ])
        }
    }
}

struct EventTabBar_Previews: PreviewProvider {
    static var previews: some View {
        EventTabBar(selectedTab: .constant(.home), event: Event())
            .environmentObject(NewEventViewModel())
    }
}

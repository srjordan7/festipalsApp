//
//  SetsView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/13/23.
//

import SwiftUI

struct SetsView: View {
    @State var selectedTab: Tabs = .sets
    @State var event: Event
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        EventTabBar(selectedTab: $selectedTab, event: event)
    }
}

struct SetsView_Previews: PreviewProvider {
    static var previews: some View {
        SetsView(event: Event())
    }
}

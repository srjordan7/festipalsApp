//
//  EventHomeView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/10/23.
//

import SwiftUI

struct EventHomeView: View {
    @State var event: UserEvent
    
    var body: some View {
        NavigationView {
            VStack {
                Text("get ready for")
                Text("\(event.eventName)!")
            }
        }
    }
}

struct EventHomeView_Previews: PreviewProvider {
    static var previews: some View {
        EventHomeView(event: UserEvent(documentId: "", data: [:]))
    }
}

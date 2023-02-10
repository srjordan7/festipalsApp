//
//  AllEventsView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/9/23.
//

import SwiftUI

struct AllEventsView: View {
    @State var showLogOutOptions = false
    
    var body: some View {
        NavigationView {
            VStack {
                // navigation bar
                VStack {
                    HStack {
                        // current account picture
                        Image(systemName: "person")
                        Spacer()
                        // log out button
                        Button {
                            showLogOutOptions.toggle()
                        } label: {
                            Text("log out")
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .actionSheet(isPresented: $showLogOutOptions) {
                        .init(title: Text("log out"), message: Text("are you sure you want to log out?"), buttons: [
                            .destructive(Text("yes"), action: {
                                // ADD LOG OUT FUNCTIONALITY
                            }),
                            .cancel(Text("nevermind"))
                        ])
                    }
                    
                    Text("hi, name!")
                    Text("upcoming events")
                        .font(.system(size: 26))
                }
                .padding(.bottom, 30)

                // list of events
                ScrollView {
                    ForEach(0..<5, id: \.self) { num in
                        // single event container
                        HStack {
                            VStack {
                                Text("event name")
                                    .font(.system(size: 22))
                                Text("venue")
                                Text("# days left")
                            }
                        }
                        Divider()
                            .padding(.vertical, 40)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 50)
            }
            .overlay(
                // new event button
                Button {
                    
                } label: {
                    HStack {
                        Spacer()
                        Text("+ new event")
                        Spacer()
                    }
                    .foregroundColor(.white) // button text color
                    .padding(.vertical)
                    .background(Color.green) // button color
                    .cornerRadius(42)
                    .padding(.horizontal)
                    .shadow(radius: 5)
                }, alignment: .bottom)
            .navigationBarHidden(true)
        }
    }
}

struct AllEventsView_Previews: PreviewProvider {
    static var previews: some View {
        AllEventsView()
    }
}

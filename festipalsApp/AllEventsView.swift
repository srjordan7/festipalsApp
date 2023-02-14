//
//  AllEventsView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/9/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct AllEventsView: View {
    @FirestoreQuery(collectionPath: "users/\(Auth.auth().currentUser?.uid ?? "")/events") var events: [Event]
    @State var showLogOutOptions = false
    
    @ObservedObject private var currentUserVM = CurrentUserViewModel()
    @ObservedObject private var eventsVM = NewEventViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // navigation bar
                VStack {
                    HStack {
                        // current account picture
                        AsyncImage(url: URL(string: currentUserVM.user?.profileImageUrl ?? "")) { returnedImage in
                            returnedImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                        } placeholder: {
                            Image(systemName: "person")
                        }

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
                    // log out confirmation sheet
                    .actionSheet(isPresented: $showLogOutOptions) {
                        .init(title: Text("log out"), message: Text("are you sure you want to log out?"), buttons: [
                            .destructive(Text("yes"), action: {
                                currentUserVM.signOut()
                            }),
                            .cancel(Text("nevermind"))
                        ])
                    }
                    .fullScreenCover(isPresented: $currentUserVM.currentlyLoggedOut, onDismiss: nil) {
                        LogInView(completeLoginProcess: {
                            self.currentUserVM.currentlyLoggedOut = false
                            self.currentUserVM.fetchCurrentUser()
                        })
                    }
                    
                    // personalized heading
                    Text("hi \(currentUserVM.user?.name ?? "")!")
                    Text("upcoming events")
                        .font(.system(size: 26))
                }
                .padding(.bottom, 30)

                // list of events
                ScrollView {
                    ForEach(eventsVM.events) { event in
                        // single event container
                        NavigationLink(destination: EventHomeView(event: event)) {
                            VStack {
                                Text(event.eventName)
                                    .font(.system(size: 22))
                                if !event.multiDay {
                                    Text(event.firstDayString)
                                } else {
                                    Text("\(event.firstDayString) - \(event.lastDayString)")
                                }
                            }
                        }
                        .foregroundColor(.white)
                        Divider()
                            .padding(.vertical, 40)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 50)
            }
            .overlay(
                newEventButton, alignment: .bottom)
            .navigationBarHidden(true)
            .background(Color("BackgroundColor")
                .ignoresSafeArea()) // background color
        }
        .navigationBarBackButtonHidden()
    }
    
    @State var showNewEventScreen = false
    
    // new event button
    private var newEventButton: some View {
        Button {
            showNewEventScreen.toggle()
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
        }
        .fullScreenCover(isPresented: $showNewEventScreen) {
            NewEventView(event: Event())
        }
    }
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, y"
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
    
    init() {
        eventsVM.getEventData()
    }
}

struct AllEventsView_Previews: PreviewProvider {
    static var previews: some View {
        AllEventsView()
    }
}

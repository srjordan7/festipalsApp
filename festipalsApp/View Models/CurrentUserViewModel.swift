//
//  CurrentUserViewModel.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/10/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class CurrentUserViewModel: ObservableObject {
    
    @Published var errorMsg = ""
    @Published var user: User?
    
    init() {
        DispatchQueue.main.async {
            self.currentlyLoggedOut = Auth.auth().currentUser?.uid == nil
        }
        
        fetchCurrentUser()
    }
    
    // get current user data
    func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.errorMsg = "could not find user data"
            return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMsg = "failed to fetch current user: \(error.localizedDescription)"
                print("failed to fetch current user: \(error.localizedDescription)")
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMsg = "no data found"
                return }
            
            // build User from data
            self.user = .init(data: data)
        }
    }
    
    @Published var currentlyLoggedOut = false
    
    func signOut() {
        currentlyLoggedOut.toggle()
        try? Auth.auth().signOut()
    }
    
}

//
//  ProfileSetupView.swift
//  TwiX
//
//  Created by Alexander on 20.12.2024.
//

import SwiftUI

struct ProfileSetupView: View {
    @State private var name: String = ""
    @State private var userName: String = ""
    @State private var avatarUrl: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Profile Setup")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 40)
                
                // TextField for Name
                TextField("Name", text: $name)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                // TextField for UserName
                TextField("UserName", text: $userName)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                // TextField for AvatarUrl
                TextField("Avatar URL", text: $avatarUrl)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                // Save Button
                Button(action: saveProfile) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.top, 20)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
    
    // Save profile action
    func saveProfile() {
        print("Profile saved!")
    }
}

struct ProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupView()
    }
}

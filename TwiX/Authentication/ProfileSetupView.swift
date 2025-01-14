import SwiftUI
import FirebaseFirestore

struct ProfileSetupView: View {
    @State private var name: String = ""
    @State private var userName: String = ""
    @State private var userBio: String = ""
    @State private var avatarUrl: String = ""
    
    @State private var isDataInvalid = false
    @State private var isUsernameTaken = false
    
    var onSuccess: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Profile Setup")
                .font(Font.custom(Fonts.Urbanist_Bold, size: Constants.Header.FontSizes.title))
                .foregroundStyle(.text)
                .padding(.top, 40)
            
            // TextField for Name
            TextField("Name", text: $name)
                .font(Font.custom(Fonts.Urbanist_Regular, size: Constants.Login.FontSizes.fieldLabel))
                .foregroundStyle(.text)
                .padding()
                .background(Color.textFieldsDarker)
                .cornerRadius(10)
                .padding(.horizontal)
            
            // TextField for UserName
            TextField("UserName", text: $userName)
                .padding()
                .font(Font.custom(Fonts.Urbanist_Regular, size: Constants.Login.FontSizes.fieldLabel))
                .foregroundStyle(.text)
                .background(Color.textFieldsDarker)
                .cornerRadius(10)
                .padding(.horizontal)
                .onChange(of: userName) { newValue in
                    checkUsernameAvailability(username: newValue)
                }
            
            // TextField for Bio (Status)
            TextField("Bio (Status)", text: $userBio)
                .padding()
                .font(Font.custom(Fonts.Urbanist_Regular, size: Constants.Login.FontSizes.fieldLabel))
                .foregroundStyle(.text)
                .background(Color.textFieldsDarker)
                .cornerRadius(10)
                .padding(.horizontal)
            
            // TextField for AvatarUrl
            TextField("Avatar URL", text: $avatarUrl)
                .padding()
                .font(Font.custom(Fonts.Urbanist_Regular, size: Constants.Login.FontSizes.fieldLabel))
                .foregroundStyle(.text)
                .background(Color.textFieldsDarker)
                .cornerRadius(10)
                .padding(.horizontal)
            
            Button(action: saveProfile) {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.text)
                    .frame(width: 200, height: 50)
                    .background(Color.orangeButton)
                    .cornerRadius(25)
                    .padding(.top, 20)
            }
            .disabled(isUsernameTaken)
            
            if isUsernameTaken {
                Text("Username is already taken")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.background)
    }
    
    func checkUsernameAvailability(username: String) {
        Firestore.firestore().collection("users").whereField("authorUsername", isEqualTo: username).getDocuments { snapshot, error in
            if let error = error {
                print("Error checking username: \(error)")
                return
            }
            
            if let snapshot = snapshot, !snapshot.isEmpty {
                isUsernameTaken = true
            } else {
                isUsernameTaken = false
            }
        }
    }
    
    func saveProfile() {
        if isDataInvalid {
            AlertHelper.showAlert(title: "Error", message: "Invalid Fields")
        } else if isUsernameTaken {
            AlertHelper.showAlert(title: "Error", message: "Username is already taken")
        } else {
            guard let currUser = UserSessionManager.shared.currentUser else {
                AlertHelper.showAlert(title: "User not logged in", message: "User not logged in")
                return
            }
            UserSessionManager.shared.initUserToDatabase(uid: currUser.uid, authorName: name, authorUsername: userName, authorBio: userBio, authorAvatarURL: URL(string: avatarUrl))
            print("Profile updated!")
            onSuccess()
        }
    }
}

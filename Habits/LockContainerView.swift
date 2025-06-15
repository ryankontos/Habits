//
//  LockContainerView.swift
//  Habits
//
//  Created by Ryan on 28/11/2023.
//


import SwiftUI
import LocalAuthentication

struct LockContainerView: View {
    
    @State private var isUnlocked = true
    
    var body: some View {
        
        ContentView()
           
            .overlay {
                
                if !isUnlocked {
                    LockedView { result in
                        if result {
                            
                            DispatchQueue.main.async {
                                
                                withAnimation {
                                    isUnlocked = true
                                }
                                
                            }
                           
                        }
                    }
                    
                }
                
                
            }
        
          
        }
    
}

#Preview {
    LockContainerView()
}

struct LockedView: View {
    var onAuthenticationComplete: (Bool) -> Void

    var body: some View {
        
        GeometryReader { proxy in
            
            ZStack {
                
                Rectangle()
                    .foregroundStyle(.ultraThinMaterial)
                
                VStack {
                    Text("Locked View")
                        .font(.largeTitle)
                        .padding()
                    
                    Button("Unlock") {
                        authenticateUser()
                    }
                }
                
            }
            .ignoresSafeArea(.all, edges: .all)
            .frame(width: proxy.size.width, height: proxy.size.height)
            .onAppear {
                
                authenticateUser()
            }
            
            
        }
    }

    func authenticateUser() {
        let context = LAContext()

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Unlock to access the content") { success, error in
                if success {
                   
                        
                            onAuthenticationComplete(true)
                        
                    
                } else {
                    print("Authentication failed: \(error?.localizedDescription ?? "Unknown error")")
                    onAuthenticationComplete(false)
                }
            }
        } else {
            print("Biometric authentication not available")
            onAuthenticationComplete(false)
        }
    }
}

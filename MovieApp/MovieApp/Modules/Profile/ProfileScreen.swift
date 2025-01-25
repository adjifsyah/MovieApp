//
//  ProfileScreen.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 22/01/25.
//

import SwiftUI

struct ProfileScreen: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: LayoutConstants.Spacing.large) {
                        HStack {
                            spacer
                            VStack(spacing: 14) {
                                Image("profile")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                
                                Text("Adji Firmansyah")
                                    .font(.system(size: 20, weight: .bold))
                            }
                            spacer
                        }
                        
                        VStack(alignment: .leading, spacing: 14) {
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Domisili")
                                        .font(.system(size: 14, weight: .bold))
                                    Text("Jakarta Timur")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                spacer
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Pendidikan Terakhir")
                                    .font(.system(size: 14, weight: .bold))
                                
                                Text("S1 Teknik Informatika - Universitas Indraprasta PGRI Jakarta")
                                    .font(.system(size: 14, weight: .regular))
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Keahlian")
                                    .font(.system(size: 14, weight: .bold))
                                
                                
                                HStack(spacing: 2) {
                                    Text("- Pemrograman:")
                                        .font(.system(size: 14, weight: .semibold))
                                    
                                    Text("Swift, SwiftUI")
                                        .font(.system(size: 14))
                                }
                                
                                HStack(spacing: 2) {
                                    Text("- Design Patterns:")
                                        .font(.system(size: 14, weight: .semibold))
                                    
                                    Text("MVVM, VIPER")
                                        .font(.system(size: 14))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, LayoutConstants.verticalPadding)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("Profile")
                    
                }
            }
        }
    }
    
    var spacer: some View {
        Spacer()
    }
}

#Preview {
    ProfileScreen()
}

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

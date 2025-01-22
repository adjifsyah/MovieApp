//
//  MovieDetailScreen.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 22/01/25.
//

import SwiftUI
import Kingfisher

struct MovieDetailScreen: View {
    @StateObject var viewModel: MovieDetailVM
    
    var body: some View {
        ZStack(alignment: .top) {
            KFImage("https://image.tmdb.org/t/p/w500/rDa3SfEijeRNCWtHQZCwfbGxYvR.jpg".toImageURL)
                .resizable()
                .scaledToFill()
                .frame(height: viewModel.screenSize.height / 2)
                .clipped()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        KFImage("https://image.tmdb.org/t/p/w500/rDa3SfEijeRNCWtHQZCwfbGxYvR.jpg".toImageURL)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        VStack(alignment: .leading, spacing: 4) {
                            // "viewModel.movieDetail.title
                            Text("Clash of Royal")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.black)
                            
                            Text("viewModel.movieDetail.overview")
                                .font(.system(size: 10))
                                .foregroundStyle(.black)
                        }
                        
                        Spacer()
                    }
//                    .padding(.horizontal, LayoutConstants.sidePadding)
                    .frame(width: viewModel.screenSize.width)
                    
                    .background(
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.clear, Color.white]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: viewModel.screenSize.width, height: 200) // Sesuaikan ukuran
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    )
                    
                    Text("Overview")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.black)
                }
                .padding(.top, viewModel.screenSize.height / 3)
                
                .toolbar(.hidden, for: .tabBar)
            }
//            .ignoresSafeArea(edges: .top)
            
        }
        .background(
            GeometryReader { proxy in
                Color.white
                    .onAppear {
                        viewModel.screenSize = proxy.size
                    }
                    .onChange(of: proxy.size) { newValue in
                        viewModel.screenSize = newValue
                    }
            }
        )
        .preferredColorScheme(.light)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MovieDetailScreen(
        viewModel: MovieDetailVM(
            movieID: 939243,
            repository: MovieRepository.sharedInstance(
                RemoteDataSource(
                    configuration: .shared,
                    client: AlamofireClients()
                )
            )
        )
    )
}

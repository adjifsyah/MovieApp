//
//  HomeScreen.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 21/01/25.
//

import SwiftUI
import Kingfisher

struct HomeScreen: View {
    @StateObject private var viewModel: HomeVM

    init(viewModel: HomeVM) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: LayoutConstants.Spacing.medium) {
                    ForEach(viewModel.movies, id: \.id) { movie in
                        movieRow(movie)
                    }
                }
                .padding(.vertical, LayoutConstants.verticalPadding)
                .padding(.horizontal, LayoutConstants.sidePadding)
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .onAppear {
                                viewModel.screenSize = proxy.size
                            }
                            .onChange(of: proxy.size) { size in
                                viewModel.screenSize = size
                            }
                    }
                        .overlay(
                            Text("Saat ini film tidak tersedia.")
                                .font(.system(size: 14))
                                .opacity(viewModel.movies.isEmpty ? 1 : 0)
                        )
                )
            }
            .background(.white)
            .toolbar(.automatic, for: .tabBar)
            .navigationTitle("Movies")
            .onAppear {
                print("ON appear")
                viewModel.fetchNowPlaying()
            }

        }
        
                
    }
    
    func movieRow(_ movie: MovieModel) -> some View {
        viewModel.navigateTo(movie: movie) {
            ZStack(alignment: .bottomLeading) {
                KFImage(movie.backdropPath.toImageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.ultraThickMaterial)
                    
                    Text(movie.overview)
                        .font(.system(size: 10, weight: .regular))
                        .lineLimit(2)
                        .foregroundStyle(.white)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 10)
                .frame(width: viewModel.screenSize.width - (LayoutConstants.sidePadding * 2))
                
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

#Preview {
    HomeScreen(
        viewModel: HomeVM(
            repository: MovieRepository.sharedInstance(
                CoreDataDataSource(), 
                RemoteDataSource(
                    configuration: .shared,
                    client: AlamofireClients()
                )
            )
        )
    )
}

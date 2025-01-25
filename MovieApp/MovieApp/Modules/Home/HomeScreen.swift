//
//  HomeScreen.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 21/01/25.
//

import SwiftUI
import Kingfisher

struct HomeScreen: View {
    @StateObject var presenter: HomePresenter
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: LayoutConstants.Spacing.medium) {
                    ForEach(presenter.movies, id: \.id) { movie in
                        movieRow(movie)
                    }
                }
                .padding(.vertical, LayoutConstants.verticalPadding)
                .padding(.horizontal, LayoutConstants.sidePadding)
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .onAppear {
                                presenter.screenSize = proxy.size
                            }
                            .onChange(of: proxy.size) { size in
                                presenter.screenSize = size
                            }
                    }
                        .overlay(
                            Text("Saat ini film tidak tersedia.")
                                .font(.system(size: 14))
                                .opacity(presenter.movies.isEmpty ? 1 : 0)
                        )
                )
            }
            .background(.white)
            .toolbar(.automatic, for: .tabBar)
            .navigationTitle("Movies")
            .onAppear {
                presenter.fetchNowPlaying()
            }

        }
        
                
    }
    
    func movieRow(_ movie: MovieModel) -> some View {
        presenter.navigateTo(movie: movie) {
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
                .frame(width: presenter.screenSize.width - (LayoutConstants.sidePadding * 2))
                
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

#Preview {
    HomeScreen(
        presenter: HomePresenter(
            useCase: Injection().provideHomeUseCase()
        )
    )
}

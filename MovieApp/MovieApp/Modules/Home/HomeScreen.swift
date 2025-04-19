//
//  HomeScreen.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 21/01/25.
//

import SwiftUI
import Kingfisher
import Core
import Movie

struct HomeScreen: View {
    @EnvironmentObject var master: MainVM
    @StateObject var presenter: GetListPresenter<
        URLRequest,
        MovieDomainModel,
        Interactor<
            URLRequest,
            [MovieDomainModel],
            MoviesRepositories<
                GetMoviesDataSource,
                MovieTransform
            >
        >
    >
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: LayoutConstants.Spacing.medium) {
                    ForEach(presenter.list, id: \.id) { movie in
                        NavigationLink {
                            HomeRouter().makeDetailView(id: movie.id)
                        } label: {
                            movieRow(movie)
                        }
                    }
                }
                .padding(.vertical, LayoutConstants.verticalPadding)
                .padding(.horizontal, LayoutConstants.sidePadding)
                .background(
                    GeometryReader { proxy in
                        if #available(iOS 17.0, *) {
                            Color.clear
                                .onAppear {
                                    master.screenSize = proxy.size
                                }
                                .onChange(of: proxy.size) { _, size in
                                    master.screenSize = size
                                }
                        } else {
                            Color.clear
                                .onAppear {
                                    master.screenSize = proxy.size
                                }
                                .onChange(of: proxy.size) { size in
                                    master.screenSize = size
                                }
                        }
                    }
                        .overlay(
                            Text("Saat ini film tidak tersedia.")
                                .font(.system(size: 14))
                                .opacity(presenter.list.isEmpty ? 1 : 0)
                        )
                )
            }
            .background(.white)
            .toolbar(.automatic, for: .tabBar)
            .navigationTitle("Movies")
            .onAppear {
                master.visibility = .visible
                presenter.getList(request: MovieEndpoint.list.urlRequest)
            }

        }
        
                
    }
    
    func movieRow(_ movie: MovieDomainModel) -> some View {
//        presenter.navigateTo(movie: movie) {
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
                .frame(width: master.screenSize.width - (LayoutConstants.sidePadding * 2))
                
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
            }
//        }
    }
}

//#Preview {
//    HomeScreen(
//        presenter: HomePresenter(
//            useCase: Injection().provideHomeUseCase()
//        )
//    )
//}

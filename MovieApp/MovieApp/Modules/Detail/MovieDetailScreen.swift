//
//  MovieDetailScreen.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 22/01/25.
//

import SwiftUI
import Kingfisher

struct MovieDetailScreen: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: MovieDetailVM
    @State var adaptiveColumn: [GridItem] = []
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                KFImage(viewModel.movieDetail.backdropPath.toImageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height * 0.5)
                    .clipped()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        HStack(alignment: .top) {
                            KFImage(viewModel.movieDetail.posterPath.toImageURL)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            VStack(alignment: .leading, spacing: 2) {
                                // "viewModel.movieDetail.title
                                Text(viewModel.movieDetail.title)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(.black)
                                
                                Text(viewModel.movieDetail.genres.map({ $0.name }).joined(separator: ", ") )
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                                
                                Text(viewModel.formatTime(minutes: viewModel.movieDetail.runtime))
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(.gray)
                                Spacer()
                                viewModel.rateView { rate in
                                    HStack(spacing: 8) {
                                        HStack(spacing: 2) {
                                            ForEach(0..<5, id: \.self) { index in
                                                let separator = Int(rate.components(separatedBy: ".").last ?? "0") ?? 0
                                                let double = Double(rate) ?? 0
                                                let separate = Int(double.rounded(.down)) == index && separator >= 1
                                                Image(systemName: index < Int(double.rounded(.down)) ? "star.fill" : separate ? "star.leadinghalf.filled" : "star")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 12)
                                                    .foregroundStyle(.orange)
                                                    .onAppear {
                                                        print(rate)
                                                    }
                                            }
                                        }
                                        Text(rate)
                                            .font(.system(size: 12, weight: .bold))
                                            .padding(.top, 1)
                                            .foregroundStyle(.orange)
                                    }
                                }
                                .padding(.bottom, 4)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .frame(width: proxy.size.width)
                        .padding(.top, proxy.size.height * 0.45)
                        .padding(.bottom, 24)
                        .background(
                            VStack {
                                Spacer()
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.clear,
                                                Color.white.opacity(0.3),
                                                Color.white.opacity(0.6),
                                                Color.white.opacity(0.88),
                                                Color.white.opacity(1),
                                                Color.white.opacity(1),
                                                Color.white
                                            ]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(width: proxy.size.width, height: 180)
                            }
                        )
                        
                        VStack(alignment: .leading, spacing: 24) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Overview")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(.black)
                                
                                viewModel.overview { text in
                                    Text(text)
                                }
                            }
                            .padding(.horizontal, LayoutConstants.sidePadding)
                            
                            productionView
                            Spacer()
                                .frame(height: proxy.size.width)
                        }
                        .background(.white)
                    }
                    .padding(.top, viewModel.screenSize.height / 3 - 24)
                    
                    
                    .toolbar(.hidden, for: .tabBar)
                }
                .overlay(
                    VStack {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.backward")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 16)
                                    .foregroundStyle(.black)
                                    .padding(.leading, -2)
                                    .padding(14)
                                    .background(.white)
                                    .clipShape(Circle())
                            }
                            
                            Spacer()
                            
                            Button {
                                viewModel.onTapFavoriteBTN()
                            } label: {
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 16)
                                    .foregroundStyle(viewModel.isFavorite ? .red : .black)
                                    .padding(10)
                                    .background(.white)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.top, proxy.safeAreaInsets.top + 24)
                        .padding(.horizontal, LayoutConstants.sidePadding)
                        Spacer()
                    }
                    
                )
                
                .ignoresSafeArea(edges: .top)
            }
            .overlay(
                ActivityIndicator(isAnimating: $viewModel.isLoading, style: .large)
            )
            .alert(viewModel.msgError, isPresented: $viewModel.isShowAlert) {
                Button("Oke", role: .cancel) {
                    if viewModel.isFromFavorite {
                        viewModel.onDelete?()
                        dismiss()
                    }
                }
            }
            .alert("Apakah anda yakin menghapusnya dari favorit?", isPresented: $viewModel.isAlertConfirmation) {
                Button("Batal", role: .cancel) { }
                
                Button("Yakin", role: .destructive) {
                    viewModel.deleteFavorite()
                }
            }
            .onAppear {
                adaptiveColumn = [
                    GridItem(.adaptive(minimum: (proxy.size.width / 4) - (16)))
//                    GridItem(.flexible())
                ]
            }
        }
        .preferredColorScheme(.light)
        .navigationBarBackButtonHidden()
    }
    
    var productionView: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Production Companies:")
                .font(.system(size: 14, weight: .bold))
                .padding(.horizontal, LayoutConstants.sidePadding)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .bottom, spacing: 24) {
                    ForEach(viewModel.movieDetail.productionCompanies, id: \.id) { production in
                        VStack(spacing: 4) {
                            if production.logoPath != "" {
                                KFImage(production.logoPath.toImageURL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 32)
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 32)
                            }
                            
                            Text(production.name)
                                .font(.system(size: 14))
                        }
                    }
                }
                .padding(.horizontal, LayoutConstants.sidePadding)
            }
        }
    }
}

#Preview {
    MovieDetailScreen(
        viewModel: MovieDetailVM(
            movieID: 939243,
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

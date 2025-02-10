//
//  FavoriteScreen.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 22/01/25.
//

import SwiftUI
import RxSwift
import Kingfisher

struct FavoriteScreen: View {
    @StateObject var presenter: FavoritePresenter
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(presenter.listFavorite, id: \.id) { movie in
                        presenter.navigateTo(movie: movie) {
                            rowView(movie)
                        }
                    }
                }
                .padding(.horizontal, LayoutConstants.sidePadding)
            }
            .background(.white)
            .toolbar(.automatic, for: .tabBar)
            .navigationTitle("Favorite")
        }
        .overlay(
            Text("Simpan film favorit anda sekarang")
                .font(.system(size: 14))
                .opacity(presenter.listFavorite.isEmpty ? 1 : 0)
        )
        .onAppear {
            print("HELLOOO")
            presenter.fetchFavorite()
        }
    }
    
    func rowView(_ movie: MovieDetailModel) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 8) {
                KFImage(movie.posterPath.toImageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.black)
                    
                    presenter.rateView(movie: movie) { rate in
                        HStack(spacing: 4) {
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
                                }
                            }
                            
                            Text(rate)
                                .font(.system(size: 12, weight: .bold))
                                .padding(.top, 1)
                                .foregroundStyle(.orange)
                        }
                    }
                    
                    Spacer()
                    Text(movie.overview)
                        .lineLimit(2)
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 4)
                }
            }
            .padding(.vertical, 10)
            
            if presenter.listFavorite.last?.id != movie.id {
                Divider()
            }
        }
    }
}

#Preview {
    FavoriteScreen(
        presenter: FavoritePresenter(
            useCases: Injection().provideFavoriteUseCase()
        )
    )
}

class FavoritePresenter: ObservableObject {
    @Published var listFavorite: [MovieDetailModel] = []
    @Published var isOnAppear: Bool = false
    
    @Published var isAlert: Bool = false
    @Published var msgAlert: String = ""
    
    let router = FavoriteRouter()
    let useCase: FavoriteUseCase
    private let disposeBag = DisposeBag()
    
    init(useCases: FavoriteUseCase) {
        self.useCase = useCases
    }
}

extension FavoritePresenter {
    func rateView<Content: View>(movie: MovieDetailModel, @ViewBuilder content: (String) -> Content) -> some View {
        content(String(convertToFiveStarScale(voteAverage: movie.voteAverage)))
    }
    
    func navigateTo<Content: View>(movie: MovieDetailModel, @ViewBuilder content: @escaping () -> Content) -> some View {
        NavigationLink {
            router.makeDetailView(id: movie.id, isFromFavorite: true, onDelete: {
                self.fetchFavorite()
            })
            .navigationBarBackButtonHidden()
        } label: {
            content()
        }
    }
    
    func fetchFavorite() {
        useCase.getFavorite()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                self.listFavorite = result
            }, onError: { error in
                self.msgAlert = error.localizedDescription
                self.isAlert = true
            })
            .disposed(by: disposeBag)
    }
    
    func convertToFiveStarScale(voteAverage: Double) -> Double {
        let scaledValue = voteAverage / 2.0
         return (scaledValue * 2.0).rounded() / 2.0
    }
}

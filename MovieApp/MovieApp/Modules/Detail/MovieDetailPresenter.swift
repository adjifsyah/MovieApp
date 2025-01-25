//
//  MovieDetailVM.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 22/01/25.
//

import SwiftUI
import RxSwift

class MovieDetailPresenter: ObservableObject {
    @Published var movieDetail: MovieDetailModel = .init()
    private let useCase: MovieDetailUseCase
    private let disposeBag = DisposeBag()
    private let movieID: Int
    
    @Published var msgError: String = ""
    @Published var isShowAlert: Bool = false
    @Published var isAlertConfirmation: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var isFavorite: Bool = false
    @Published var isFromFavorite: Bool = false
    
    @Published var screenSize: CGSize = .zero
    @Published var onDelete: (() -> Void)? = nil
    
    init(movieID id: Int, isFromFavorite: Bool = false, useCase: MovieDetailUseCase, onDelete: (() -> Void)? = nil) {
        self.movieID = id
        self.useCase = useCase
        self.onDelete = onDelete
        self.isFromFavorite = isFromFavorite
        fetchMovieDetail()
    }
    
    func fetchMovieDetail() {
        isLoading = true
        useCase.fetchMovieDetail(id: movieID)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                self.movieDetail = result
                self.checkFavorite()
                self.isLoading = false
            }, onError: { error in
                self.isLoading = false
            })
            .disposed(by: disposeBag)
    }
    
    func onTapFavoriteBTN() {
        if isFavorite {
            isAlertConfirmation = true
        } else {
            saveFavorite()
        }
    }
    
    func checkFavorite() {
        useCase.getFavorite(id: movieDetail.id)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                self.isFavorite = self.movieDetail.id == result.id
            }, onError: { _ in
                self.msgError = "Gagal mendapatkan data favorite"
                self.isShowAlert = true
            })
            .disposed(by: disposeBag)
    }
    
    func saveFavorite() {
        useCase.addFavorite(movie: movieDetail)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                self.movieDetail = result
                self.msgError = "Berhasil menambahkan favorit"
                self.isFavorite = self.movieDetail.id == result.id
                self.isShowAlert = true
            }, onError: { error in
                self.msgError = (error as? DatabaseError)?.errorDescription ?? ""
                self.isShowAlert = true
            })
            .disposed(by: disposeBag)
    }
    
    func deleteFavorite() {
        useCase.deleteFavorite(id: movieID)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { isSuccess in
                self.isFavorite = !(isSuccess == true)
                self.msgError = "\(isSuccess ? "Berhasil" : "Gagal") menghapus favorit"
                self.isShowAlert = isSuccess
            }, onError: { error in
                self.msgError = error.localizedDescription
                self.isShowAlert = true
            })
            .disposed(by: disposeBag)
    }
    
    func rateView<Content: View>(@ViewBuilder content: (String) -> Content) -> some View {
        content(String(convertToFiveStarScale(voteAverage: movieDetail.voteAverage)))
    }
    
    func overview<Content: View>(@ViewBuilder content: (String) -> Content) -> some View {
        HStack(spacing: 4) {
            content(movieDetail.overview)
                .font(.system(size: 14))
                .foregroundStyle(.gray)
        }
    }
    
    func formatTime(minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        return "\(hours)h \(remainingMinutes)m"
    }
    
    func convertToFiveStarScale(voteAverage: Double) -> Double {
        let scaledValue = voteAverage / 2.0
         return (scaledValue * 2.0).rounded() / 2.0
    }
}


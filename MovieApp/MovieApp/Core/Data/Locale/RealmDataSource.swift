//
//  RealmDataSource.swift
//  MovieApp
//
//  Created by Apple Josal on 17/02/25.
//

import Foundation
import RealmSwift
import RxSwift

class RealmDataSource: LocaleDataSourceLmpl {
    let realm: Realm?
    
    init(realm: Realm?) {
        self.realm = realm
    }
    
    func getFavorite() -> Observable<[MovieDetailModel]> {
        Observable<[MovieDetailModel]>.create { observer in
            if let realm = self.realm {
                let favorites: Results<MoviesEntity> = {
                    realm.objects(MoviesEntity.self)
                }()
                
                let resultArr = favorites.toArray(ofType: MoviesEntity.self)
                observer.onNext(MovieMapper.mapMovieDetailEntityToDomain(movieEntity: resultArr))
            } else {
                observer.onError(DatabaseError.invalidInstance)
                
            }
            return Disposables.create()
        }
    }
    
    func getDetailFavorite(movieID: Int) -> Observable<MovieDetailModel> {
        Observable<MovieDetailModel>.create { observer in
            if let realm = self.realm {
                let favorites: Results<MoviesEntity> = {
                    realm.objects(MoviesEntity.self)
                }()
                
                let resultArr = favorites.toArray(ofType: MoviesEntity.self)
                let result = MovieMapper
                    .mapMovieDetailEntityToDomain(movieEntity: resultArr)
                    .first(where: { Int($0.id) == movieID }) ?? MovieDetailModel()
                observer.onNext(result)
            } else {
                observer.onError(DatabaseError.invalidInstance)
                
            }
            return Disposables.create()
        }
    }
    
    func addFavorite(movie: MovieDetailModel) -> Observable<Bool> {
        Observable<Bool>.create { observer in
            if let realm = self.realm {
                do {
                    try realm.write {
                        let mapper = MovieMapper.mapMovieDetailDomainToEntity(movie: movie)
                        realm.add(mapper, update: .all)
                        observer.onNext(true)
                    }
                } catch {
                    observer.onError(DatabaseError.requestFailed)
                }
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            return Disposables.create()
        }
    }
    
    func deleteFavorite(movieId: Int) -> Observable<Bool> {
        Observable<Bool>.create { observer in
            if let realm = self.realm {
                var movieEntity: Results<MoviesEntity> {
                    realm.objects(MoviesEntity.self).filter("movie_id = '\(movieId)'")
                }
                do {
                    try realm.write {
                        realm.delete(movieEntity)
                        observer.onNext(true)
                    }
                } catch {
                    observer.onError(DatabaseError.requestFailed)
                }
            } else {
                observer.onError(DatabaseError.invalidInstance)
                
            }
            return Disposables.create()
        }
    }
}

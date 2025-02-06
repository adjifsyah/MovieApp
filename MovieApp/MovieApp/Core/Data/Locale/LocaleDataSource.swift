//
//  LocaleDataSource.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 23/01/25.
//

import Foundation
import CoreData
import RxSwift

protocol LocaleDataSourceLmpl {
    func getFavorite() -> Observable<[MovieDetailModel]>
    func getDetailFavorite(movieID: Int) -> Observable<MovieDetailModel>
    func addFavorite(movie: MovieDetailModel) -> Observable<Bool>
    func deleteFavorite(movieId: Int) -> Observable<Bool>
}

class CoreDataDataSource: LocaleDataSourceLmpl {
    let persistence = PersistenceController.shared
    
    private init() { }
    
    static let sharedInstance: LocaleDataSourceLmpl = CoreDataDataSource()
    
    func getFavorite() -> Observable<[MovieDetailModel]> {
        return Observable.create { observer in
            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            
            do {
                let existingCart = try self.persistence.container.viewContext.fetch(fetchRequest)
                
                observer.onNext(
                    MovieMapper.mapMovieDetailEntityToDomain(
                        movieEntity: existingCart,
                        context: self.persistence.container.viewContext
                    )
                )
                observer.onCompleted()
            } catch {
                observer.onError(DatabaseError.invalidInstance)
            }
            return Disposables.create()
        }
    }
    
    func getDetailFavorite(movieID: Int) -> Observable<MovieDetailModel> {
        return Observable.create { observer in
            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "movie_id == %d", Int64(movieID))
            do {
                let existingCart = try self.persistence.container.viewContext.fetch(fetchRequest)
                
                if let movie = existingCart.first {
                    observer.onNext(
                        MovieMapper.mapMovieDetailEntityToDomain(movie: movie)
                    )
                    observer.onCompleted()
                } else {
                    observer.onError(DatabaseError.invalidInstance)
                }
                
            } catch {
                observer.onError(DatabaseError.invalidInstance)
            }
            return Disposables.create()
        }
    }
    
    func addFavorite(movie: MovieDetailModel) -> Observable<Bool> {
        return Observable.create { observer in
            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "movie_id == %d", movie.id)
            
            do {
                let existingMovie = try self.persistence.container.viewContext.fetch(fetchRequest).first
                if existingMovie == nil {
                    let _ = MovieMapper.mapMovieDetailDomainToEntity(movie: movie, context: self.persistence.container.viewContext)
                }
                
                try self.persistence.container.viewContext.save()
                observer.onNext(true)
                observer.onCompleted()
            } catch {
                observer.onError(DatabaseError.requestFailed)
            }
            
            return Disposables.create()
        }
    }
    
    func deleteFavorite(movieId: Int) -> Observable<Bool> {
        return Observable.create { observer in
            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "movie_id == %d", Int64(movieId))
            
            do {
                let cartsToDelete = try self.persistence.container.viewContext.fetch(fetchRequest)
                
                if let movie = cartsToDelete.first {
                    self.persistence.container.viewContext.delete(movie)
                }
                
                try self.persistence.container.viewContext.save()
                
                observer.onNext(true)
                observer.onCompleted()
            } catch {
                observer.onError(DatabaseError.requestFailed)
            }
            
            return Disposables.create()
        }
    }
}


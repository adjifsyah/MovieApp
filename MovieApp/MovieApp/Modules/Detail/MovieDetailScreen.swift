//
//  MovieDetailScreen.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 22/01/25.
//

import SwiftUI

struct MovieDetailScreen: View {
    @StateObject var viewModel: MovieDetailVM
    var body: some View {
        Text("Halo Detail")
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

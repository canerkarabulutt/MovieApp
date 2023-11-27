//
//  FavoriteViewController.swift
//  MovieApp
//
//  Created by Caner Karabulut on 22.11.2023.
//

import UIKit

private let identifier = "FavoriteCell"

class FavoritesViewController: UICollectionViewController {
    //MARK: - Properties
    private var movies: [MovieItem] = [MovieItem]()

    //MARK: - Lifecycle
     init() {
         let flowLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: flowLayout)
         setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCollectionView()
    }
}
//MARK: - Helpers
extension FavoritesViewController {
    private func updateCollectionView() {
        DataPersistenceManager.shared.fetchingMoviesFromDatabase { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print("Filmler çekilemedi: \(error.localizedDescription)")
            }
        }
    }
    private func setup() {
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: identifier)
    }
}
extension FavoritesViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? FavoriteCell else { return UICollectionViewCell() }
        let movie = movies[indexPath.row]
        cell.configure(with: MovieViewModel(movieTitleName: (movie.original_title ?? movie.original_name) ?? "Unknown", posterURL: movie.poster_path ?? ""))
        return cell
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 30) / 2
        return .init(width: width, height: width + 50)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 10, bottom: 10, right: 10)
    }
}

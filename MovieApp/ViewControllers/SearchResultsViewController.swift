//
//  SearchResultsViewController.swift
//  MovieApp
//
//  Created by Caner Karabulut on 24.11.2023.
//

import UIKit

protocol SearchResultsViewControllerDelegate : AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: MoviePreviewViewModel)
}

class SearchResultsViewController: UIViewController {
    //MARK: - Properties
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    public var movies: [Movie] = [Movie]()
    
    public let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        style()
        layout()
    }
}
//MARK: - Helpers
extension SearchResultsViewController {
    private func style() {
        searchResultsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        searchResultsCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    private func layout() {
        view.addSubview(searchResultsCollectionView)
        searchResultsCollectionView.frame = view.bounds
    }
}
//MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension SearchResultsViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        let movieName = movie.original_title ?? ""
        APICaller.shared.getYoutubeData(with: movieName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                self?.delegate?.searchResultsViewControllerDidTapItem(MoviePreviewViewModel(movie: movie.original_title ?? "", youtubeView: videoElement, movieOverview: movie.overview ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        let movie = movies[indexPath.row]
        cell.configure(with: movie.poster_path ?? "")
        return cell
    }
}
extension SearchResultsViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: UIScreen.main.bounds.width / 3 - 10, height: 180)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 10, bottom: 0, right: 10)
    }
}

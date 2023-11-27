//
//  CollectionViewTableViewCell.swift
//  MovieApp
//
//  Created by Caner Karabulut on 22.11.2023.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: MoviePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var movies: [Movie] = [Movie]()

    let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 140, height: 210)
            layout.scrollDirection = .horizontal
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }()
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
        contentView.backgroundColor = .systemPurple
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Helpers
extension CollectionViewTableViewCell {
    private func setup() {
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    private func layout() {
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
                    collectionView.topAnchor.constraint(equalTo: topAnchor),
                    collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
    }
//MARK: - ConfigureProcess
    public func configure(with movies: [Movie]) {
        self.movies = movies
        DispatchQueue.main.async {
            [weak self] in
            self?.collectionView.reloadData()
        }
    }
    private func downloadMovieAt(indexPath: IndexPath) {
        DataPersistenceManager.shared.downloadMovieWith(model: movies[indexPath.row]) { result in
            switch result {
            case .success(_):
                NotificationCenter.default.post(name: NSNotification.Name("Downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
//MARK: - UICollectionViewDelegate & Datasource
extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let model = movies[indexPath.row].poster_path else { return UICollectionViewCell() }
        cell.configure(with: model)
        return cell
    }
    // AFTER YOUTUBE API
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        guard let movieTitleName = movie.original_title ?? movie.original_name else { return }
        
        APICaller.shared.getYoutubeData(with: movieTitleName + "trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                let movie = self?.movies[indexPath.row]
                guard let movieOverview = movie?.overview else { return }
                
                guard let strongSelf = self else { return }
                let viewModel = MoviePreviewViewModel(movie: movieTitleName, youtubeView: videoElement, movieOverview: movieOverview)
                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    //LONGPRESS and DOWNLOAD
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
        identifier: nil,
        previewProvider: nil) { _ in
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                self.downloadMovieAt(indexPath: indexPath)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
        
    }
}


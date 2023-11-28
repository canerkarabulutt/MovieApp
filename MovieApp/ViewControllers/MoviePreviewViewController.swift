//
//  MoviePreviewViewController.swift
//  MovieApp
//
//  Created by Caner Karabulut on 25.11.2023.
//

import UIKit
import WebKit
import CoreData


class MoviePreviewViewController: UIViewController {
    //MARK: - Properties
    
    private var movies: [MovieItem] = [MovieItem]()
    
    private var model: MoviePreviewViewModel?
    
    private let movieLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        return label
    }()
    private let overviewLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    private let downloadButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    private var isFavorite = false {
        didSet {
            setupNavBarItem()
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        style()
        layout()
        addCoreData()
    }

}
//MARK: - Selector
extension MoviePreviewViewController {
    @objc private func handleFavoriteButton() {
        print("Favorite")
        guard let movieID = model?.youtubeView.id else {
                    return
        }

        print(movieID)
    }
}
//MARK: - Helpers
extension MoviePreviewViewController {
    private func addCoreData() {
        DataPersistenceManager.shared.fetchingMoviesFromDatabase { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.webView.reload()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    private func setupNavBarItem() {
        if isFavorite {
            let navRightItem = UIBarButtonItem(image: UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(handleFavoriteButton))
            self.navigationItem.rightBarButtonItem = navRightItem
        } else {
            let navRightItem = UIBarButtonItem(image: UIImage(systemName: "star")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(handleFavoriteButton))
            self.navigationItem.rightBarButtonItem = navRightItem
        }
        
    }
    private func style() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        movieLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        setupNavBarItem()
        
    }
    private func layout() {
        view.addSubview(webView)
        view.addSubview(movieLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 360),
            
            movieLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            movieLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            overviewLabel.topAnchor.constraint(equalTo: movieLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            downloadButton.widthAnchor.constraint(equalToConstant: 120),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
        
    }
    func configure(with model: MoviePreviewViewModel) {
        self.model = model
        movieLabel.text = model.movie
        overviewLabel.text = model.movieOverview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else { return }
        
        webView.load(URLRequest(url: url))
    }
}

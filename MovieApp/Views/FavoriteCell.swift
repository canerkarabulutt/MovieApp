//
//  FavoriteCell.swift
//  MovieApp
//
//  Created by Caner Karabulut on 27.11.2023.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    //MARK: - Properties
    private let movieImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .purple
        return imageView
    }()
    private let movieNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Name"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    private var stackView: UIStackView!

    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Helpers
extension FavoriteCell {
    private func style() {
        stackView = UIStackView(arrangedSubviews: [movieImageView, movieNameLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            
            movieImageView.heightAnchor.constraint(equalTo: movieImageView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    public func configure(with model: MovieViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        movieImageView.sd_setImage(with: url, completed: nil)
        movieNameLabel.text = model.movieTitleName
    }
}

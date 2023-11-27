//
//  MovieTableViewCell.swift
//  MovieApp
//
//  Created by Caner Karabulut on 23.11.2023.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "MovieTableViewCell"
    
    private let moviesPosterImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()

    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Helpers
extension MovieTableViewCell {
    private func setup() {
        moviesPosterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout() {
        contentView.addSubview(moviesPosterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            moviesPosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            moviesPosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            moviesPosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            moviesPosterImageView.widthAnchor.constraint(equalToConstant: 110),
            
            titleLabel.leadingAnchor.constraint(equalTo: moviesPosterImageView.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)

            
        ])
    }
    
    public func configure(with model: MovieViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        moviesPosterImageView.sd_setImage(with: url, completed: nil)
        titleLabel.text = model.movieTitleName
    }
}

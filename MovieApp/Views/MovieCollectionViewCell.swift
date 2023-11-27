//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Caner Karabulut on 23.11.2023.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "MovieCollectionViewCell"

    private let posterImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
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
extension MovieCollectionViewCell {
    private func style() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        contentView.addSubview(posterImageView)
        posterImageView.frame = contentView.bounds
        
    }
    public func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else { return }
        posterImageView.sd_setImage(with: url, completed: nil)
    }
    
}

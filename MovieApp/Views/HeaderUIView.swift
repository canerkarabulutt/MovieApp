//
//  HeaderUIView.swift
//  MovieApp
//
//  Created by Caner Karabulut on 22.11.2023.
//

import UIKit


class HeaderUIView: UIView {
    //MARK: - Properties
    static let identifier = "HeaderUIView"

    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.borderColor = UIColor.purple.cgColor
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 3
        button.layer.backgroundColor = UIColor.black.cgColor
        return button
    }()
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.borderColor = UIColor.purple.cgColor
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 3
        button.layer.backgroundColor = UIColor.black.cgColor
        return button
    }()
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //MARK: - Lifecylce
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
        backgroundGradientColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Helpers
extension HeaderUIView {
    private func style() {
        playButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.translatesAutoresizingMaskIntoConstraints = false

    }
    private func layout() {
        addSubview(headerImageView)
        addSubview(playButton)
        addSubview(downloadButton)
        
        headerImageView.frame = bounds
        
        NSLayoutConstraint.activate([
            
            
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -45),
            playButton.widthAnchor.constraint(equalToConstant: 120),
            
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -45),
            downloadButton.widthAnchor.constraint(equalToConstant: 120),
            
        ])
    }
    public func configure(with model: MovieViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
            headerImageView.sd_setImage(with: url) { (image, error, cacheType, imageUrl) in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                } else {
            }
        }
    }
}

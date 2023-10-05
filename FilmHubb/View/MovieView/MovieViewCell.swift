//
//  MovieViewCell.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 2.10.2023.
//

import UIKit
import SDWebImage

class MovieViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "MovieCollectionViewCell"
    
    var viewModel: MovieViewModel!
    
    private lazy var posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(posterImageView)
        posterImageView.fillSuperview()
        posterImageView.addShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configure(viewModel: MovieViewModel) {
        self.viewModel = viewModel
        
        posterImageView.sd_setImage(with: viewModel.posterImage)
    }
}

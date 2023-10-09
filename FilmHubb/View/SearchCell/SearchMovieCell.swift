//
//  SearchMovieCell.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 5.10.2023.
//

import UIKit

class SearchMovieCell: UITableViewCell {
    
    //MARK: - Properties
    
    var viewModel: SearchMovieViewModel?
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Movie Title"
        return label
    }()
    
    private let originalTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Original title"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(posterImageView)
        posterImageView.setDimensions(height: frame.height, width: 40)
        posterImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 4, paddingLeft: 4, paddingRight: 4)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, originalTitleLabel])
        stack.axis = .vertical
        stack.spacing = 6
        
        addSubview(stack)
        stack.centerY(inView: posterImageView, leftAnchor: posterImageView.rightAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - API
    
    //MARK: - Actions
    
    //MARK: - Helpers
    
    func configure(viewModel: SearchMovieViewModel) {
        self.viewModel = viewModel
        
        posterImageView.sd_setImage(with: viewModel.posterImage)
        titleLabel.text = viewModel.titleText
        originalTitleLabel.text = viewModel.originalTitleText
    }
}

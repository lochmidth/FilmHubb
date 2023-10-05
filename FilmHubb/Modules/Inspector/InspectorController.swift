//
//  InspectorController.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 4.10.2023.
//

import UIKit

class InspectorController: UIViewController {
    
    //MARK: - Properties
    
//    private let scrollView: UIScrollView = {
//        let scroll = UIScrollView()
//        scroll.showsVerticalScrollIndicator = true
//        scroll.isDirectionalLockEnabled = true
//        scroll.showsHorizontalScrollIndicator = false
//        return scroll
//    }()
//
//    let contentView: UIView = {
//        let view = UIView()
//        return view
//    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let movieImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let movieInfo: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let movieDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let castLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var trailerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Watch Trailer ▶️", for: .normal)
        button.addTarget(self, action: #selector(handleSafariController), for: .touchUpInside)
        return button
    }()
    
    private let crewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let voteOverall: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Lifecycle
    
    var viewModel: InspectorViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureViewModel()
    }
    
    init(viewModel: InspectorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - API
    
    //MARK: - Actions
    
    @objc func handleDismissal() {
        dismiss(animated: true)
    }
    
    @objc func handleSafariController() {
        guard let url = viewModel.youtubeLink else { return }
        UIApplication.shared.open(url)
    }
    
    //MARK: - Helpers
    
    func configureViewModel() {
        titleLabel.text = viewModel.titleText
        movieImageView.sd_setImage(with: viewModel.backdropImageUrl)
        movieInfo.text = viewModel.infoText
        movieDescription.text = viewModel.descriptionText
        castLabel.attributedText = viewModel.castText
        crewLabel.attributedText = viewModel.crewText
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingLeft: 12)
        
        view.addSubview(movieImageView)
        movieImageView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8)
        movieImageView.setDimensions(height: 250, width: view.frame.width)
        
        view.addSubview(movieInfo)
        movieInfo.anchor(top: movieImageView.bottomAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        view.addSubview(movieDescription)
        movieDescription.anchor(top: movieInfo.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                                paddingTop: 12, paddingLeft: 8, paddingRight: 8)
        
        view.addSubview(trailerButton)
        trailerButton.anchor(top: movieDescription.bottomAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 8)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        
        view.addSubview(divider)
        divider.anchor(top: trailerButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, height: 0.5)
        
        let creditStack = UIStackView(arrangedSubviews: [crewLabel, castLabel])
        creditStack.axis = .horizontal
        creditStack.alignment = .leading
        creditStack.spacing = 12
        
        view.addSubview(creditStack)
        creditStack.anchor(top: divider.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 8, paddingRight: 8)
        
        
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        let image = UIImage(systemName: "arrow.backward")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(handleDismissal))
    }
}

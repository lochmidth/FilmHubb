//
//  InspectorController.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 4.10.2023.
//

import UIKit

class InspectorController: UIViewController {
    
    //MARK: - Properties
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView(frame: .zero)
        sv.layoutIfNeeded()
        sv.frame = self.view.bounds
        sv.contentSize = CGSize(width: self.view.frame.width , height: self.view.frame.size.height)
        sv.autoresizingMask = .flexibleHeight
        sv.showsVerticalScrollIndicator = true
        sv.bounces = true
        return sv
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let originalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private let movieImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private lazy var favoriteStar: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "star")
        iv.tintColor = .mikadoYellow
        iv.setDimensions(height: 25, width: 29)
        iv.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFavoritePressed))
        iv.addGestureRecognizer(tap)
        
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
        showLoader(false)
//        MovieService.shared.deleteAllData {
//            print("DEBUG: all coreData is deleted.")
//        }
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
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func handleSafariController() {
        guard let url = viewModel.youtubeLink else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func swipeAction(swipe: UISwipeGestureRecognizer) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func handleFavoritePressed() {
        if viewModel.isFavorite {
            MovieService.shared.deleteCoreData(forMovie: viewModel.movie) {
                self.favoriteStar.image = UIImage(systemName: "star")
            }
        } else {
            MovieService.shared.createCoreData(forMovie: viewModel.movie) {
                self.favoriteStar.image = UIImage(systemName: "star.fill")
            }
        }
        
    }
    
    //MARK: - Helpers
    
    func configureViewModel() {
        titleLabel.text = viewModel.titleText
        titleLabel.font = UIFont.systemFont(ofSize: viewModel.calculateTitleFontSize(for: titleLabel.text ?? "", containerView))
        originalTitleLabel.text = viewModel.originalTitleText
        movieImageView.sd_setImage(with: viewModel.backdropImageUrl)
        movieInfo.text = viewModel.infoText
        movieDescription.text = viewModel.descriptionText
        castLabel.attributedText = viewModel.castText
        crewLabel.attributedText = viewModel.crewText
        favoriteStar.image = viewModel.favoriteStarStatus
        
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, favoriteStar])
        titleStack.axis = .horizontal
        titleStack.spacing = 4
        
        containerView.addSubview(titleStack)
        titleStack.anchor(top: containerView.safeAreaLayoutGuide.topAnchor, left: containerView.leftAnchor,
                          paddingLeft: 12)
        
        containerView.addSubview(originalTitleLabel)
        originalTitleLabel.anchor(top: titleStack.bottomAnchor, left: containerView.leftAnchor, paddingTop: 8, paddingLeft: 12)
        
        containerView.addSubview(movieImageView)
        movieImageView.anchor(top: originalTitleLabel.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor,
                              paddingTop: 8)
        movieImageView.setDimensions(height: 250, width: containerView.frame.width)
        
        containerView.addSubview(movieInfo)
        movieInfo.anchor(top: movieImageView.bottomAnchor, left: containerView.leftAnchor,
                         paddingTop: 12, paddingLeft: 12)
        
        containerView.addSubview(movieDescription)
        movieDescription.anchor(top: movieInfo.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor,
                                paddingTop: 12, paddingLeft: 8, paddingRight: 8)
        
        containerView.addSubview(trailerButton)
        trailerButton.anchor(top: movieDescription.bottomAnchor, left: containerView.leftAnchor,
                             paddingTop: 12, paddingLeft: 8)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        
        containerView.addSubview(divider)
        divider.anchor(top: trailerButton.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor,
                       paddingTop: 24, height: 0.5)
        
        let creditStack = UIStackView(arrangedSubviews: [crewLabel, castLabel])
        creditStack.axis = .horizontal
        creditStack.alignment = .leading
        creditStack.spacing = 12
        
        containerView.addSubview(creditStack)
        creditStack.anchor(top: divider.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor,
                           paddingTop: 12, paddingLeft: 8, paddingRight: 8)
        
        configureNavigationBar()
        configureGestureRecognizer()
    }
    
    func configureGestureRecognizer() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(swipe:)))
        leftSwipe.direction = .right
        view.addGestureRecognizer(leftSwipe)
    }
    
    func configureNavigationBar() {
        let image = UIImage(systemName: "arrow.backward")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(handleDismissal))
    }
}

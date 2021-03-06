//
//  ResultListingViewController.swift
//  CleaniTunes
//
//  Created by hager gamal on 1/29/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Kingfisher

enum DisplayMode {
    case list
    case grid
    
    var columnsCount: Int {
        switch self {
        case .list:
            return 1
        case .grid:
            return 3
        }
    }
    var cellHeight: CGFloat {
        switch self {
        case .list:
            return 125
        case .grid:
            return 250
        }
    }
    var cellId: String {
        switch self {
        case .list:
            return "ListCell"
        default:
            return "GridCell"
        }
    }
    var linespacing: CGFloat {
        switch self {
        case .list:
            return 10
        case .grid :
            return 5
        }
    }
}

protocol ResultListingDisplayLogic: class {
    func displayResults(viewModel: ResultListing.GetResults.ViewModel)
    func displayMode(displayMode: DisplayMode)
}

class ResultListingViewController: UIViewController, ResultListingDisplayLogic {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let cellSpacing: CGFloat = 10
    var interactor: ResultListingBusinessLogic?
    var router: (NSObjectProtocol & ResultListingRoutingLogic & ResultListingDataPassing)?
    private var displayedResults: [[ResultListing.GetResults.ViewModel.ResultModel]] = [[]]
    private var displayMode = DisplayMode.grid
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
   
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = ResultListingInteractor()
        let presenter = ResultListingPresenter()
        let router = ResultListingRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    func setupUI() {
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 5
        }
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
            let image = UIImage(named: "icon")
            imageView.image = image
            navigationItem.titleView = imageView
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getResultList()
    }
    
    // MARK: Actions
    
    func displayMode(displayMode: DisplayMode) {
        self.displayMode = displayMode
        collectionView.reloadData()
    }
    
    func getResultList() {
        interactor?.getResults()
    }
    
    func displayResults(viewModel: ResultListing.GetResults.ViewModel) {
        displayedResults = viewModel.results
        collectionView.reloadData()
    }
    
    @IBAction func listButtonDidTapped(_ sender: Any) {
        interactor?.setDisplayMode(mode: .list)
    }
    
    @IBAction func gridButtonDidTapped(_ sender: Any) {        interactor?.setDisplayMode(mode: .grid)
    }
}
extension ResultListingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "HeaderSection",
                    for: indexPath) as? HeaderCollectionReusableView
            else {
                fatalError("Invalid view type")
            }
            let searchTerm = displayedResults[indexPath.section][indexPath.item].kind?
                .displayKind ?? displayedResults[indexPath.section][indexPath.item].wrapperType
                .displayType
            headerView.genreLabel.text = searchTerm
            return headerView
        default:
            assert(false, "Invalid element type")
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return displayedResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedResults[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: displayMode.cellId, for: indexPath) as? GridCollectionViewCell else {
            return UICollectionViewCell()
        }
        let displayedResult = displayedResults[indexPath.section][indexPath.row]
        cell.imageView.kf.setImage(with: displayedResult.trackImageURL)
        cell.titleLabel.text = displayedResult.trackName
        cell.subTitleLabel.text = displayedResult.artistName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let resultModel = displayedResults[indexPath.section][indexPath.row]
        router?.routeToDetails(resultDetails: resultModel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return displayMode.linespacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columnsCount = displayMode.columnsCount
        let spacing = cellSpacing * CGFloat(columnsCount - 1)
        let width = floor((self.collectionView.frame.size.width - spacing) / CGFloat(columnsCount))
        let itemSize = CGSize(width: width, height: displayMode.cellHeight)
        return itemSize
    }
}

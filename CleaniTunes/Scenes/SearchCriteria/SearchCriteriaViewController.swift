//
//  SearchCriteriaViewController.swift
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
import TTGTagCollectionView
protocol SearchCriteriaDisplayLogic: class {
    func navigateToListing(viewModel: SearchCriteria.GetResults.ViewModel)
    func showNoDataError()
    func presentError(error: String)
    func fetchResult(term: String, entity: [String])
}

class SearchCriteriaViewController: UIViewController, SearchCriteriaDisplayLogic, MediaTypeSelectionDelegate {
    
    @IBOutlet weak var labelTermDescription: UILabel!
    @IBOutlet weak var textFieldTerm: UITextField!
    @IBOutlet weak var labelEntityDescription: UILabel!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var innerViewTags: UIView!
    @IBOutlet weak var viewSelectedMediaTypes: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var interactor: SearchCriteriaBusinessLogic?
    var router: (NSObjectProtocol & SearchCriteriaRoutingLogic & SearchCriteriaDataPassing)?
    var selectedMediaTypes: [(displayedName: String, name: String)] = []
    var tagCollectionView: TTGTextTagCollectionView?
    
    // MARK: Setup
    
    func setup(presenter: SearchCriteriaPresenter, interactor: SearchCriteriaInteractor, router: SearchCriteriaRouter) {
        let viewController = self
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func buttonSubmitDidTapped(_ sender: Any) {
        submit(input: textFieldTerm.text, selectedMediaTypes: selectedMediaTypes)
    }
    
    func submit(input: String?, selectedMediaTypes: [(displayedName: String, name: String)]) {
        interactor?.validate(input: input, selectedMediaTypes: selectedMediaTypes)
    }
    
    func showValidationAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showNoDataError() {
        activityIndicator?.stopAnimating()
        showValidationAlert(message: "there is no Data for your search")
    }
    
    func presentError(error: String) {
        activityIndicator?.stopAnimating()
        showValidationAlert(message: error)
    }
    
    func startAnimating() {
        self.activityIndicator?.isHidden = false
        self.activityIndicator?.startAnimating()
    }
    
    func fetchResult(term: String, entity: [String]) {
        startAnimating()
        let request = SearchCriteria.GetResults.Request(term: term, entity: entity)
        interactor?.fetchResult(request: request)
    }
    
    @IBAction func mediaTypeViewDidTapped(_ sender: Any) {
        router?.navigateToMediaTypeSelection(selectedMediaTypes: selectedMediaTypes.map { $0.displayedName })
    }
    
    func selectedMediaTypes(mediaTypes: [(displayedName: String, name: String)]) {
        selectedMediaTypes = mediaTypes
        addTagsView(mediaTypes: mediaTypes.map { $0.displayedName })
    }
    
    func addTagsView(mediaTypes: [String]) {
        self.innerViewTags.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        let tagCollectionView = TTGTextTagCollectionView(frame: innerViewTags.frame)
        self.innerViewTags.addSubview(tagCollectionView)
        tagCollectionView.isUserInteractionEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.mediaTypeViewDidTapped(_:)))
        innerViewTags.addGestureRecognizer(tap)
        tagCollectionView.addTags(mediaTypes)
    }
    
    func navigateToListing(viewModel: SearchCriteria.GetResults.ViewModel) {
        activityIndicator?.stopAnimating()
        router?.navigateToResultList(result: viewModel.results)
    }
}

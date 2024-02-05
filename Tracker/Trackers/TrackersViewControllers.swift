//
//  TrackersViewControllers.swift
//  Tracker
//
//  Created by Admin on 09.01.2024.
//

import UIKit

class TrackersViewController: UIViewController {

    var isTrackers: Bool = false
    
    lazy var errorTrackersLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "errorTrackersLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var errorTrackersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.font = .YPMedium12
        return label
    }()
    
    lazy var errorLogoStackView: UIStackView = {
        let vStackView = UIStackView(arrangedSubviews: [errorTrackersLogo, errorTrackersLabel])
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.axis = .vertical
        vStackView.spacing = 8
        return vStackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

        addNavButton()
        addErrorLogo (isTrackers: isTrackers)
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
//        searchController.searchResultsUpdater = self
    }
    
    private func addNavButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        self.navigationItem.leftBarButtonItem = addButton
        addButton.tintColor = .ypBlack
    }
    
    @objc func addButtonTapped() {
        print("+")
    }

    func addErrorLogo (isTrackers: Bool) {
        if !isTrackers {
            view.addSubview(errorLogoStackView)
            setupLayout()
        }
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            errorLogoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLogoStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        )
    }
    
}

//extension TrackersViewController: UISearchResultsUpdating  {
//    func updateSearchResults(for searchController: UISearchController) {
//      }
//
//}

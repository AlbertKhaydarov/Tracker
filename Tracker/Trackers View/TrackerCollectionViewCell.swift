//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 11.01.2024.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    static let trackerCellIdentifier = String(describing: TrackerCollectionViewCell.self)
    
    lazy var trackerBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    lazy var trackerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .ypMedium12
        label.textColor = .ypWhite
        return label
    }()
    
    lazy var emojiBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = .ypWhite.withAlphaComponent(0.3)
        return view
    }()
    
    lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .ypMedium12
        return label
    }()
    
    private var quantityCompletedTrackers = 0
    
    lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .ypMedium12
        label.textColor = .ypBlack
        label.text = "\(quantityCompletedTrackers) дней"
        return label
    }()
    
    lazy var addQuantityButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .ypWhite
//        button.backgroundColor = .ypBackground
        button.layer.cornerRadius = 17
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addQuantityButtonTapped), for: .touchUpInside)
        return button
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func addQuantityButtonTapped() {
        print("addQuantityButtonTapped")
        addQuantityButtonSetImage(isTrackerCompleted: true)
        quantityCompletedTrackers += 1
        quantityLabel.text = "\(quantityCompletedTrackers) дней"
//        guard let trackerId = trackerId, let indexPath = indexPath else { return }
//        if isCompletedToday {
//            delegate?.uncompletedTracker(id: trackerId, at: indexPath)
//        } else {
//            delegate?.completedTracker(id: trackerId, at: indexPath)
//        }
    }
    
    func addQuantityButtonSetImage(isTrackerCompleted: Bool) {
        guard let image: UIImage = (isTrackerCompleted ? UIImage(named: "trackerCompleted") : UIImage(systemName: "plus")) else {return}
        addQuantityButton.setImage(image, for: .normal)
        addQuantityButton.layer.opacity = isTrackerCompleted ? 0.3 : 1
    }
    
    private func setupCell() {
        self.backgroundColor = .clear
        contentView.addSubview(trackerBackgroundView)
        trackerBackgroundView.addSubview(emojiBackgroundView)
        trackerBackgroundView.addSubview(trackerLabel)
        emojiBackgroundView.addSubview(emojiLabel)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(addQuantityButton)
    }
    
    private func setupCellLayout() {
        NSLayoutConstraint.activate([
            trackerBackgroundView.heightAnchor.constraint(equalToConstant: contentView.frame.width * 90/167),
            trackerBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emojiBackgroundView.leadingAnchor.constraint(equalTo: trackerBackgroundView.leadingAnchor, constant: 12),
            emojiBackgroundView.topAnchor.constraint(equalTo: trackerBackgroundView.topAnchor, constant: 12),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: 24),
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: 24),
          
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
//            emojiLabel.widthAnchor.constraint(equalToConstant: 16),
//            emojiLabel.heightAnchor.constraint(equalToConstant: 16),
            
            trackerLabel.leadingAnchor.constraint(equalTo: trackerBackgroundView.leadingAnchor, constant: 12),
            trackerLabel.trailingAnchor.constraint(equalTo: trackerBackgroundView.trailingAnchor, constant: -12),
            trackerLabel.bottomAnchor.constraint(equalTo: trackerBackgroundView.bottomAnchor, constant: -12),
            
            quantityLabel.topAnchor.constraint(equalTo: trackerBackgroundView.bottomAnchor, constant: 16),
            quantityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
            addQuantityButton.topAnchor.constraint(equalTo: trackerBackgroundView.bottomAnchor, constant: 8),
            addQuantityButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -12),
            addQuantityButton.heightAnchor.constraint(equalToConstant: 34),
            addQuantityButton.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
    
}

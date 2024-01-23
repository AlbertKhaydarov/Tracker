//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 11.01.2024.
//

import UIKit


final class TrackerCollectionViewCell: UICollectionViewCell {
    static let trackerCellIdentifier = String(describing: TrackerCollectionViewCell.self)
    weak var delegate: TrackerCollectionViewCellDelegate?
    
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
        return label
    }()
    
    lazy var setQuantityButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .ypWhite
//        button.backgroundColor = .ypBackground
        button.layer.cornerRadius = 17
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(quantityButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    private var isTrackerCompleted: Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurationCell(_ trackerItem: TrackerModel, completedDays: Int, indexPath: IndexPath, isTrackerCompleted: Bool?) {
        trackerLabel.text = trackerItem.name
        emojiLabel.text = trackerItem.emoji
        setQuantityButton.backgroundColor = trackerItem.color
        trackerBackgroundView.backgroundColor = trackerItem.color
        quantityLabel.text = "\(completedDays)"
        self.isTrackerCompleted = isTrackerCompleted
        self.trackerId = trackerItem.id
        self.indexPath = indexPath
//        self.isTrackerCompleted = isTrackerCompleted
      
        guard let isTrackerCompleted else {return}
        quantityButtonSetImage(isTrackerCompleted: isTrackerCompleted)
    }
    
    @objc
    private func quantityButtonTapped() {
//        guard let isTrackerCompleted else {return}
//        addQuantityButtonSetImage(isTrackerCompleted: isTrackerCompleted)

        guard let trackerId,
              let indexPath,
              let isTrackerCompleted
        else {return}
        
        delegate?.markCompletedTracker(id: trackerId, indexPath: indexPath, isCompleted: isTrackerCompleted)
    }
    let vc = TrackersViewController()
    
    func quantityButtonSetImage(isTrackerCompleted: Bool) {
        guard let image: UIImage = (isTrackerCompleted ? UIImage(named: "trackerCompleted") : UIImage(systemName: "plus")) else {return}
        setQuantityButton.setImage(image, for: .normal)
        setQuantityButton.layer.opacity = isTrackerCompleted ? 0.3 : 1
    }
    
    private func setupCell() {
        self.backgroundColor = .clear
        contentView.addSubview(trackerBackgroundView)
        trackerBackgroundView.addSubview(emojiBackgroundView)
        trackerBackgroundView.addSubview(trackerLabel)
        emojiBackgroundView.addSubview(emojiLabel)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(setQuantityButton)
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
            
            setQuantityButton.topAnchor.constraint(equalTo: trackerBackgroundView.bottomAnchor, constant: 8),
            setQuantityButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -12),
            setQuantityButton.heightAnchor.constraint(equalToConstant: 34),
            setQuantityButton.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
    
}

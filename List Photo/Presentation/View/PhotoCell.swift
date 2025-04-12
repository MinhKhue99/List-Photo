//
//  PhotoCell.swift
//  List Photo
//
//  Created by KhuePM on 12/4/25.
//

import UIKit

class PhotoCell: UITableViewCell {
    static let identifier = "PhotoCell"
    private var imageLoadTask: URLSessionDataTask?

    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    let sizeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(photoImageView)
        contentView.addSubview(stackView)

        stackView.addArrangedSubview(authorLabel)
        stackView.addArrangedSubview(sizeLabel)

        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: 0.6),

            stackView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateAppearance()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel()
        imageLoadTask = nil
        photoImageView.image = nil
        authorLabel.text = nil
    }

    private func updateAppearance() {
        if let textColor = UIColor(named: "TextColor") {
            authorLabel.textColor = textColor
            sizeLabel.textColor = textColor
        } else {
            authorLabel.textColor = .black
            sizeLabel.textColor = .black
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with photo: Photo) {
        authorLabel.text = photo.author
        sizeLabel.text = "Size: \(photo.width)×\(photo.height)"
        imageLoadTask?.cancel()
        photoImageView.image = nil

        if let url = URL(string: photo.downloadURL) {
            imageLoadTask = ImageLoader.shared.loadImage(from: url) { [weak self] image in
                self?.photoImageView.image = image
            }
        } else {
            photoImageView.image = UIImage(named: "placeholder")
        }
    }
}


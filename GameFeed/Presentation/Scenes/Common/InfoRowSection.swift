//
//  InfoRow.swift
//  GameFeed
//
//  Created by Macintosh on 21/09/25.
//  Copyright © 2025 Dicoding Indonesia. All rights reserved.
//

import UIKit

class InfoRowSection: UIStackView {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let showMoreButton = UIButton(type: .system)

    private var isExpanded = false

    init(title: String, value: String) {
        super.init(frame: .zero)
        axis = .vertical
        alignment = .leading
        spacing = 8

        titleLabel.text = "\(title)"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)

        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 16)
        valueLabel.numberOfLines = 3

        showMoreButton.setTitle("Show more", for: .normal)
        showMoreButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        showMoreButton.setTitleColor(.secondaryLabel, for: .normal)
        showMoreButton.addTarget(self, action: #selector(toggleShowMore), for: .touchUpInside)

        addArrangedSubview(titleLabel)
        addArrangedSubview(valueLabel)
        addArrangedSubview(showMoreButton)

        checkIfTruncated()
    }

    @objc private func toggleShowMore() {
        isExpanded.toggle()
        if isExpanded {
            valueLabel.numberOfLines = 0
            showMoreButton.setTitle("Show less", for: .normal)
        } else {
            valueLabel.numberOfLines = 3
            showMoreButton.setTitle("Show more", for: .normal)
        }
    }

    private func checkIfTruncated() {
        guard let text = valueLabel.text else { return }

        // Max size for label with 3 lines
        let maxSize = CGSize(width: UIScreen.main.bounds.width - 32, height: .greatestFiniteMagnitude)
        let attributes: [NSAttributedString.Key: Any] = [.font: valueLabel.font ?? .systemFont(ofSize: 16)]
        let textHeight = (text as NSString).boundingRect(
            with: maxSize,
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        ).height

        let lineHeight = valueLabel.font.lineHeight
        let threeLineHeight = lineHeight * 3

        // Show button only if text exceeds 3 lines
        showMoreButton.isHidden = textHeight <= threeLineHeight
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

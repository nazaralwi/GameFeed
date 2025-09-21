import UIKit

public final class GameTableViewCell: UITableViewCell {
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let photoGame: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    let ratingGame: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = .systemBlue
        label.textAlignment = .center
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    let titleGame: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()

    let releaseGameStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    let releaseGameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = "Released:"
        label.textColor = .secondaryLabel
        return label
    }()
    let releaseGame: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()

    let genresGameStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    let genresGameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.text = "Genres:"
        label.textColor = .secondaryLabel
        return label
    }()
    let genreGame: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(containerView)

        [releaseGameLabel, UIView(), releaseGame].forEach {
            releaseGameStack.addArrangedSubview($0)
        }

        [genresGameLabel, UIView(), genreGame].forEach {
            genresGameStack.addArrangedSubview($0)
        }

        [photoGame, ratingGame, titleGame,
         releaseGameStack, genresGameStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }

        releaseGameStack.setContentHuggingPriority(.required, for: .vertical)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            photoGame.topAnchor.constraint(equalTo: containerView.topAnchor),
            photoGame.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            photoGame.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            photoGame.heightAnchor.constraint(equalToConstant: 200),

            ratingGame.trailingAnchor.constraint(equalTo: photoGame.trailingAnchor, constant: -12),
            ratingGame.bottomAnchor.constraint(equalTo: photoGame.bottomAnchor, constant: -12),
            ratingGame.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            ratingGame.heightAnchor.constraint(equalToConstant: 32),

            titleGame.topAnchor.constraint(equalTo: photoGame.bottomAnchor, constant: 12),
            titleGame.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleGame.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),

            releaseGameStack.topAnchor.constraint(equalTo: titleGame.bottomAnchor, constant: 8),
            releaseGameStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            releaseGameStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),

            genresGameStack.topAnchor.constraint(equalTo: releaseGameStack.bottomAnchor, constant: 8),
            genresGameStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            genresGameStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            genresGameStack.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -24)
        ])
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
}

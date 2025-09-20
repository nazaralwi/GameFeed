import UIKit

final class DetailGameViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    // Container for non image information
    private let textInformationStack = UIStackView()

    private let photoGameDetail: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return imageView
    }()

    private let titleGameDetail: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        return label
    }()
    private let ratingGameDetail = UILabel()
    private let overviewGameDetail: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    private let platformGameDetail: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    private let releaseGameDetail = UILabel()
    private let genreGameDetail = UILabel()
    private let publisherGameDetail = UILabel()
    private let metacriticGameDetail = UILabel()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var addToFavoriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "heart"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(addToFavoriteSelector))
        return button
    }()

    public var viewModel: DetailViewModel?
    public var game: GameUIModel?

    private var didShownTitle = false
    private var defaultTitle = ""

    private var animateUp: CATransition = {
        let animation = CATransition()
        animation.duration = 0.5
        animation.type = .push
        animation.subtype = .fromTop
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return animation
    }()

    private var animateDown: CATransition = {
        let animation = CATransition()
        animation.duration = 0.5
        animation.type = .push
        animation.subtype = .fromBottom
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return animation
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = addToFavoriteButton

        setupScrollView()

        scrollView.delegate = self
        viewModel?.delegate = self

        let titleLabelView = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        titleLabelView.textAlignment = .center
        titleLabelView.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabelView.text = defaultTitle
        navigationItem.titleView = titleLabelView

        viewModel?.fetchGameDetail(idGame: game?.idGame ?? 0)
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        scrollView.addSubview(contentView)
        contentView.axis = .vertical
        contentView.spacing = 12
        contentView.alignment = .fill
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }

    private func setupLayout(game: GameUIModel) {
        // Photo
        let photoContainer = UIView()
        photoContainer.addSubview(photoGameDetail)
        photoGameDetail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoGameDetail.topAnchor.constraint(equalTo: photoContainer.topAnchor),
            photoGameDetail.leadingAnchor.constraint(equalTo: photoContainer.leadingAnchor),
            photoGameDetail.trailingAnchor.constraint(equalTo: photoContainer.trailingAnchor),
            photoGameDetail.heightAnchor.constraint(equalTo: photoGameDetail.widthAnchor, multiplier: 9.0/16.0),
            photoGameDetail.bottomAnchor.constraint(equalTo: photoContainer.bottomAnchor)
        ])

        contentView.addArrangedSubview(photoContainer)

        // Group Title + Rating
        let titleRatingStack = UIStackView(arrangedSubviews: [titleGameDetail, UIView(), ratingGameDetail])
        titleRatingStack.axis = .horizontal
        titleRatingStack.alignment = .center
        titleRatingStack.distribution = .fill

        textInformationStack.addArrangedSubview(titleRatingStack)

        // Activity indicator
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        titleGameDetail.text = game.name
        ratingGameDetail.text = "⭐️ " + game.rating

        if let downloadedImage = game.downloadedBackgroundImage {
            photoGameDetail.image = downloadedImage
        } else {
            photoGameDetail.image = UIImage(systemName: "photo")
        }

        let overviewRow = InfoRowSection(title: "Overview", value: game.description)
        let publisherRow = InfoRowSection(title: "Publisher", value: game.publishers)
        let platformRow = InfoRowSection(title: "Platforms", value: game.platforms)
        let genreRow = InfoRowSection(title: "Genres", value: game.genres)
        let releaseRow = InfoRowSection(title: "Released", value: game.released)
        let metacriticRow = InfoRowSection(title: "Metacritic", value: String(game.metacritic))

        textInformationStack.axis = .vertical
        textInformationStack.alignment = .fill
        textInformationStack.spacing = 12

        [overviewRow, publisherRow, platformRow, genreRow, releaseRow, metacriticRow].forEach {
            textInformationStack.addArrangedSubview($0)
        }

        let textContainer = UIView()
        textContainer.addSubview(textInformationStack)
        textInformationStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textInformationStack.topAnchor.constraint(equalTo: textContainer.topAnchor),
            textInformationStack.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor, constant: 16),
            textInformationStack.trailingAnchor.constraint(equalTo: textContainer.trailingAnchor, constant: -16),
            textInformationStack.bottomAnchor.constraint(equalTo: textContainer.bottomAnchor)
        ])

        contentView.addArrangedSubview(textContainer)

        // Margin textInformationStack
        NSLayoutConstraint.activate([
            textInformationStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textInformationStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

    }

    @objc private func addToFavoriteSelector(_ sender: Any) {
        viewModel?.updateFavoriteState(for: game?.idGame ?? 0)
    }

    private func deleteFromFavorite() {
        viewModel?.deleteGameFavorite(game?.idGame ?? 0)
    }

    private func addGameToFavorite() {
        if let game = game {
            viewModel?.addGameToFavorite(game)
        }
    }
}

extension DetailGameViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let titleInFrameView = titleGameDetail.convert(titleGameDetail.bounds, to: self.view)

        let navbarBottomY = view.safeAreaInsets.top

        if titleInFrameView.minY <= navbarBottomY && !didShownTitle {
            if let label = navigationItem.titleView as? UILabel {
                label.layer.add(animateUp, forKey: "changeTitle")
                label.text = titleGameDetail.text
            }
            didShownTitle = true
        } else if titleInFrameView.minY > navbarBottomY && didShownTitle {
            if let label = navigationItem.titleView as? UILabel {
                label.layer.add(animateDown, forKey: "changeTitle")
                label.text = defaultTitle
            }
            didShownTitle = false
        }
    }
}

extension DetailGameViewController: DetailViewModelDelegate {
    func didLoadDetailGame(game: GameUIModel) {
        setupLayout(game: game)
        self.game = game
    }

    func didFetchFavoriteState(isFavorite: Bool) {
        if isFavorite {
            addToFavoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            addToFavoriteButton.image = UIImage(systemName: "heart")
        }
    }

    func didUpdateFavoriteState(isFavorite: Bool) {
        if isFavorite {
            addGameToFavorite()
            addToFavoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            deleteFromFavorite()
            addToFavoriteButton.image = UIImage(systemName: "heart")
        }
    }

    func didUpdateLoadingIndicator(isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            addToFavoriteButton.isEnabled = false
        } else {
            self.activityIndicator.stopAnimating()
            self.addToFavoriteButton.isEnabled = true
        }
    }

    func didReceivedError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}

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

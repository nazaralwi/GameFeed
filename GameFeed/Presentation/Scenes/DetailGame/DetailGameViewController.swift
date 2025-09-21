import UIKit

final class DetailGameViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()

    private let photoGameDetail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
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

    private lazy var titleRatingStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            self.titleGameDetail,
            UIView(),
            self.ratingGameDetail
        ])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()

    private let informationStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 12
        return stack
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.style = .large
        return indicator
    }()

    private lazy var addToFavoriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(addToFavoriteSelector)
        )
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

    private func setupView(with game: GameUIModel) {
        // Photo
        let photoContainer = UIView()
        photoContainer.addSubview(photoGameDetail)

        contentView.addArrangedSubview(photoContainer)

        informationStack.addArrangedSubview(titleRatingStack)

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

        [overviewRow, publisherRow, platformRow, genreRow, releaseRow, metacriticRow].forEach {
            informationStack.addArrangedSubview($0)
        }

        let textContainer = UIView()
        textContainer.addSubview(informationStack)

        NSLayoutConstraint.activate([
            photoGameDetail.topAnchor.constraint(equalTo: photoContainer.topAnchor),
            photoGameDetail.leadingAnchor.constraint(equalTo: photoContainer.leadingAnchor),
            photoGameDetail.trailingAnchor.constraint(equalTo: photoContainer.trailingAnchor),
            photoGameDetail.heightAnchor.constraint(equalTo: photoGameDetail.widthAnchor, multiplier: 9.0/16.0),
            photoGameDetail.bottomAnchor.constraint(equalTo: photoContainer.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            informationStack.topAnchor.constraint(equalTo: textContainer.topAnchor),
            informationStack.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor, constant: 16),
            informationStack.trailingAnchor.constraint(equalTo: textContainer.trailingAnchor, constant: -16),
            informationStack.bottomAnchor.constraint(equalTo: textContainer.bottomAnchor)
        ])

        contentView.addArrangedSubview(textContainer)

        // Margin textInformationStack
        NSLayoutConstraint.activate([
            informationStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            informationStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        // Activity indicator
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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
        setupView(with: game)
        self.game = game
    }

    func didFetchFavoriteState(isFavorite: Bool) {
        addToFavoriteButton.image = isFavorite
            ? UIImage(systemName: "heart.fill")
            : UIImage(systemName: "heart")
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

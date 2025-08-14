import Foundation

class Formatter {
    class func formatGenre(from genresFromAPI: [GenreResponse]?) -> String {
        guard let genresFromAPI = genresFromAPI else { return "-" }

        if !genresFromAPI.isEmpty {
            var genres = [String]()
            for genre in genresFromAPI {
                let genreName = genre.name
                genres.append(genreName)
            }

            return genres.joined(separator: ", ")
        } else {
            return "-"
        }
    }

    class func formatImagePath(from imagePath: String?) -> String {
        guard let path = imagePath?.trimmingCharacters(in: .whitespacesAndNewlines),
           !path.isEmpty,
           let url = URL(string: path),
           let scheme = url.scheme?.lowercased(),
           scheme == "http" || scheme == "https",
           url.host != nil else { return "broken_image" }

        return path
    }

    class func formatDate(from dateString: String?) -> String {
        guard let dateFromAPI = dateString else { return "-" }

        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"

        if let date = dateFormatterGet.date(from: dateFromAPI) {
            return dateFormatterPrint.string(from: date)
        } else {
            return "-"
        }
    }

    class func formatDate(from dateObject: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let dateString = dateFormatter.string(from: dateObject)

        return dateString
    }

    class func formatPlatform(from platformsFromAPI: [PlatformsResponse]?) -> String {
        guard let platformsFromAPI = platformsFromAPI else { return "-" }

        if !platformsFromAPI.isEmpty {
            var platforms = [String]()
            for platform in platformsFromAPI {
                let platformName = platform.platform.name
                platforms.append(platformName)
            }

            return platforms.joined(separator: ", ")
        } else {
            return "-"
        }
    }

    class func formatPublisher(from publishersFromAPI: [PublisherResponse]?) -> String {
        guard let publishersFromAPI = publishersFromAPI else { return "-" }

        if !publishersFromAPI.isEmpty {
            var publishers = [String]()
            for publisher in publishersFromAPI {
                let publisherName = publisher.name
                publishers.append(publisherName)
            }

            return publishers.joined(separator: ", ")
        } else {
            return "-"
        }
    }
}

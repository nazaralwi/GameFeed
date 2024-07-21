import Foundation

class Formatter {
    class func formatGenre(from genresFromAPI: [GenreResponse]) -> String {
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

    class func formatDate(from dateFromAPI: String?) -> String {
        guard let dateFromAPI = dateFromAPI else { return "-" }
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

    class func formatDateToString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let dateString = dateFormatter.string(from: date)

        return dateString
    }

    class func formatPlatform(from platformsFromAPI: [PlatformsResponse]) -> String {
        if !platformsFromAPI.isEmpty {
            var platforms = [String]()
            for platform in platformsFromAPI {
                let platformName = platform.platform.name
                platforms.append(platformName)
            }

            return platforms.joined(separator: ", ")
        } else {
            return "Platform Not Found"
        }
    }

    class func formatPublisher(from publishersFromAPI: [PublisherResponse]) -> String {
        if !publishersFromAPI.isEmpty {
            var publishers = [String]()
            for publisher in publishersFromAPI {
                let publisherName = publisher.name
                publishers.append(publisherName)
            }

            return publishers.joined(separator: ", ")
        } else {
            return "Publisher Not Found"
        }
    }
}

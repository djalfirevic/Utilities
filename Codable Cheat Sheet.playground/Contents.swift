//: Playground - noun: a place where people can play

import UIKit

func simple() {
    struct User: Codable {
        var name: String
        var age: Int
    }
    
    let json = """
    [
        {
            "name": "Paul",
            "age": 38
        },
        {
            "name": "Andrew",
            "age": 40
        }
    ]
    """

    let data = Data(json.utf8)

    let decoder = JSONDecoder()

    do {
        let decoded = try decoder.decode([User].self, from: data)
        print(decoded[0].name)
    } catch {
        print("Failed to decode JSON")
    }
}

func snakeCase() {
    struct User: Codable {
        var firstName: String
        var lastName: String
    }
    
    let json = """
    [
        {
            "first_name": "Paul",
            "last_name": "Hudson"
        },
        {
            "first_name": "Andrew",
            "last_name": "Carnegie"
        }
    ]
    """

    let data = Data(json.utf8)
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    do {
        let decoded = try decoder.decode([User].self, from: data)
        print(decoded[0].firstName)
    } catch {
        print("Failed to decode JSON")
    }
}

func differentKeyNames() {
    struct User: Codable {
        var firstName: String
        var lastName: String
        var age: Int
        
        enum CodingKeys: String, CodingKey {
            case firstName = "user_first_name"
            case lastName = "user_last_name"
            case age
        }
    }
    
    let json = """
    [
        {
            "user_first_name": "Taylor",
            "user_last_name": "Swift"
            "user_age": 26
        }
    ]
    """

    let data = Data(json.utf8)
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    do {
        let decoded = try decoder.decode([User].self, from: data)
        print(decoded[0].firstName)
    } catch {
        print("Failed to decode JSON")
    }
}

func isoDates() {
    struct Baby: Codable {
        var firstName: String
        var timeOfBirth: Date
    }
    
    let json = """
    [
        {
            "first_name": "Theo",
            "time_of_birth": "1999-04-03T17:30:31Z"
        }
    ]
    """

    let data = Data(json.utf8)
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601
    
    do {
        let decoded = try decoder.decode([Baby].self, from: data)
        print(decoded[0].timeOfBirth)
    } catch {
        print("Failed to decode JSON")
    }
}

func customDates() {
    struct User: Codable {
        var firstName: String
        var graduationDate: Date
    }
    
    let json = """
    [
        {
            "first_name": "Jess",
            "graduation_day": "31-08-2001"
        }
    ]
    """

    let data = Data(json.utf8)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .formatted(formatter)
    
    do {
        let decoded = try decoder.decode([User].self, from: data)
        print(decoded[0].graduationDate)
    } catch {
        print("Failed to decode JSON")
    }
}

func weirdDates() {
    struct User: Codable {
        var firstName: String
        var graduationDate: Date
    }
    
    let json = """
    [
        {
            "first_name": "Jess",
            "graduation_day": 10650
        }
    ]
    """

    let data = Data(json.utf8)

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .custom { decoder in
        // pull out the number of days from Codable
        let container = try decoder.singleValueContainer()
        let numberOfDays = try container.decode(Int.self)

        // create a start date of Jan 1st 1970, then a DateComponents instance for our JSON days
        let startDate = Date(timeIntervalSince1970: 0)
        var components = DateComponents()
        components.day = numberOfDays

        // create a Calendar and use it to measure the difference between the two
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(byAdding: components, to: startDate) ?? Date()
    }
    
    do {
        let decoded = try decoder.decode([User].self, from: data)
        print(decoded[0].graduationDate)
    } catch {
        print("Failed to decode JSON")
    }
}

func hierarchicalData() {
    struct User: Codable {
        struct Name: Codable {
            var firstName: String
            var lastName: String
        }

        var name: Name
        var age: Int
    }
    
    let json = """
    [
        {
            "name": {
                "first_name": "Taylor",
                "last_name": "Swift"
            },
            "age": 26
        }
    ]
    """

    let data = Data(json.utf8)

    let decoder = JSONDecoder()

    do {
        let decoded = try decoder.decode([User].self, from: data)
        print(decoded[0].name)
    } catch {
        print("Failed to decode JSON")
    }
}

func hierarchicalDataTheHardWay() {
    struct User: Codable {
        var firstName: String
        var lastName: String
        var age: Int
        
        enum CodingKeys: String, CodingKey {
            case name, age
        }
        
        enum NameCodingKeys: String, CodingKey {
            case firstName, lastName
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            age = try container.decode(Int.self, forKey: .age)
            
            let name = try container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
            firstName = try name.decode(String.self, forKey: .firstName)
            lastName = try name.decode(String.self, forKey: .lastName)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(age, forKey: .age)

            var name = container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
            try name.encode(firstName, forKey: .firstName)
            try name.encode(lastName, forKey: .lastName)
        }
    }
    
    let json = """
    [
        {
            "name": {
                "first_name": "Taylor",
                "last_name": "Swift"
            },
            "age": 26
        }
    ]
    """

    let data = Data(json.utf8)

    let decoder = JSONDecoder()

    do {
        let decoded = try decoder.decode([User].self, from: data)
        print(decoded[0].firstName)
    } catch {
        print("Failed to decode JSON")
    }
}

simple()
snakeCase()
differentKeyNames()
isoDates()
customDates()
weirdDates()
hierarchicalData()
hierarchicalDataTheHardWay()

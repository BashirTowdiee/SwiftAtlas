import Foundation

struct PostDTO: Codable, Sendable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct UserDTO: Codable, Sendable {
    struct CompanyDTO: Codable, Sendable {
        let name: String
        let catchPhrase: String
        let bs: String
    }

    let id: Int
    let name: String
    let username: String
    let email: String
    let company: CompanyDTO
}

struct TodoDTO: Codable, Sendable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}

struct CommentDTO: Codable, Sendable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
}

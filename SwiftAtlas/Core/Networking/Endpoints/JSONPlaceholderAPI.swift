import Foundation

enum JSONPlaceholderAPI {
  static func posts() -> APIRequest<[PostDTO]> {
    APIRequest(path: "/posts")
  }

  static func post(id: Int) -> APIRequest<PostDTO> {
    APIRequest(path: "/posts/\(id)")
  }

  static func users() -> APIRequest<[UserDTO]> {
    APIRequest(path: "/users")
  }

  static func user(id: Int) -> APIRequest<UserDTO> {
    APIRequest(path: "/users/\(id)")
  }

  static func comments(postID: Int) -> APIRequest<[CommentDTO]> {
    APIRequest(path: "/comments", queryItems: [URLQueryItem(name: "postId", value: "\(postID)")])
  }

  static func todos() -> APIRequest<[TodoDTO]> {
    APIRequest(path: "/todos")
  }
}

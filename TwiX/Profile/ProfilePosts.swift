//
//  ProfilePosts.swift
//  TwiX
//
//  Created by Tsvetkov Alexey on 12/9/24.
//

import UIKit

extension ProfileController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segmentedControl.selectedSegmentIndex == 0 ? posts.count : likes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self), for: indexPath) as! PostTableViewCell
        let post = segmentedControl.selectedSegmentIndex == 0 ? posts[indexPath.row] : likes[indexPath.row]
        
        cell.configure(with: post) {
            let post = self.posts[indexPath.row]
            PostManager.shared.likePost(post.id)
            var updatedPost = post
            updatedPost.likesCount += 1
            self.posts[indexPath.row] = updatedPost
            
            if let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell {
                cell.updateLikesCount(updatedPost.likesCount)
            }
        }
        cell.backgroundColor = Colors.backgroundColor
        return cell
    }
}

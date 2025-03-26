//
//  BookViewDeleagate.swift
//  project-book-series
//
//  Created by 유영웅 on 3/26/25.
//

import Foundation

protocol BookViewDeleagate:AnyObject{
    func didSetEpisodeButton(_ button:UIEpisodeButton) -> UIEpisodeButton
}

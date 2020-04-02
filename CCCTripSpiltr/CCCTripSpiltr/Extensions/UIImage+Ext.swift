//
//  UIImage+Ext.swift
//  CCCTripSpiltr
//
//  Created by jonathan ferrer on 4/1/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit


extension UIImage {
    
    

      func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {

          guard let url = URL(string: urlString) else {
              completed(nil)
              return
          }
          
          let task = URLSession.shared.dataTask(with: url) { data, response, error in
              
              guard  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                      completed(nil)
                      return
                  }
              
              completed(image)
          }
          
          task.resume()
      }
    
}

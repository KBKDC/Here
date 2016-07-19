//
//  MainViewController.swift
//  Here
//
//  Created by 角井勇哉 on 2016/07/19.
//  Copyright © 2016年 YuyaKakui. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class MainViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var userProfile: NSDictionary!
    
    @IBAction func logout(sender: AnyObject) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        returnUserData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func returnUserData() {
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(
            graphPath: "me",
            parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]
        )
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if (error) != nil {
                // エラー処理
                print("Error: \(error)")
            } else {
                // プロフィール情報をディクショナリに入れる
                self.userProfile = result as! NSDictionary
                print(self.userProfile)
                
                // プロフィール画像の取得（よくあるように角を丸くする）
                let profileImageURL: String = self.userProfile.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String
                let profileImage = UIImage(data: NSData(contentsOfURL: NSURL(string: profileImageURL)!)!)
                self.userImage.clipsToBounds = true
                self.userImage.layer.cornerRadius = 60
                self.userImage.image = self.trimPicture(profileImage!)
                
                self.userName.text = self.userProfile.objectForKey("name") as? String
                self.userEmail.text = self.userProfile .objectForKey("email") as? String
            }
        })
    }
    
    func trimPicture(rawPic: UIImage) -> UIImage {
        let rawImageW = rawPic.size.width
        let rawImageH = rawPic.size.height
        
        let posX = (rawImageW - 200) / 2
        let posY = (rawImageH - 200) / 2
        let trimArea: CGRect = CGRectMake(posX, posY, 200, 200)
        
        let rawImageRef: CGImageRef = rawPic.CGImage!
        let trimmedImageRef = CGImageCreateWithImageInRect(rawImageRef, trimArea)
        let trimmedImage: UIImage = UIImage(CGImage: trimmedImageRef!)
        return trimmedImage
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

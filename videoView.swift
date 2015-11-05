//
//  videoView.swift
//  Live_reporting
//
//  Created by user on 5/11/15.
//  Copyright © 2015 LiveReporting. All rights reserved.
//

import UIKit
import MediaPlayer

class videoView: UIViewController {

    
    @IBOutlet weak var vwVideo: UIView!
        var moviePlayer:MPMoviePlayerController! = MPMoviePlayerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let url:NSURL = NSURL(string: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")!
        
        let url:NSURL = NSURL(string: "http://files.parsetfss.com/f4a09e86-6d45-4841-b3f7-0e983178a5d6/tfss-32d732a7-f1f0-40a7-9847-d615f9a0ad6c-chelseaSong.mp4")!
        moviePlayer = MPMoviePlayerController(contentURL: url)
        
        
        
        moviePlayer.view.frame = self.vwVideo.frame
        
        
       self.view.addSubview(moviePlayer.view)
        
        moviePlayer.controlStyle = MPMovieControlStyle.Embedded
       
        moviePlayer.prepareToPlay()
        moviePlayer.play()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}

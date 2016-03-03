//
//  NKSound.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 04/01/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import AVFoundation

class NKSound: Equatable {
    let fileName: String
#if os(OSX)
    let sound: NSSound?
#else
    let player: AVAudioPlayer!
#endif

    init(named: String) {
        fileName = named

        #if os(OSX)
            sound = NSSound(named: named)
        #else
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            } catch _ {
                Log.e("Failed making audio ambient")
            }

            let bundle = NSBundle.mainBundle()
            let path = bundle.pathForResource(named, ofType: "aif") ?? bundle.pathForResource(named, ofType: "wav")
            let data = NSData(contentsOfFile: path!)

            player = try! AVAudioPlayer(data: data!)
            player.prepareToPlay()
        #endif
    }


    var volume: Float = 1 {
        didSet {
            #if os(OSX)
                sound?.volume = volume
            #else
                player.volume = volume
            #endif
        }
    }

    var loops: Bool = false {
        didSet {
            #if os(OSX)
                sound?.loops = loops
            #else
                player.numberOfLoops = -1
            #endif
        }
    }

    func play() {
        #if os(OSX)
            sound?.play()
        #else
            player.play()
        #endif
    }

    func stop() {
        #if os(OSX)
            sound?.stop()
        #else
            player.stop()
        #endif
    }

}


func ==(lhs: NKSound, rhs: NKSound) -> Bool {
    return lhs.fileName == rhs.fileName
}

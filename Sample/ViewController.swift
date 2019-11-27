//
//  ViewController.swift
//  Sample
//
//  Created by Corentin Larroque on 27/11/2019.
//  Copyright © 2019 Voxeet. All rights reserved.
//

import UIKit
import VoxeetSDK

class ViewController: UIViewController {
    // Session UI.
    var sessionTextField: UITextField!
    var logInButton: UIButton!
    var logoutButton: UIButton!
    
    // Conference UI.
    var conferenceTextField: UITextField!
    var startButton: UIButton!
    var leaveButton: UIButton!
    var startVideoButton: UIButton!
    var stopVideoButton: UIButton!
    
    // Videos views.
    var videosView1: VTVideoView!
    var videosView2: VTVideoView!
    
    // Participant label.
    var participantsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSessionUI()
        initConferenceUI()
        
        // Conference delegate.
        VoxeetSDK.shared.conference.delegate = self
    }
    
    func initSessionUI() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        // Session text field.
        sessionTextField = UITextField(frame: CGRect(x: 8, y: statusBarHeight + 16, width: 84, height: 30))
        sessionTextField.borderStyle = .roundedRect
        sessionTextField.placeholder = "Username"
        sessionTextField.autocorrectionType = .no
        self.view.addSubview(sessionTextField)
        
        // Open session button.
        logInButton = UIButton(type: .system) as UIButton
        logInButton.frame = CGRect(x: 100, y: statusBarHeight + 16, width: 100, height: 30)
        logInButton.isEnabled = true
        logInButton.isSelected = true
        logInButton.setTitle("LOG IN", for: .normal)
        logInButton.addTarget(self, action: #selector(logInButtonAction), for: .touchUpInside)
        self.view.addSubview(logInButton)
        
        // Close session button.
        logoutButton = UIButton(type: .system) as UIButton
        logoutButton.frame = CGRect(x: 200, y: statusBarHeight + 16, width: 100, height: 30)
        logoutButton.isEnabled = false
        logoutButton.isSelected = true
        logoutButton.setTitle("LOGOUT", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
        self.view.addSubview(logoutButton)
    }
    
    func initConferenceUI() {
        // Session text field.
        conferenceTextField = UITextField(frame: CGRect(x: 8, y: sessionTextField.frame.origin.y + sessionTextField.frame.height + 16, width: 84, height: 30))
        conferenceTextField.borderStyle = .roundedRect
        conferenceTextField.placeholder = "Conference"
        conferenceTextField.autocorrectionType = .no
        self.view.addSubview(conferenceTextField)
        
        // Conference create/join button.
        startButton = UIButton(type: .system) as UIButton
        startButton.frame = CGRect(x: 100, y: sessionTextField.frame.origin.y + sessionTextField.frame.height + 16, width: 100, height: 30)
        startButton.isEnabled = false
        startButton.isSelected = true
        startButton.setTitle("START", for: .normal)
        startButton.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
        self.view.addSubview(startButton)
        
        // Conference leave button.
        leaveButton = UIButton(type: .system) as UIButton
        leaveButton.frame = CGRect(x: 200, y: sessionTextField.frame.origin.y + sessionTextField.frame.height + 16, width: 100, height: 30)
        leaveButton.isEnabled = false
        leaveButton.isSelected = true
        leaveButton.setTitle("LEAVE", for: .normal)
        leaveButton.addTarget(self, action: #selector(leaveButtonAction), for: .touchUpInside)
        self.view.addSubview(leaveButton)
        
        // Start video button.
        startVideoButton = UIButton(type: .system) as UIButton
        startVideoButton.frame = CGRect(x: 100, y: leaveButton.frame.origin.y + leaveButton.frame.height + 16, width: 100, height: 30)
        startVideoButton.isEnabled = false
        startVideoButton.isSelected = true
        startVideoButton.setTitle("START VIDEO", for: .normal)
        startVideoButton.addTarget(self, action: #selector(startVideoButtonAction), for: .touchUpInside)
        self.view.addSubview(startVideoButton)
        
        // Stop video button.
        stopVideoButton = UIButton(type: .system) as UIButton
        stopVideoButton.frame = CGRect(x: 200, y: leaveButton.frame.origin.y + leaveButton.frame.height + 16, width: 100, height: 30)
        stopVideoButton.isEnabled = false
        stopVideoButton.isSelected = true
        stopVideoButton.setTitle("STOP VIDEO", for: .normal)
        stopVideoButton.addTarget(self, action: #selector(stopVideoButtonAction), for: .touchUpInside)
        self.view.addSubview(stopVideoButton)
        
        // Video views.
        videosView1 = VTVideoView(frame: CGRect(x: 108, y: startVideoButton.frame.origin.y + startVideoButton.frame.height + 16, width: 84, height: 84))
        videosView1.backgroundColor = .black
        self.view.addSubview(videosView1)
        videosView2 = VTVideoView(frame: CGRect(x: 208, y: startVideoButton.frame.origin.y + startVideoButton.frame.height + 16, width: 84, height: 84))
        videosView2.backgroundColor = .black
        self.view.addSubview(videosView2)
        
        // Participants label.
        participantsLabel = UILabel(frame: CGRect(x: 100, y: videosView1.frame.origin.y + videosView1.frame.height + 16, width: 200, height: 30))
        participantsLabel.backgroundColor = .lightGray
        participantsLabel.adjustsFontSizeToFitWidth = true
        participantsLabel.minimumScaleFactor = 0.1
        self.view.addSubview(participantsLabel)
    }
    
    @objc func logInButtonAction(sender: UIButton!) {
        // Open user session.
        let user = VTUser(externalID: nil, name: sessionTextField.text, avatarURL: nil)
        VoxeetSDK.shared.session.connect(user: user) { error in
            self.logInButton.isEnabled = false
            self.logoutButton.isEnabled = true
            self.startButton.isEnabled = true
            self.leaveButton.isEnabled = false
        }
    }
    
    @objc func logoutButtonAction(sender: UIButton!) {
        // Close user session
        VoxeetSDK.shared.session.disconnect { error in
            self.logInButton.isEnabled = true
            self.logoutButton.isEnabled = false
            self.startButton.isEnabled = false
            self.leaveButton.isEnabled = false
        }
    }
    
    @objc func startButtonAction(sender: UIButton!) {
        // Create a conference room with an alias.
        let parameters = ["conferenceAlias": conferenceTextField.text ?? ""]
        VoxeetSDK.shared.conference.create(parameters: parameters, success: { response in
            guard let conferenceID = response?["conferenceId"] as? String else { return }
            
            // Join the conference with its id.
            VoxeetSDK.shared.conference.join(conferenceID: conferenceID, success: { response in
                self.logoutButton.isEnabled = false
                self.startButton.isEnabled = false
                self.leaveButton.isEnabled = true
                self.startVideoButton.isEnabled = true
                self.stopVideoButton.isEnabled = false
            }, fail: { error in })
        }, fail: { error in })
    }
    
    @objc func leaveButtonAction(sender: UIButton!) {
        VoxeetSDK.shared.conference.leave { error in
            self.logoutButton.isEnabled = true
            self.startButton.isEnabled = true
            self.leaveButton.isEnabled = false
            self.startVideoButton.isEnabled = false
            self.stopVideoButton.isEnabled = false
            self.participantsLabel.text = nil
        }
    }
    
    @objc func startVideoButtonAction(sender: UIButton!) {
        VoxeetSDK.shared.conference.startVideo { error in
            if error == nil {
                self.startVideoButton.isEnabled = false
                self.stopVideoButton.isEnabled = true
            }
        }
    }
    
    @objc func stopVideoButtonAction(sender: UIButton!) {
        VoxeetSDK.shared.conference.stopVideo { error in
            if error == nil {
                self.startVideoButton.isEnabled = true
                self.stopVideoButton.isEnabled = false
            }
        }
    }
}

extension ViewController: VTConferenceDelegate {
    func participantJoined(userID: String, stream: MediaStream) {
        participantUpdated(userID: userID, stream: stream)
    }
    
    func participantUpdated(userID: String, stream: MediaStream) {
        if userID == VoxeetSDK.shared.session.user?.id {
            if stream.videoTracks.isEmpty == false {
                videosView1.attach(userID: userID, stream: stream)
            } else {
                videosView1.unattach() /* Optional */
            }
        } else {
            if stream.videoTracks.isEmpty == false {
                videosView2.attach(userID: userID, stream: stream)
            } else {
                videosView2.unattach() /* Optional */
            }
        }
        
        // Update participants label.
        updateParticipantsLabel()
    }
    
    func participantLeft(userID: String) {
        updateParticipantsLabel()
    }
    
    func updateParticipantsLabel() {
        // Update participants label.
        var users = VoxeetSDK.shared.conference.users.filter({ $0.hasStream }) /* Gets only users with stream */
        if let sessionUser = VoxeetSDK.shared.session.user {
            users.append(sessionUser)
        }
        let usernames = users.map({ $0.name ?? "" })
        participantsLabel.text = usernames.joined(separator: ", ")
    }
    
    func screenShareStarted(userID: String, stream: MediaStream) {}
    func screenShareStopped(userID: String) {}
    func messageReceived(userID: String, message: String) {}
}

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
    var startScreenShareButton: UIButton!
    var stopScreenShareButton: UIButton!
    var startRecordingButton: UIButton!
    var stopRecordingButton: UIButton!
    
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
        
        // Start screen share button.
        startScreenShareButton = UIButton(type: .system) as UIButton
        startScreenShareButton.frame = CGRect(x: 100, y: participantsLabel.frame.origin.y + participantsLabel.frame.height + 16, width: 100, height: 30)
        startScreenShareButton.isEnabled = false
        startScreenShareButton.isSelected = true
        startScreenShareButton.setTitle("STARTSCREEN", for: .normal)
        startScreenShareButton.addTarget(self, action: #selector(startScreenShareAction), for: .touchUpInside)
        self.view.addSubview(startScreenShareButton)
        
        // Stop screen share button.
        stopScreenShareButton = UIButton(type: .system) as UIButton
        stopScreenShareButton.frame = CGRect(x: 200, y: participantsLabel.frame.origin.y + participantsLabel.frame.height + 16, width: 100, height: 30)
        stopScreenShareButton.isEnabled = false
        stopScreenShareButton.isSelected = true
        stopScreenShareButton.setTitle("STOPSCREEN", for: .normal)
        stopScreenShareButton.addTarget(self, action: #selector(stopScreenShareAction), for: .touchUpInside)
        self.view.addSubview(stopScreenShareButton)
        
        // Start recording button.
        startRecordingButton = UIButton(type: .system) as UIButton
        startRecordingButton.frame = CGRect(x: 100, y: stopScreenShareButton.frame.origin.y + stopScreenShareButton.frame.height + 16, width: 100, height: 30)
        startRecordingButton.isEnabled = false
        startRecordingButton.isSelected = true
        startRecordingButton.setTitle("START RECORD", for: .normal)
        startRecordingButton.addTarget(self, action: #selector(startRecordingAction), for: .touchUpInside)
        self.view.addSubview(startRecordingButton)
        
        // Stop recording button.
        stopRecordingButton = UIButton(type: .system) as UIButton
        stopRecordingButton.frame = CGRect(x: 200, y: stopScreenShareButton.frame.origin.y + stopScreenShareButton.frame.height + 16, width: 100, height: 30)
        stopRecordingButton.isEnabled = false
        stopRecordingButton.isSelected = true
        stopRecordingButton.setTitle("STOP RECORD", for: .normal)
        stopRecordingButton.addTarget(self, action: #selector(stopRecordingAction), for: .touchUpInside)
        self.view.addSubview(stopRecordingButton)
    }
    
    @objc func logInButtonAction(sender: UIButton!) {
        // Open user session.
        let info = VTParticipantInfo(externalID: nil, name: sessionTextField.text, avatarURL: nil)
        VoxeetSDK.shared.session.open(info: info) { error in
            self.logInButton.isEnabled = false
            self.logoutButton.isEnabled = true
            self.startButton.isEnabled = true
            self.leaveButton.isEnabled = false
        }
    }
    
    @objc func logoutButtonAction(sender: UIButton!) {
        // Close user session
        VoxeetSDK.shared.session.close { error in
            self.logInButton.isEnabled = true
            self.logoutButton.isEnabled = false
            self.startButton.isEnabled = false
            self.leaveButton.isEnabled = false
        }
    }
    
    @objc func startButtonAction(sender: UIButton!) {
        // Create a conference room with an alias.
        let options = VTConferenceOptions()
        options.alias = conferenceTextField.text ?? ""
        VoxeetSDK.shared.conference.create(options: options, success: { conference in
            // Join the conference with its id.
            VoxeetSDK.shared.conference.join(conference: conference, success: { response in
                self.logoutButton.isEnabled = false
                self.startButton.isEnabled = false
                self.leaveButton.isEnabled = true
                self.startVideoButton.isEnabled = true
                self.startScreenShareButton.isEnabled = true
                self.startRecordingButton.isEnabled = true
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
            self.startScreenShareButton.isEnabled = false
            self.stopScreenShareButton.isEnabled = false
            self.startRecordingButton.isEnabled = false
            self.stopRecordingButton.isEnabled = false
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
    
    @objc func startScreenShareAction(sender: UIButton!) {
        if #available(iOS 11.0, *) {
            VoxeetSDK.shared.conference.startScreenShare { error in
                if error == nil {
                    self.startScreenShareButton.isEnabled = false
                    self.stopScreenShareButton.isEnabled = true
                }
            }
        }
    }
    
    @objc func stopScreenShareAction(sender: UIButton!) {
        if #available(iOS 11.0, *) {
            VoxeetSDK.shared.conference.stopScreenShare { error in
                if error == nil {
                    self.startScreenShareButton.isEnabled = true
                    self.stopScreenShareButton.isEnabled = false
                }
            }
        }
    }
    
    @objc func startRecordingAction(sender: UIButton!) {
        VoxeetSDK.shared.recording.start { error in
            if error == nil {
                self.startRecordingButton.isEnabled = false
                self.stopRecordingButton.isEnabled = true
            }
        }
    }
    
    @objc func stopRecordingAction(sender: UIButton!) {
        VoxeetSDK.shared.recording.stop { error in
            if error == nil {
                self.startRecordingButton.isEnabled = true
                self.stopRecordingButton.isEnabled = false
            }
        }
    }
}

extension ViewController: VTConferenceDelegate {
    func statusUpdated(status: VTConferenceStatus) {}
    
    func streamAdded(participant: VTParticipant, stream: MediaStream) {
        streamUpdated(participant: participant, stream: stream)
    }
    
    func streamUpdated(participant: VTParticipant, stream: MediaStream) {
        switch stream.type {
        case .Camera:
            if participant.id == VoxeetSDK.shared.session.participant?.id {
                if !stream.videoTracks.isEmpty {
                    videosView1.attach(participant: participant, stream: stream)
                } else {
                    videosView1.unattach() /* Optional */
                }
            } else {
                if !stream.videoTracks.isEmpty {
                    videosView2.attach(participant: participant, stream: stream)
                } else {
                    videosView2.unattach() /* Optional */
                }
            }
        case .ScreenShare:
            if participant.id == VoxeetSDK.shared.session.participant?.id {
                if !stream.videoTracks.isEmpty {
                    videosView1.attach(participant: participant, stream: stream)
                }
            } else {
                if !stream.videoTracks.isEmpty {
                    videosView2.attach(participant: participant, stream: stream)
                }
            }
        default: break
        }
        
        // Update participants label.
        updateParticipantsLabel()
    }
    
    func streamRemoved(participant: VTParticipant, stream: MediaStream) {
        updateParticipantsLabel()
    }
    
    func updateParticipantsLabel() {
        // Update participants label.
        let participants = VoxeetSDK.shared.conference.current?.participants
            .filter({ $0.streams.isEmpty == false })
        let usernames = participants?.map({ $0.info.name ?? "" })
        participantsLabel.text = usernames?.joined(separator: ", ")
    }
}

//
//  ViewController.swift
//  Sample
//
//  Created by Corentin Larroque on 27/11/2019.
//  Copyright © 2019 Voxeet. All rights reserved.
//

import UIKit
import VoxeetSDK

class ViewController: UIViewController, UITextFieldDelegate {
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
    
    let margin: CGFloat = 16
    let buttonWidth: CGFloat = 120
    let buttonHeight: CGFloat = 35
    let textFieldWidth: CGFloat = 120 + 16 + 120
    let textFieldHeight: CGFloat = 40
    
    func initSessionUI() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height

        let avengersNames = [
            "Thor",
            "Cap",
            "Tony Stark",
            "Black Panther",
            "Black Widow",
            "Hulk",
            "Spider-Man",
        ]
        
        // Session text field.
        sessionTextField = UITextField(frame: CGRect(x: margin,
                                                     y: statusBarHeight + margin,
                                                     width: textFieldWidth, height: textFieldHeight))
        sessionTextField.borderStyle = .roundedRect
        sessionTextField.placeholder = "Username"
        sessionTextField.autocorrectionType = .no
        sessionTextField.text = avengersNames.randomElement()
        sessionTextField.delegate = self
        self.view.addSubview(sessionTextField)
        
        // Open session button.
        logInButton = UIButton(type: .system) as UIButton
        logInButton.frame = CGRect(x: margin,
                                   y: sessionTextField.frame.origin.y + sessionTextField.frame.height + margin,
                                   width: buttonWidth, height: buttonHeight)
        logInButton.backgroundColor = logInButton.tintColor
        logInButton.layer.cornerRadius = 5
        logInButton.isEnabled = true
        logInButton.isSelected = true
        logInButton.setTitle("LOG IN", for: .normal)
        logInButton.addTarget(self, action: #selector(logInButtonAction), for: .touchUpInside)
        self.view.addSubview(logInButton)
        
        // Close session button.
        logoutButton = UIButton(type: .system) as UIButton
        logoutButton.frame = CGRect(x: logInButton.frame.origin.x + logInButton.frame.width + margin,
                                    y: logInButton.frame.origin.y,
                                    width: buttonWidth, height: buttonHeight)
        logoutButton.backgroundColor = logoutButton.tintColor
        logoutButton.layer.cornerRadius = 5
        logoutButton.isEnabled = false
        logoutButton.isSelected = true
        logoutButton.setTitle("LOGOUT", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
        self.view.addSubview(logoutButton)
    }
    
    func initConferenceUI() {
        // Session text field.
        conferenceTextField = UITextField(frame: CGRect(x: margin,
                                                        y: logoutButton.frame.origin.y + logoutButton.frame.height + margin,
                                                        width: textFieldWidth, height: textFieldHeight))
        conferenceTextField.borderStyle = .roundedRect
        conferenceTextField.placeholder = "Conference alias"
        conferenceTextField.autocorrectionType = .no
        conferenceTextField.delegate = self
        self.view.addSubview(conferenceTextField)
        
        // Conference create/join button.
        startButton = UIButton(type: .system) as UIButton
        startButton.frame = CGRect(x: margin,
                                   y: conferenceTextField.frame.origin.y + conferenceTextField.frame.height + margin,
                                   width: buttonWidth, height: buttonHeight)
        startButton.backgroundColor = startButton.tintColor
        startButton.layer.cornerRadius = 5
        startButton.isEnabled = false
        startButton.isSelected = true
        startButton.setTitle("START", for: .normal)
        startButton.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
        self.view.addSubview(startButton)
        
        // Conference leave button.
        leaveButton = UIButton(type: .system) as UIButton
        leaveButton.frame = CGRect(x: startButton.frame.origin.x + startButton.frame.width + margin,
                                   y: startButton.frame.origin.y,
                                   width: buttonWidth, height: buttonHeight)
        leaveButton.backgroundColor = leaveButton.tintColor
        leaveButton.layer.cornerRadius = 5
        leaveButton.isEnabled = false
        leaveButton.isSelected = true
        leaveButton.setTitle("LEAVE", for: .normal)
        leaveButton.addTarget(self, action: #selector(leaveButtonAction), for: .touchUpInside)
        self.view.addSubview(leaveButton)
        
        // Start video button.
        startVideoButton = UIButton(type: .system) as UIButton
        startVideoButton.frame = CGRect(x: margin,
                                        y: startButton.frame.origin.y + startButton.frame.height + margin,
                                        width: buttonWidth, height: buttonHeight)
        startVideoButton.backgroundColor = startVideoButton.tintColor
        startVideoButton.layer.cornerRadius = 5
        startVideoButton.isEnabled = false
        startVideoButton.isSelected = true
        startVideoButton.setTitle("START VIDEO", for: .normal)
        startVideoButton.addTarget(self, action: #selector(startVideoButtonAction), for: .touchUpInside)
        self.view.addSubview(startVideoButton)
        
        // Stop video button.
        stopVideoButton = UIButton(type: .system) as UIButton
        stopVideoButton.frame = CGRect(x: startButton.frame.origin.x + startButton.frame.width + margin,
                                       y: startVideoButton.frame.origin.y,
                                       width: buttonWidth, height: buttonHeight)
        stopVideoButton.backgroundColor = stopVideoButton.tintColor
        stopVideoButton.layer.cornerRadius = 5
        stopVideoButton.isEnabled = false
        stopVideoButton.isSelected = true
        stopVideoButton.setTitle("STOP VIDEO", for: .normal)
        stopVideoButton.addTarget(self, action: #selector(stopVideoButtonAction), for: .touchUpInside)
        self.view.addSubview(stopVideoButton)
        
        // Video views.
        videosView1 = VTVideoView(frame: CGRect(x: margin,
                                                y: startVideoButton.frame.origin.y + startVideoButton.frame.height + margin,
                                                width: buttonWidth, height: buttonWidth))
        videosView1.backgroundColor = .black
        self.view.addSubview(videosView1)
        
        videosView2 = VTVideoView(frame: CGRect(x: startVideoButton.frame.origin.x + startVideoButton.frame.width + margin,
                                                y: videosView1.frame.origin.y,
                                                width: buttonWidth, height: buttonWidth))
        videosView2.backgroundColor = .black
        self.view.addSubview(videosView2)
        
        // Participants label.
        participantsLabel = UILabel(frame: CGRect(x: margin,
                                                  y: videosView1.frame.origin.y + videosView1.frame.height + margin,
                                                  width: textFieldWidth, height: textFieldHeight))
        participantsLabel.backgroundColor = .lightGray
        participantsLabel.adjustsFontSizeToFitWidth = true
        participantsLabel.minimumScaleFactor = 0.1
        self.view.addSubview(participantsLabel)
        
        // Start screen share button.
        startScreenShareButton = UIButton(type: .system) as UIButton
        startScreenShareButton.frame = CGRect(x: margin,
                                              y: participantsLabel.frame.origin.y + participantsLabel.frame.height + margin,
                                              width: buttonWidth, height: 50)
        startScreenShareButton.backgroundColor = startScreenShareButton.tintColor
        startScreenShareButton.layer.cornerRadius = 5
        startScreenShareButton.isEnabled = false
        startScreenShareButton.isSelected = true
        startScreenShareButton.setTitle("START SCREENSHARE", for: .normal)
        startScreenShareButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        startScreenShareButton.titleLabel?.textAlignment = .center
        startScreenShareButton.addTarget(self, action: #selector(startScreenShareAction), for: .touchUpInside)
        self.view.addSubview(startScreenShareButton)
        
        // Stop screen share button.
        stopScreenShareButton = UIButton(type: .system) as UIButton
        stopScreenShareButton.frame = CGRect(x: startScreenShareButton.frame.origin.x + startScreenShareButton.frame.width + margin,
                                             y: startScreenShareButton.frame.origin.y,
                                             width: buttonWidth, height: 50)
        stopScreenShareButton.backgroundColor = stopScreenShareButton.tintColor
        stopScreenShareButton.layer.cornerRadius = 5
        stopScreenShareButton.isEnabled = false
        stopScreenShareButton.isSelected = true
        stopScreenShareButton.setTitle("STOP SCREENSHARE", for: .normal)
        stopScreenShareButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        stopScreenShareButton.titleLabel?.textAlignment = .center
        stopScreenShareButton.addTarget(self, action: #selector(stopScreenShareAction), for: .touchUpInside)
        self.view.addSubview(stopScreenShareButton)
        
        // Start recording button.
        startRecordingButton = UIButton(type: .system) as UIButton
        startRecordingButton.frame = CGRect(x: margin,
                                            y: startScreenShareButton.frame.origin.y + startScreenShareButton.frame.height + margin,
                                            width: buttonWidth, height: buttonHeight)
        startRecordingButton.backgroundColor = startRecordingButton.tintColor
        startRecordingButton.layer.cornerRadius = 5
        startRecordingButton.isEnabled = false
        startRecordingButton.isSelected = true
        startRecordingButton.setTitle("START RECORD", for: .normal)
        startRecordingButton.addTarget(self, action: #selector(startRecordingAction), for: .touchUpInside)
        self.view.addSubview(startRecordingButton)
        
        // Stop recording button.
        stopRecordingButton = UIButton(type: .system) as UIButton
        stopRecordingButton.frame = CGRect(x: startRecordingButton.frame.origin.x + startRecordingButton.frame.width + margin,
                                           y: startRecordingButton.frame.origin.y,
                                           width: buttonWidth, height: buttonHeight)
        stopRecordingButton.backgroundColor = stopRecordingButton.tintColor
        stopRecordingButton.layer.cornerRadius = 5
        stopRecordingButton.isEnabled = false
        stopRecordingButton.isSelected = true
        stopRecordingButton.setTitle("STOP RECORD", for: .normal)
        stopRecordingButton.addTarget(self, action: #selector(stopRecordingAction), for: .touchUpInside)
        self.view.addSubview(stopRecordingButton)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
    func participantAdded(participant: VTParticipant) { }
    
    func participantUpdated(participant: VTParticipant) { }
    
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

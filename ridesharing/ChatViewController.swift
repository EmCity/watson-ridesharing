//
//  ChatViewController.swift
//  ridesharing
//
//  Created by Sebastian Wagner on 22.04.17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import Firebase
import JSQMessagesViewController


class ChatViewController: JSQMessagesViewController {
    
    let ref = FIRDatabase.database().reference(withPath: "grocery-items")
    private lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channels")
    private var channelRefHandle: FIRDatabaseHandle?
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    var messages = [JSQMessage]()
    private lazy var messageRef: FIRDatabaseReference = self.channelRef.child("messages")
    private var newMessageRefHandle: FIRDatabaseHandle?
    private lazy var usersTypingQuery: FIRDatabaseQuery =
    self.channelRef.child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)
    /*FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in // 2
    if let err = error { // 3
    print(err.localizedDescription)
    return
    }
    
    //self.performSegue(withIdentifier: "LoginToChat", sender: nil) // 4
    })
*/

    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = String(arc4random_uniform(1000000) + 1)
        self.senderDisplayName = "Sebastian"
        //FIRApp.configure()
        self.collectionView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 0.1)
        navigationItem.hidesBackButton = true
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in // 2
            if let err = error { // 3
                print(err.localizedDescription)
                return
            }
            })
        //self.senderId = FIRAuth.auth()?.currentUser?.uid
        print("What is the sender Id?")
        print(senderId)
        // No avatars
//        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
//        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        observeMessages()
        //self.setupTextBubbles()
        // Remove attachment icon from toolbar
        //self.inputToolbar.contentView.leftBarButtonItem = nil
        //NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.senderId = "1"
        //SwiftSpinner.show("Connecting to Server", animated: true)
        // messages from someone else
        //addMessage(withId: "foo", name: "Mr.Bolt", text: "I am so fast!")
        // messages sent from local sender
        //addMessage(withId: "123", name: "Me", text: "I bet I can run faster than you!")
        //addMessage(withId: "231", name: "Me", text: "I like to run!")
        // animates the receiving of a new message on the view
        finishReceivingMessage(animated: true)
        //SwiftSpinner.hide()
        //observeTyping()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare method for segue in ChatViewController")
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        let message = messages[(indexPath as NSIndexPath).item]
        var avatar: JSQMessagesAvatarImage
        if (message.senderId == self.senderId){
            avatar  = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named:"lisa-avatar"), diameter: 37)
        }
        else{
            avatar  = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named:"watson-blue-avatar"), diameter: 32)
        }
        return avatar
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
    let message = messages[indexPath.item] // 1
    if message.senderId == senderId { // 2
        return outgoingBubbleImageView
    } else { // 3
        return incomingBubbleImageView
    }
}

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }

override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
    return messages[indexPath.item]
}

override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
}

private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
    let bubbleImageFactory = JSQMessagesBubbleImageFactory()
    return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor(colorLiteralRed: 200.0/230.0, green: 20.0/230.0, blue: 20.0/230.0, alpha: 0.6))
}

private func setupIncomingBubble() -> JSQMessagesBubbleImage {
    let bubbleImageFactory = JSQMessagesBubbleImageFactory()
    return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
}
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let itemRef = messageRef.childByAutoId() // 1
        let messageItem = [ // 2
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": text!,
            ]
        
        itemRef.setValue(messageItem) // 3
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound() // 4
        
        finishSendingMessage(animated: true) // 5
        
        isTyping = false
    }
    
    private func observeMessages() {
        messageRef = channelRef.child("messages")
        // 1.
        let messageQuery = messageRef.queryLimited(toLast:25)
        
        // 2. We can use the observe method to listen for new
        // messages being written to the Firebase DB
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            // 3
            let messageData = snapshot.value as! Dictionary<String, String>
            
            if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {
                // 4
                self.addMessage(withId: id, name: name, text: text)
                
                // 5
                self.finishReceivingMessage(animated: true)
            } else {
                print("Error! Could not decode message data")
            }
        })
    }
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        isTyping = textView.text != ""
    }
    
    private lazy var userIsTypingRef: FIRDatabaseReference =
        self.channelRef.child("typingIndicator").child(self.senderId) // 1
    private var localTyping = false // 2
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            // 3
            localTyping = newValue
            userIsTypingRef.setValue(newValue)
        }
    }
    
    private func observeTyping() {
        let typingIndicatorRef = self.channelRef.child("typingIndicator")
        userIsTypingRef = typingIndicatorRef.child(senderId)
        userIsTypingRef.onDisconnectRemoveValue()
        // 1
        usersTypingQuery.observe(.value) { (data: FIRDataSnapshot) in
            // 2 You're the only one typing, don't show the indicator
            if data.childrenCount == 1 && self.isTyping {
                return
            }
            
            // 3 Are there others typing?
            self.showTypingIndicator = data.childrenCount > 0
            self.scrollToBottom(animated: true)
        }
    }
    

}

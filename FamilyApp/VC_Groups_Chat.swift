//
//  ChatViewController.swift
//  FamilyApp
//
//  Created by Uyviet Nguyen on 10/31/16.
//  Copyright © 2016 uab. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

final class ChatViewController: JSQMessagesViewController {

    var group: Group?
    private var messageRef: FIRDatabaseReference?
    private var newMessageRefHandle: FIRDatabaseHandle?
    
    var messages = [JSQMessage]()
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderDisplayName = Database.user.firstName
        self.senderId = FIRAuth.auth()?.currentUser?.uid
        self.title = group!.name
        
        var image = UIImage(named: "groupIcon")!
        image = image.resize(targetSize: CGSize(width: 22, height: 22))
        self.addRightBarButtonWithImage(image)

        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
//        self.collectionView.backgroundColor = FAColor.blueLight
        
        
        observeMessages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.slideMenuController()?.addRightGestures()
        self.senderDisplayName = Database.user.firstName
        
        if let gid = group?.groupId {
            let ref = FIRDatabase.database().reference(withPath: "groups").child(gid).child("members")
            ref.observeSingleEvent(of: .value, with: { snapshot in
                for member in snapshot.children {
                    let snap = member as! FIRDataSnapshot
                    if let user = Database.userCache.object(forKey: snap.key as NSString) {
                        MembersViewController.members.append(user)
                    }
                }
            })
        }
        
        finishReceivingMessage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    //Messages from current user
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
//        let color = UIColor.jsq_messageBubbleBlue()
        let color = FAColor.blueMedium
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: color)
    }
    
    //Messages from others
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
//        let color = UIColor.jsq_messageBubbleLightGray()
        let color = FAColor.lightGreen
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: color)
    }
    
    //Color of text bubbles
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    //Color of text in bubbles
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
    
    //I think this makes the user names appear...
    override func collectionView(_ collectionView: JSQMessagesCollectionView?, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString? {
        let message = messages[indexPath.item]
        switch message.senderId {
        case senderId:
            return nil
        default:
            guard let senderDisplayName = message.senderDisplayName else {
                assertionFailure()
                return nil
            }
            return NSAttributedString(string: senderDisplayName)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }

    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        return
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        messageRef = FIRDatabase.database().reference(withPath: "groupchats").child("\(group!.groupId)")
        let itemRef = messageRef?.childByAutoId()
        let messageItem = [
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": text!,
            ]
        
        itemRef?.setValue(messageItem)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
    }
    
    private func observeMessages() {
        messageRef = FIRDatabase.database().reference(withPath: "groupchats").child("\(group!.groupId)")
        let messageQuery = messageRef?.queryLimited(toLast:25)
        
        newMessageRefHandle = messageQuery?.observe(.childAdded, with: { (snapshot) -> Void in
            let messageData = snapshot.value as! Dictionary<String, String>
            
            if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {
                self.addMessage(withId: id, name: name, text: text)
                self.finishReceivingMessage()
            } else {
                print("Error! Could not decode message data")
            }
        })
    }

}

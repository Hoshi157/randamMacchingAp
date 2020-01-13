//
//  MacchingViewController.swift
//  randamMacching
//
//  Created by 福山帆士 on 2020/01/01.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import Firebase
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore
import NVActivityIndicatorView

class MacchingViewController: MessagesViewController {
    
    var chatstartFlg:Bool?
    var userDefault = UserDefaults.standard
    var uid = UUID().uuidString
    let db = Firestore.firestore()
    let userDB = Firestore.firestore().collection("users")
    let app = UIApplication.shared.delegate as! AppDelegate
    var name:String?
    
    var activityIndicatorView = NVActivityIndicatorView(frame:CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), type: .ballBeat, color: .magenta, padding: 130)
    
    var values:[String] = []
    
    var Messages:[MockMessage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    
        activityIndicatorView.backgroundColor = UIColor.purple.withAlphaComponent(0.15)
        

        // Do any additional setup after loading the
        if let layot = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout{
            layot.setMessageIncomingAvatarSize(.zero)
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            layot.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: insets))
            layot.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: insets))
        }
        
        if userDefault.string(forKey: "name") != nil{
            name = userDefault.string(forKey: "name")
        }else{
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        if userDefault.string(forKey: "user") != nil {
            uid = userDefault.string(forKey: "user")!
        }else{
            userDefault.set(self.uid, forKey: "user")
        }
        print("PRINT=自分のuid: \(self.uid)")
        activityIndicatorView.center = self.view.center
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.startAnimating()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messageCellDelegate = self
       
        
        self.chatstartFlg = false
        
        setupFirebase()
        getroom()
        self.Messages = []
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func setupFirebase(){
        
        Auth.auth().signInAnonymously() {(user,error) in
            if error != nil {
                print("PRINT=ログイン失敗")
                return
            }else{
                print("PRINT=ログイン成功")
            }
        }
    }
    
    func getroom(){
        
        let user = ["userName":currentSender().displayName,"inRoom":"0","wattingFlg":"0"]
        userDB.document(self.uid).setData(user)
        
        userDB.whereField("wattingFlg", isEqualTo: "1").getDocuments(){ querySnapshot,error in
            
            print("PRINT:\(querySnapshot!.documents.count)")
                if querySnapshot!.documents.count >= 1{
                    for document in querySnapshot!.documents{
                        self.values.append(document.documentID)
                            }
                    self.createRoom(value: self.values)
                }else{
                
                self.userDB.document(self.uid).updateData(["wattingFlg":"1"])
                print("PRINT:wattingFlgが１に変更された")
                self.checkMyWaitingFlg()
            }
            }
        }
    
    
    func checkMyWaitingFlg(){
        userDB.document(self.uid).addSnapshotListener { documentSnapshot,error in
            let snapshot = documentSnapshot!.data()!
            let value = snapshot["wattingFlg"] as! String
            print("PRINT:\(value)")
            
            if value == "0"{
                self.getJoinRoom()
            }
                }
            }
    
    func getJoinRoom(){
        userDB.document(self.uid).getDocument(){documentSnapshot,error in
            let snapshot = documentSnapshot!.data()!
            let value = snapshot["inRoom"] as! String
            self.app.roomId = value
            
            if self.app.roomId != "0"{
                print("PRINT:roomId = \(self.app.roomId!)")
                print("PRINT:getJoin チャットを開始する")
                self.getMessage()
            }
        }
    }
    
    func getMessage(){
        self.chatstartFlg = true
        print("PRINT:getMessage()")
        activityIndicatorView.stopAnimating()
        
         db.collection("rooms").document(self.app.roomId!).collection("chate").addSnapshotListener{querySnapshot,error in
            
            guard let snapshots = querySnapshot else{return}
            snapshots.documentChanges.forEach{diff in
                
                if diff.type == .added{
                    let chateDataOp = diff.document.data() as? Dictionary<String,String>
                    guard let chateData = chateDataOp else{return}
                    
                    let text = chateData["text"]
                    let from = chateData["from"]
                    let name = chateData["name"]
                    
                    let message = MockMessage(messageId: "1", sender: Sender(id: from!, displayName: name!), sentDate: Date(), text: text!)
                    self.Messages.append(message)
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom()
                }
            }
            }
        
    }
    
    func createRoom(value:[String]){
        for value in values{
            print("PRINT:creatRoom=\(value)")
            if value != self.uid{
                print("PRINT:待機中のuid=\(value)")
                self.app.targetId = value
            }
        }
        print("PRINT:チャット開始する")
        self.getNewRoomKey()
    }
    
    var count = 1
    func getNewRoomKey(){
        Firestore.firestore().collection("roomKey").document("roomKeyNumber").getDocument(){documentSnapshot,error in
            let data = documentSnapshot?.data()
            print("PRINT:getroom=\(data!)")
            if (data!.count >= 1){ //クラッシュ
                self.count = (data?["Number"] as! Int) + 1 //予期せぬnill
                
            }
            Firestore.firestore().collection("roomKey").document("roomKeyNumber").setData(["Number":self.count])
            self.app.newRoomId = String(self.count)
            self.UpdataEachInfo()
        }
    }
    
    func UpdataEachInfo(){
        self.app.roomId = self.app.newRoomId
        print("PRINT:\(self.app.roomId!)")
        
        userDB.document(self.app.targetId!).updateData(["inRoom":self.app.roomId!])
        userDB.document(self.app.targetId!).updateData(["wattingFlg":"0"])
        userDB.document(self.uid).updateData(["inRoom":self.app.roomId!])
        userDB.document(self.uid).updateData(["wattingFlg":"0"])
        
        self.getMessage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("PRINT:viewWillDisapper")
        
        userDB.document(self.uid).updateData(["wattingFlg":"0"])
        
        if activityIndicatorView.isAnimating{
            activityIndicatorView.stopAnimating()
        }
        if self.app.roomId != "0"{
            self.app.roomId = "0"
        }
    }
    
    
    
    

}



extension MacchingViewController:MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(id: self.uid, displayName: self.name!)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return Messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return Messages.count
    }
}

extension MacchingViewController:MessageInputBarDelegate{
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        if self.chatstartFlg == true {
            print("PRINT：ここにfirebaseに保存する処理")
            self.sendTextDB(text: text)
        }else{
            print("PRINT:マッチング相手を探しています")
        }
        inputBar.inputTextView.text = String()
        
    }
    
    
    func sendTextDB(text:String){
        let post = ["text":text,"from":currentSender().senderId,"name":currentSender().displayName]
        let postRef = Firestore.firestore().collection("rooms").document(self.app.roomId!).collection("chate")
        //let randamInt = generate(length: 20)
        postRef.addDocument(data: post)
    }
    
    
    func generate(length:Int) -> String{
        let base = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        var randamString:String = ""
        
        for _ in 0..<length {
            let randamValue = arc4random_uniform(UInt32(base.count))
            randamString += "\(base[base.index(base.startIndex,offsetBy:String.IndexDistance(randamValue))])"
        }
        
        return randamString
    }
    
}

extension MacchingViewController:MessagesLayoutDelegate{
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 3 == 0{
            return 10
        }
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}

extension MacchingViewController:MessagesDisplayDelegate{
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .magenta : .yellow
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner:MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight:.bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
}

extension MacchingViewController:MessageCellDelegate{
    
}



//
//  constants.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 06/12/22.
//


import Foundation
import Firebase

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
let COLLECTION_POSTS = Firestore.firestore().collection("posts")
let COLLECTION_NOTIFICATIONS = Firestore.firestore().collection("notifications")





let USER_REPLIES = Firestore.firestore().collection("user-replies")
let USER_USERNAMES = Firestore.firestore().collection("user-usernames")
let MESSAGES = Firestore.firestore().collection("messages")
let USER_MESSAGES = Firestore.firestore().collection("user-messages")
let USER_FEED = Firestore.firestore().collection("user-feeds")

let KEY_EMAIL = "email"
let KEY_FULLNAME = "fullname"
let KEY_USERNAME = "username"
let KEY_PROFILE_IMAGE_URL = "profileImageUrl"
let KEY_LIKES = "likes"
let KEY_RETWEET_COUNT = "retweets"
let KEY_CAPTION = "caption"
let KEY_TIMESTAMP = "timestamp"
let KEY_UID = "uid"
let KEY_TYPE = "type"
let KEY_TWEET_ID = "tweetID"
let KEY_FROM_ID = "fromID"
let KEY_TO_ID = "toID"
let KEY_MESSAGE_TEXT = "messageText"
let KEY_MESSAGE_READ = "read"
let KEY_RETWEET_USERNAME = "retweetUsername"
let KEY_BIO = "bio"

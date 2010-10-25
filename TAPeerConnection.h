//
//  TAPeerConnection.h
//  TAToolkit
//
//  Created by Tom Krush on 10/24/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAViewController.h"
#import <GameKit/GameKit.h>

@protocol TAPeerConnectionDelegate;

@interface TAPeerConnection : NSObject <GKPeerPickerControllerDelegate, GKSessionDelegate> 
{
	GKPeerPickerController *_peerPickerController;
	GKSession *_session;
	
	NSMutableArray *_peers;

	NSString *_sessionID;
	NSString *_sessionName;
	
	id <TAPeerConnectionDelegate> _delegate;
}

- (id)initWithSessionName:(NSString *)sessionName sessionID:(NSString *)sessionID;
- (void)start;
- (void)sendData:(NSData *)data;

@property (nonatomic, readonly) GKPeerPickerController *peerPickerController;
@property (nonatomic, readonly) NSMutableArray *peers;
@property (nonatomic, retain) GKSession *session;

@property(nonatomic, assign)    id <TAPeerConnectionDelegate> delegate;

@end

@protocol TAPeerConnectionDelegate <NSObject>

@optional

- (void)peerConnectionController:(TAPeerConnection *)controller didReceiveData:(NSData *)data fromPeer:(NSString *)peer;

@end

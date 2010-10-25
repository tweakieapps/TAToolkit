//
//  TAPeerConnection.m
//  TAToolkit
//
//  Created by Tom Krush on 10/24/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import "TAPeerConnection.h"

@implementation TAPeerConnection

@synthesize session = _session;
@synthesize delegate = _delegate;

- (id)initWithSessionName:(NSString *)sessionName sessionID:(NSString *)sessionID
{
	if ( self = [super init] )
	{
		_sessionName	= [sessionName retain];
		_sessionID		= [sessionID retain]; 
	}
	
	return self;
}

- (void)start
{
	[self.peerPickerController show];
}

- (GKPeerPickerController *)peerPickerController
{
	if ( ! _peerPickerController )
	{
		_peerPickerController=[[GKPeerPickerController alloc] init];
		_peerPickerController.delegate=self;
		_peerPickerController.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
	}
	
	return _peerPickerController;
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
    self.session = session;
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
	
	// Remove the picker.
    picker.delegate = nil;
    [picker dismiss];
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type{		
	GKSession* session = [[GKSession alloc] initWithSessionID:_sessionID displayName:_sessionName sessionMode:GKSessionModePeer];

    return session;
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{

}

//Indicates a state change for the given peer.
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {	
	switch (state) 
	{
        case GKPeerStateConnected:
			[self.peers addObject:peerID];
			break;
		
        case GKPeerStateDisconnected:
			[self.peers removeObject:peerID];
			break;
    }
}

-(void)sendData:(NSData *)data
{	
	[self.session sendData:data toPeers:self.peers withDataMode:GKSendDataReliable error:nil];
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
	if ( [_delegate respondsToSelector:@selector(peerConnectionController:didReceiveData:fromPeer:)] )
	{
		[_delegate peerConnectionController:self didReceiveData:data fromPeer:peer];
	}

	NSLog(@"Received Data");
}

- (NSMutableArray *)peers
{
	if ( ! _peers )
	{
		_peers = [[NSMutableArray alloc] init];
	}
	
	return _peers;
}

- (void)dealloc
{
	[_session release];
	[_peerPickerController release];
	[_peers release];
	
	[_sessionName release];
	[_sessionID release];

	[super dealloc];
}

@end

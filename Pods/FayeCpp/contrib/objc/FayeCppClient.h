/*
 *   Copyright (c) 2014 Kulykov Oleh <nonamedemail@gmail.com>
 *
 *   Permission is hereby granted, free of charge, to any person obtaining a copy
 *   of this software and associated documentation files (the "Software"), to deal
 *   in the Software without restriction, including without limitation the rights
 *   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *   copies of the Software, and to permit persons to whom the Software is
 *   furnished to do so, subject to the following conditions:
 *
 *   The above copyright notice and this permission notice shall be included in
 *   all copies or substantial portions of the Software.
 *
 *   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *   THE SOFTWARE.
 */


#import <Foundation/Foundation.h>


@class FayeCppClient;


/**
 @brief Objective-c FayeCpp client wrapper delegate interface.
 @detailed All delegate methods are optional and all of them called from main thread.
 */
@protocol FayeCppClientDelegate <NSObject>
@optional


/**
 @brief Client transport protocol connected to server.
 @param client Faye client object.
 */
- (void) onFayeTransportConnected:(FayeCppClient *) client;


/**
 @brief Client transport protocol disconnected from server.
 @param client Faye client object.
 */
- (void) onFayeTransportDisconnected:(FayeCppClient *) client;


/**
 @brief Faye client connected to faye server.
 @param client Faye client object.
 */
- (void) onFayeClientConnected:(FayeCppClient *) client;


/**
 @brief Faye client disconnected to faye server.
 @param client Faye client object.
 */
- (void) onFayeClientDisconnected:(FayeCppClient *) client;


/**
 @brief Faye clent subscribed to channel.
 @param client Faye client object.
 @param channel Channel name.
 */
- (void) onFayeClient:(FayeCppClient *) client
  subscribedToChannel:(NSString *) channel;


/**
 @brief Faye clent unsubscribed from channel.
 @param client Faye client object.
 @param channel Target channel name.
 */
- (void) onFayeClient:(FayeCppClient *) client
unsubscribedFromChannel:(NSString *) channel;


/**
 @brief Called when faye client received non empty data from server responce using subscribed channel.
 @param client Faye client object.
 @param message Received non empty responce message dictionary.
 @param channel Subscribed channel which received message data.
 */
- (void) onFayeClient:(FayeCppClient *) client
	  receivedMessage:(NSDictionary *) message
		  fromChannel:(NSString *) channel;

/**
 @brief Called on faye client or transport error.
 @param client Faye client object.
 @param error Error object with localized string. See key NSLocalizedDescriptionKey.
 */
- (void) onFayeClient:(FayeCppClient *) client
				error:(NSError *) error;

@end


/**
 @brief Objective-c FayeCpp SSL data source wrapper delegate interface.
 @detailed All delegate methods are optional and all of them called from main thread.
 */
@protocol FayeCppClientSSLDataSource <NSObject>
@optional


/**
 @brief Get client sertificate file path.
 @detailed Path to certificate file. Currently supports rsa algorithm & pem encoding format.
 @example return @"/Volumes/Data/faye/client.crt";
 @return String with file path or empty string.
 */
- (NSString *) clientLocalCertificateFilePath;


/**
 @brief Get client private key file path.
 @detailed Path to key file. Currently supports rsa algorithm & pem encoding format.
 @example return @"/Volumes/Data/faye/client.key";
 @return String with file path or empty string.
 */
- (NSString *) clientPrivateKeyFilePath;


/**
 @brief Get client private key passphrase. Needs for encrypted client file key.
 @detailed If client key is encrypted(have '-----BEGIN ENCRYPTED PRIVATE KEY-----'),
 you should return pass for this key.
 @return Pass phrase string or empty string.
 */
- (NSString *) clientPrivateKeyPassPhrase;


/**
 @brief Get ca certificate file path.
 @return String with file path or empty string.
 */
- (NSString *) clientCACertificateFilePath;

@end


/**
 @brief Objective-c FayeCpp client wrapper.
 */
@interface FayeCppClient : NSObject


/**
 @brief Property for client delegate.
 @detailed This property used custom methods 'delegate' and 'setDelegate:'.
 */
@property (nonatomic, assign, getter = delegate, setter = setDelegate:) id<FayeCppClientDelegate> delegate;


/**
 @brief Property for client url string.
 @detailed This property used custom methods 'urlString' and 'setUrlString:'.
 No need to use NSURL object for cause of additional processing.
 */
@property (nonatomic, assign, getter = urlString, setter = setUrlString:) NSString * urlString;


/**
 @brief Property for client IPV6 usability.
 @detailed This property used custom methods 'isUsingIPV6' and 'setUsingIPV6:'.
 */
@property (nonatomic, assign, getter = isUsingIPV6, setter = setUsingIPV6:) BOOL usingIPV6;


/**
 @brief Check client should use IPV6.
 @detailed Default value is NO, no matter client supports it or not.
 To check posibility of using IPV6 by the client use static method '[Client isSupportsIPV6]'.
 @return YES if client supports & should use IPV6, othervice NO.
 */
- (BOOL) isUsingIPV6;


/**
 @brief Set client should use IPV6.
 @detailed During setting checks is client can use it. 
 Set this value before connecting.
 @param isUse Flag for using IPV6.
 */
- (void) setUsingIPV6:(BOOL) isUse;


/**
 @brief Start connection sequence. On the first step connecting transport protocol to server(inform delegate).
 @brief Next - connecting faye(also, inform delegate).
 @return True if sequence initialized, otherwice false.
 */
- (BOOL) connect;


/**
 @brief Check connection of the transport protocol.
 @return True - connected, otherwice false.
 */
- (BOOL) isTransportConnected;


/**
 @brief Check faye client connection.
 @return True - connected, otherwice false.
 */
- (BOOL) isFayeConnected;


/**
 @brief Disconnects from faye server. Transport protocol could be still opened/connected.
 */
- (void) disconnect;


/**
 @brief Start send message to subscribed channel via connected faye.
 @detailed Clent will NOT inform delegate for this user message.
 @param message Non empty message for send.
 @param channel Non empty, subscribed channel.
 @return True - if connected and parameters non empty and sended, othervice false.
 */
- (BOOL) sendMessage:(NSDictionary *) message
		   toChannel:(NSString *) channel;


/**
 @brief Check channel is subscribed.
 @param channel Non empty channel.
 @return True - if subscribed, otherwice false.
 */
- (BOOL) isSubscribedToChannel:(NSString *) channel;


/**
 @brief Subscribes or storing to pendnig subscriptions required channel.
 @param channel Non empty channel.
 @return True - if already suscribed, started or stored to peding subscriptions, otherwice false.
 */
- (BOOL) subscribeToChannel:(NSString *) channel;


/**
 @brief Unsubscribe from specific channel.
 @param channel Non empty subscribed channel.
 @return True on unsubscription started, otherwice false or channel is empty or not subscribed.
 */
- (BOOL) unsubscribeFromChannel:(NSString *) channel;


/**
 @brief Setter for faye url.
 @param url Faye server url string.
 */
- (void) setUrlString:(NSString *) url;


/**
 @brief Getter for faye url.
 */
- (NSString *) urlString;


/**
 @brief Setter for faye client delegate.
 @param fayeDelegate Faye client delegate.
 */
- (void) setDelegate:(id<FayeCppClientDelegate>) fayeDelegate;


/**
 @brief Getter for faye client delegate.
 */
- (id<FayeCppClientDelegate>) delegate;


/**
 @brief Setter for faye SSL data source.
 @param fayeSSLDataSource Faye client SSL data source.
 */
- (void) setSSLDataSource:(id<FayeCppClientSSLDataSource>) fayeSSLDataSource;


/**
 @brief Getter for faye client SSL data source.
 */
- (id<FayeCppClientSSLDataSource>) sslDataSource;


/**
 @brief Check is can client use IPV6.
 @detailed Depends on dependecies build options.
 @return YES if client can use, otherwice NO.
 */
+ (BOOL) isSupportsIPV6;


/**
 @brief Check is can client use sequre SSL connection.
 @detailed Depends on dependecies build options.
 @return True if client can use, otherwice false.
 */
+ (BOOL) isSupportsSSLConnection;

@end


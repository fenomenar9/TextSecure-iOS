//
//  IncomingPushMessageSignal.m
//  TextSecureiOS
//
//  Created by Christine Corbett Moran on 10/24/13.
//  Copyright (c) 2013 Open Whisper Systems. All rights reserved.
//

#import "IncomingPushMessageSignal.hh"


@implementation IncomingPushMessageSignal


-(id) init {
  // Testing things out
  if(self = [super init]) {
    // Creating message
    /*
     Type
     Allowed source
     Destinations
     Timestamp
     Allocated Message
     */
    std::string phoneNumber ="+41000000000";
    std::string message = "Hey, what's up. I'm using TextSecure.";
    textsecure::IncomingPushMessageSignal *incomingPushMessage = new textsecure::IncomingPushMessageSignal();
    incomingPushMessage->set_type(0); // 0=plaintext,1=ciphertext,3=prekeybundle
    incomingPushMessage->set_allocated_source(&phoneNumber);
    //incomingPushMessage->set_destinations(<#int index#>, <#const ::std::string &value#>); //leaving empty, not a group message.
    incomingPushMessage->set_timestamp((uint64_t)[[NSDate date] timeIntervalSince1970]);
    incomingPushMessage->set_allocated_message(&message);
    // Printing message
    [self prettyPrint:incomingPushMessage];
    // Serializing message
    NSData* serializedIncomingPushMessage;
    
    // Deserializing message
    textsecure::IncomingPushMessageSignal *deserializedIncomingPushMessage = [self getIncomingPushMessageSignalForData:serializedIncomingPushMessage];
    // Printing deserialized message
    [self prettyPrint:deserializedIncomingPushMessage];
  }
  return self;
}

// Serialize to NSData.
- (NSData *)getDataForIncomingPushMessageSignal:(textsecure::IncomingPushMessageSignal *)incomingPushMessage {
  std::string ps = incomingPushMessage->SerializeAsString();
  return [NSData dataWithBytes:ps.c_str() length:ps.size()];
}

// De-serialize from an NSData object.
- (textsecure::IncomingPushMessageSignal *)getIncomingPushMessageSignalForData:(NSData *)data {
  int len = [data length];
  char raw[len];
  textsecure::IncomingPushMessageSignal *incomingPushMessage = new textsecure::IncomingPushMessageSignal;
  [data getBytes:raw length:len];
  incomingPushMessage->ParseFromArray(raw, len);
  return incomingPushMessage;
}

// Dlog
- (void)prettyPrint:(textsecure::IncomingPushMessageSignal *)incomingPushMessage {
  /*
   Type
   Allowed source
   Destinations
   Timestamp
   Allocated Message
   */
  
  const uint32_t cppType = incomingPushMessage->type();
  const std::string cppSource = incomingPushMessage->source();
  const uint64_t cppTimestamp = incomingPushMessage->timestamp();
  const std::string cppMessage = incomingPushMessage->message();
  /* testing conversion to objective c objects */
  NSNumber* type = [NSNumber numberWithInteger:cppType];
  NSString* source = [NSString stringWithCString:cppSource.c_str() encoding:NSASCIIStringEncoding];
  NSNumber* timestamp = [NSNumber numberWithInteger:cppTimestamp];
  NSString* messsage = [NSString stringWithCString:cppMessage.c_str() encoding:NSASCIIStringEncoding];
  
  NSLog([NSString stringWithFormat:@"Type: %@ \n source: %@ \n timestamp: %@, message: %@",
        type,source,timestamp,messsage]);
}
@end

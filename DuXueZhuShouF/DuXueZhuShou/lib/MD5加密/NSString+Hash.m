//
//  NSString+Hash.m
//
//  Created by Tom Corwine on 5/30/12.
//

#import "NSString+Hash.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (Hash)

#pragma mark - 32位 小写
-(NSString *)MD5ForLower32Bate{
    //要进行UTF8的转码
    const char* input = self.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

#pragma mark - 32位 大写
-(NSString *)MD5ForUpper32Bate{
    
    //要进行UTF8的转码
    const char * input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}

#pragma mark - 16位 大写
-(NSString *)MD5ForUpper16Bate{
    NSString *md5Str = [self MD5ForUpper32Bate];
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}


#pragma mark - 16位 小写
-(NSString *)MD5ForLower16Bate{
    
    NSString *md5Str = [self MD5ForLower32Bate];
    
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}


- (NSString *)md5String
{
	const char *string = self.UTF8String;
	int length = (int)strlen(string);
	unsigned char bytes[CC_MD5_DIGEST_LENGTH];
	CC_MD5(string, length, bytes);
	return [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)sha1String
{
	const char *string = self.UTF8String;
	int length = (int)strlen(string);
	unsigned char bytes[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(string, length, bytes);
	return [self stringFromBytes:bytes length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)sha256String
{
	const char *string = self.UTF8String;
	int length = (int)strlen(string);
	unsigned char bytes[CC_SHA256_DIGEST_LENGTH];
	CC_SHA256(string, length, bytes);
	return [self stringFromBytes:bytes length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)sha512String
{
	const char *string = self.UTF8String;
	int length = (int)strlen(string);
	unsigned char bytes[CC_SHA512_DIGEST_LENGTH];
	CC_SHA512(string, length, bytes);
	return [self stringFromBytes:bytes length:CC_SHA512_DIGEST_LENGTH];
}

- (NSString *)hmacSHA1StringWithKey:(NSString *)key
{
	NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
	NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
	NSMutableData *mutableData = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH];
	CCHmac(kCCHmacAlgSHA1, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
	return [self stringFromBytes:(unsigned char *)mutableData.bytes length:(int)mutableData.length];
}

- (NSString *)hmacSHA256StringWithKey:(NSString *)key
{
	NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
	NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
	NSMutableData *mutableData = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
	CCHmac(kCCHmacAlgSHA256, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
	return [self stringFromBytes:(unsigned char *)mutableData.bytes length:(int)mutableData.length];
}

- (NSString *)hmacSHA512StringWithKey:(NSString *)key
{
	NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
	NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
	NSMutableData *mutableData = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];
	CCHmac(kCCHmacAlgSHA512, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
	return [self stringFromBytes:(unsigned char *)mutableData.bytes length:(int)mutableData.length];
}

#pragma mark - Helpers

- (NSString *)stringFromBytes:(unsigned char *)bytes length:(int)length
{
	NSMutableString *mutableString = @"".mutableCopy;
	for (int i = 0; i < length; i++)
		[mutableString appendFormat:@"%02x", bytes[i]];
	return [NSString stringWithString:mutableString];
}

@end

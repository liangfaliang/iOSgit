//
//  NSString+Hash.h
//
//  Created by Tom Corwine on 5/30/12..
//

#import <Foundation/Foundation.h>

@interface NSString (Hash)
/**
 *  MD5加密, 32位 小写
 *
 *
 *  @return 返回加密后的字符串
 */
-(NSString *)MD5ForLower32Bate;

/**
 *  MD5加密, 32位 大写
 *
 *
 *  @return 返回加密后的字符串
 */
-(NSString *)MD5ForUpper32Bate;

/**
 *  MD5加密, 16位 小写
 *
 *  @return 返回加密后的字符串
 */
-(NSString *)MD5ForLower16Bate;
/**
 *  MD5加密, 16位 大写
 *
 *  @return 返回加密后的字符串
 */
-(NSString *)MD5ForUpper16Bate;

@property (readonly) NSString *md5String;
@property (readonly) NSString *sha1String;
@property (readonly) NSString *sha256String;
@property (readonly) NSString *sha512String;

- (NSString *)hmacSHA1StringWithKey:(NSString *)key;
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

@end

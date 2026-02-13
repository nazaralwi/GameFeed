/*
    AppSuit for iOS
 
    Version 25.5.2
 
    해당 라이브러리는 v25.5.X AppSuit Module과 호환됩니다.
 */



#define ATTR_SECTION_C  __attribute__((section("__DATA,stscore1")))
#define ATTR_SECTION_U  __attribute__((section("__DATA,stscore2")))
#define ATTR_SECTION_STUB __attribute__((section("__TEXT,__sl_stubs")))
#define ATTR_SECTION_FP __attribute__((section("__DATA,__sl_symbol_ptr")))
#define ATTR_USED  __attribute__((used))
#define checkSwizzled getServerMeta


#import <Foundation/Foundation.h>
#import <UIKit/UIViewController.h>

#ifdef __cplusplus
extern "C" {
#endif

/*
    @return 검증결과/탐지결과의 오류코드를 리턴
 */
char* AS_Check(void);

/*
    @param check_result: AS_Check로 나온 결과 값
    @return logging_data: 서버로 전송하는 데이터
 */

void AS_SCRAMInit(void);

/*
    @return msg1:
 */
char *AS_SCRAMDecryptMsg(const char *encrypted_text);
NSData *AS_SCRAMDecryptMsgAndDecode(const char *encrypted_text);
/*
    @return msg1: 서버로 전송하는 데이터
 */
char *AS_SCRAMClientFirstMsg(void);

/*
    @param server_res1: msg1을 서버로 전송하고 받은 결과
 */
void AS_SCRAMUpdateServerFirstMsg(const char *server_res1);

/*
    @return msg2: 서버로 전송하는 데이터
    Client Request
 */
char *AS_SCRAMClientSecondMsg(void);

/*
    @param server_res2: msg2를 서버로 전송하고 받은 결과
    Server Request
 */
void AS_SCRAMUpdateServerSecondMsg(const char *server_res2);

/*
    @param server_res2: msg2를 서버로 전송하고 받은 결과
    @return 인증 성공일 경우, 0 리턴
 */

char *StsBase64Encode(const void *buffer, size_t length, size_t *outputLength);
void *StsBase64Decode(const char *inputBuffer, size_t length, size_t *outputLength);


// 암호화된 Resource 파일 복호화
NSData* AS_Decrypt_Resource(NSString *fileName, NSString *ofType);

// CustomField 값 설정
void AS_SetCustomField(NSString* (^completion) (void));

//#if !TARGET_IPHONE_SIMULATOR && !defined(DEBUG)

void SaaS_Check(void);
    
@interface StockNewsdmManager : NSObject
int checkSwizzled(NSObject *cls, NSString *mtd);
+ (char*) defRandomString;
+ (char*) generateSerialNumber:(const char*)server_res ErrorDescriptionOutput:(char**)ppErrorDesc;
+ (int) loadAllMMOCache;

+ (void) singleShotLogRequest;
+ (char*) generateMacNumber:(const char*)encrypted_text;
+ (NSData*) generateMacNumberToDecode:(const char*)encrypted_text;

+ (char*) topMostViewController;
+ (void) viewControllerForView:(const char*)server_res1;
+ (char*) errorForFailedLoginWithCode;
+ (void) fetchCachedProfile:(const char*)server_res2;

+ (NSData*) willDrawCircleProfile:(NSString*)fileName :(NSString*)ofType;

+ (void)willCircleProfile:(NSString* (^)(void))completion;


@end

@interface UpdateMIssuesManager : NSObject
+ (void) viewDidLayoutAddr;
@end

@interface STSSLPinningManager: NSObject
- (BOOL)validate:(NSURLAuthenticationChallenge *)challenge;
@end
    
//#endif
    

#ifdef __cplusplus
}
#endif




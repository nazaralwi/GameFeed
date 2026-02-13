/*
    AppSuit for iOS
 
    Version 25.5.2
 
    해당 라이브러리는 v25.5.X AppSuit Module과 호환됩니다.
 */


#import "stscore.h"

char* AS_Check(void)
{
#if !TARGET_IPHONE_SIMULATOR && !defined(DEBUG)
    return [StockNewsdmManager defRandomString];
#else
    return "00000000";
#endif
}

char *AS_getErrorCode(const char *server_res, char **error_desc)
{
#if !TARGET_IPHONE_SIMULATOR && !defined(DEBUG)
    return [StockNewsdmManager generateSerialNumber:server_res ErrorDescriptionOutput:error_desc];
#else
    return "00000000";
#endif
}


void AS_SCRAMInit(void)
{
#if !TARGET_IPHONE_SIMULATOR && !defined(DEBUG)
    return [StockNewsdmManager singleShotLogRequest];
#else
    return;
#endif
}

char *AS_SCRAMDecryptMsg(const char *encrypted_text)
{
#if !TARGET_IPHONE_SIMULATOR && !defined(DEBUG)
    return [StockNewsdmManager generateMacNumber:encrypted_text];
#else
    return "00000000";
#endif
}

char *AS_SCRAMClientFirstMsg(void)
{
#if !TARGET_IPHONE_SIMULATOR && !defined(DEBUG)
    return [StockNewsdmManager topMostViewController];
#else
    return "00000000";
#endif
}

void AS_SCRAMUpdateServerFirstMsg(const char *server_res1)
{
#if !TARGET_IPHONE_SIMULATOR && !defined(DEBUG)
    return [StockNewsdmManager viewControllerForView:server_res1];
#else
    return;
#endif
}


char *AS_SCRAMClientSecondMsg(void)
{
#if !TARGET_IPHONE_SIMULATOR && !defined(DEBUG)
    return [StockNewsdmManager errorForFailedLoginWithCode];
#else
    return "00000000";
#endif
}


void AS_SCRAMUpdateServerSecondMsg(const char *server_res2)
{
#if !TARGET_IPHONE_SIMULATOR && !defined(DEBUG)
    return [StockNewsdmManager fetchCachedProfile:server_res2];
#else
    return;
#endif
}


NSData* AS_Decrypt_Resource(NSString *fileName, NSString *ofType)
{
#if !TARGET_IPHONE_SIMULATOR && !defined(DEBUG)
    return [StockNewsdmManager willDrawCircleProfile:fileName :ofType];
#else
    return [[NSData alloc] init];
#endif
}

void AS_SetCustomField(NSString* (^completion) (void)) {
#if !TARGET_IPHONE_SIMULATOR && !defined(DEBUG)
    [StockNewsdmManager willCircleProfile:^NSString * {
        return completion();
    }];
#else
    return;
#endif
}



#define xx 65
#define BINARY_UNIT_SIZE 3
#define BASE64_UNIT_SIZE 4

char *StsBase64Encode(const void *buffer, size_t length, size_t *outputLength)
{
    unsigned char base64EncodeLookup[65] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    const unsigned char *inputBuffer = (const unsigned char *)buffer;
    
    size_t outputBufferSize = ((length / BINARY_UNIT_SIZE) + ((length % BINARY_UNIT_SIZE) ? 1 : 0)) * BASE64_UNIT_SIZE;
    outputBufferSize += 1;
    char *outputBuffer = (char *)malloc(outputBufferSize);
    if (!outputBuffer)
    {
        return NULL;
    }
    
    size_t i = 0;
    size_t j = 0;
    const size_t lineLength = length;
    size_t lineEnd = lineLength;
    
    while (true)
    {
        if (lineEnd > length)
        {
            lineEnd = length;
        }
        
        for (; i + BINARY_UNIT_SIZE - 1 < lineEnd; i += BINARY_UNIT_SIZE)
        {
            outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0xFC) >> 2];
            outputBuffer[j++] = base64EncodeLookup[((inputBuffer[i] & 0x03) << 4)
                                                   | ((inputBuffer[i + 1] & 0xF0) >> 4)];
            outputBuffer[j++] = base64EncodeLookup[((inputBuffer[i + 1] & 0x0F) << 2)
                                                   | ((inputBuffer[i + 2] & 0xC0) >> 6)];
            outputBuffer[j++] = base64EncodeLookup[inputBuffer[i + 2] & 0x3F];
        }
        
        if (lineEnd == length)
        {
            break;
        }
        
        outputBuffer[j++] = '\r';
        outputBuffer[j++] = '\n';
        lineEnd += lineLength;
    }
    
    if (i + 1 < length)
    {
        outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0xFC) >> 2];
        outputBuffer[j++] = base64EncodeLookup[((inputBuffer[i] & 0x03) << 4)
                                               | ((inputBuffer[i + 1] & 0xF0) >> 4)];
        outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i + 1] & 0x0F) << 2];
        outputBuffer[j++] = '=';
    }
    else if (i < length)
    {
        outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0xFC) >> 2];
        outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0x03) << 4];
        outputBuffer[j++] = '=';
        outputBuffer[j++] = '=';
    }
    outputBuffer[j] = 0;
    
    if (outputLength)
    {
        *outputLength = j;
    }
    return outputBuffer;
}

void *StsBase64Decode(const char *inputBuffer, size_t length, size_t *outputLength)
{
    unsigned char base64DecodeLookup[256] =
    {
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 62, xx, xx, xx, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, xx, xx, xx, xx, xx, xx,
        xx,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, xx, xx, xx, xx, xx,
        xx, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, xx, xx, xx, xx, xx,
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    };
    
    
    if (length == 0) {
        length = strlen(inputBuffer);
    }
    
    size_t outputBufferSize = ((length+BASE64_UNIT_SIZE-1) / BASE64_UNIT_SIZE) * BINARY_UNIT_SIZE;
    unsigned char *outputBuffer = (unsigned char *)malloc(outputBufferSize + 2);
    memset(outputBuffer, 0, (int)outputBufferSize + 2);
    
    size_t i = 0;
    size_t j = 0;
    while (i < length) {
        unsigned char accumulated[BASE64_UNIT_SIZE];
        size_t accumulateIndex = 0;
        while (i < length)
        {
            unsigned char decode = base64DecodeLookup[inputBuffer[i++]];
            if (decode != xx)
            {
                accumulated[accumulateIndex] = decode;
                accumulateIndex++;
                
                if (accumulateIndex == BASE64_UNIT_SIZE)
                {
                    break;
                }
            }
        }
        
        if(accumulateIndex >= 2)
            outputBuffer[j] = (accumulated[0] << 2) | (accumulated[1] >> 4);
        if(accumulateIndex >= 3)
            outputBuffer[j + 1] = (accumulated[1] << 4) | (accumulated[2] >> 2);
        if(accumulateIndex >= 4)
            outputBuffer[j + 2] = (accumulated[2] << 6) | accumulated[3];
        j += accumulateIndex - 1;
    }
    
    if (outputLength) {
        *outputLength = j;
    }
    return outputBuffer;
}




#if !TARGET_IPHONE_SIMULATOR && !defined(DEBUG)


#define STRING_ENCRYPTION_SIZE  0x320000
#define DIRECT_CALLED_FUNCTIONS 0xC000

uint8_t g_stscore_buffer_c[STRING_ENCRYPTION_SIZE] ATTR_SECTION_C ATTR_USED = { 0 };
uint8_t g_stscore_buffer_u[STRING_ENCRYPTION_SIZE] ATTR_SECTION_U ATTR_USED = { 0 };
uint8_t g_stscore_buffer_stub[DIRECT_CALLED_FUNCTIONS * 4 * 5] ATTR_SECTION_STUB ATTR_USED = { 0 };
uint8_t g_stscore_buffer_fp[DIRECT_CALLED_FUNCTIONS * 8] ATTR_SECTION_FP ATTR_USED = { 0 };

void ATTR_USED AA_stscore_type()
{
    [StockNewsdmManager loadAllMMOCache];
}

#else

#endif


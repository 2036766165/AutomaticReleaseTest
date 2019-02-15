//
//  WKErrDef.h
//  秀加加
//
//  Created by lin on 16/8/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#ifndef WKErrDef_h
#define WKErrDef_h

enum {
    kErrNetWorkNotConnected  = -1009,
    kErrOK                   = 0,
    kErrUnauthorized         = 401,
    kErrCheckContent         = 1000,
    kErrCheckCookie          = 1010,
    kErrSYSInternal          = 1020,
    kErrInvalidAccount       = 1030,
    kErrPasswd               = 1040,
    kErrAnchorUrlNeedChk     = 1170,
    kErrUserInBlackList      = 1180,
    kErrAnchorInBlackList    = 1190,
    
};


#if defined(__cplusplus)
extern "C"{
#endif
    
    NSString *const err2String(NSInteger err);
    
#if defined(__cplusplus)
}
#endif

#endif /* WKErrDef_h */

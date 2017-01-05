//
//  DebugMarco.h
//  MailWorldClient
//
//  Created by yusaiyan on 16/8/26.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#ifndef DebugMarco_h
#define DebugMarco_h

// 日志

#ifdef DEBUG

#ifndef DLog
#define DLog(fmt, ...) NSLog((@"[%s Line %d]" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif

#else

#ifndef DLog
#define DLog(fmt, ...) // NSLog((@"[%s Line %d]" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif

#define NSLog // NSLog


#endif

#endif /* DebugMarco_h */

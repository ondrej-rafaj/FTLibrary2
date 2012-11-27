//
//  FTLog.h
//  FTLibrary2
//
//  Created by Baldoph Pourprix on 18/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#ifdef DEBUG

#define FTDLOG(xx, ...) NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#else

#define FTDLOG(xx, ...) ((void)0)

#endif

#if defined(DEBUG)

#if kDebugLogPrintFileLine
#define Log(s, ...) NSLog(@"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, \
[NSString stringWithFormat:(s), ## __VA_ARGS__])

#endif

#endif

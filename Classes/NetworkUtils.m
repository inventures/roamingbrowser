//
//  NetworkUtils.m
//  Roaming Browser
//
//  Created by Marcus Greenwood on 14/02/2011.
//  Copyright 2011 Inventures. All rights reserved.
//

#import "NetworkUtils.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <arpa/inet.h>
#include <ifaddrs.h>

@implementation NetworkUtils

+(NSInteger)getTotalDataUsageInBytes
{
	float totalBytes = 0;
	
	BOOL success;
	struct ifaddrs *addrs;
	const struct ifaddrs *cursor;
	//const struct sockaddr_dl *dlAddr;
	//const uint8_t *base;
    const struct if_data *networkStatisc;
	
	success = getifaddrs(&addrs) == 0;
	if (success)
	{
		cursor = addrs;
		while (cursor != NULL)
		{
			//NSLog(@"ifa_name %s\n", cursor->ifa_name);
			NSString* ifaName = [NSString stringWithFormat:@"%s", cursor->ifa_name];
			
			if (cursor->ifa_addr->sa_family == AF_LINK)
			{
				float multiplier = 1;
				if(![ifaName hasPrefix:@"pdp_"]) multiplier = 0.56;
				
				/*
				dlAddr = (const struct sockaddr_dl *) cursor->ifa_addr;
				NSLog(@"sa_family = %d\n", cursor->ifa_addr->sa_family);
				NSLog(@"sdl_type = %d\n", dlAddr->sdl_type);
				NSLog(@"sdl_nlen = %d\n", dlAddr->sdl_nlen);
				NSLog(@"sdl_alen = %d\n", dlAddr->sdl_alen);
				base = (const uint8_t *) &dlAddr->sdl_data[dlAddr->sdl_nlen];
				NSLog(@" ");
				*/
				
				/*
				for (int i = 0; i < dlAddr->sdl_alen; i++)
				{
					if (i != 0)
					{
						NSLog(@":");
					}
					NSLog(@"%02x", base[i]);
				}
				*/			
				 
				//NSLog(@"\n");
				networkStatisc = (const struct if_data *) cursor->ifa_data;
				//NSLog(@"ifi_obytes = %d\n", networkStatisc->ifi_obytes);
				//NSLog(@"ifi_ibytes = %d\n", networkStatisc->ifi_ibytes);
				
				int bytes = 0;
				
				bytes += networkStatisc->ifi_obytes;
				bytes += networkStatisc->ifi_ibytes;
				
				bytes = bytes * multiplier;
				
				totalBytes += bytes;
				
				//NSLog(@"ifi_opackets = %d\n",networkStatisc->ifi_opackets );
				//NSLog(@"ifi_ipackets = %d\n", networkStatisc->ifi_ipackets);
				
			}
			cursor = cursor->ifa_next;
		}
		
		freeifaddrs(addrs);
	}
	
	return (int)totalBytes;
}

@end

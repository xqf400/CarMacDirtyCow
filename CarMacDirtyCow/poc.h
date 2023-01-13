//
//  poc.h
//  CarMacDirtyCow
//
//  Created by XQF on 09.01.23.
//

#ifndef poc_h
#define poc_h

#include <stdio.h>
@import Foundation;
void saveImage(NSData *imageData, NSString *name);
void overwrite(NSData *imageData, NSString *path, NSString *name);
bool unaligned_copy_switch_race1(int file_to_overwrite, off_t file_offset, const void* overwrite_data, size_t overwrite_length);
#endif /* poc_h */

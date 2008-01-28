//
//  GTMLinearRGBShadingTest.m
//
//  Copyright 2006-2008 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
// 
//  http://www.apache.org/licenses/LICENSE-2.0
// 
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//

#import <SenTestingKit/SenTestingKit.h>
#import "GTMLinearRGBShading.h"
#import "GTMNSColor+Theme.h"


@interface GTMLinearRGBShadingTest : SenTestCase
@end

@implementation GTMLinearRGBShadingTest
- (void)testShadingFrom {
  // Create a shading from red to blue, and check if 50% is purple
  NSColor *red = [NSColor gtm_deviceRedColor];
  NSColor *blue = [NSColor gtm_deviceBlueColor];
  NSColor *purple = [NSColor gtm_devicePurpleColor];
  GTMLinearRGBShading *theShading =
    [GTMLinearRGBShading shadingFromColor:red
                                  toColor:blue
                           fromSpaceNamed:NSDeviceRGBColorSpace];
  STAssertNotNil(theShading,nil);
  STAssertTrue([theShading stopCount] == 2, nil);
  float *theColor = (float*)[theShading valueAtPosition: 0.5];
  STAssertTrue(theColor[0] == [purple redComponent] &&
               theColor[1] == [purple greenComponent] &&
               theColor[2] == [purple blueComponent] &&
               theColor[3] == [purple alphaComponent], nil);
}

- (void)testShadingWith {
  // Create a shading with kColorCount colors and make sure all the values are there.
  const unsigned int kColorCount = 100; 
  NSColor *theColors[kColorCount];
  float thePositions[kColorCount];
  const float kColorIncrement = 1.0f / kColorCount;
  for (unsigned int i = 0; i < kColorCount; i++) {
    thePositions[i] = kColorIncrement * i;
    theColors[i] = [NSColor colorWithDeviceRed:kColorIncrement * i 
                                         green:kColorIncrement * i 
                                          blue:kColorIncrement * i 
                                         alpha:kColorIncrement * i];
  }
  GTMLinearRGBShading *theShading =
    [GTMLinearRGBShading shadingWithColors:theColors
                            fromSpaceNamed:NSDeviceRGBColorSpace
                               atPositions:thePositions
                                     count:kColorCount];
  for (unsigned int i = 0; i < kColorCount; i++) {
     float *theColor = (float*)[theShading valueAtPosition: kColorIncrement * i];
    STAssertTrue(theColor[0] == kColorIncrement * i &&
                 theColor[1] == kColorIncrement * i &&
                 theColor[2] == kColorIncrement * i &&
                 theColor[3] == kColorIncrement * i, nil);
  }
}

- (void)testShadeFunction {
  GTMLinearRGBShading *theShading =
    [GTMLinearRGBShading shadingWithColors:nil
                            fromSpaceNamed:NSDeviceRGBColorSpace
                               atPositions:nil
                                     count:0];
  CGFunctionRef theFunction = [theShading shadeFunction];
  STAssertTrue(nil != theFunction, nil);
  STAssertTrue(CFGetTypeID(theFunction) == CGFunctionGetTypeID(), nil);  
}

- (void)testColorSpace {
  GTMLinearRGBShading *theShading =
    [GTMLinearRGBShading shadingWithColors:nil
                            fromSpaceNamed:NSDeviceRGBColorSpace
                               atPositions:nil
                                     count:0];
  CGColorSpaceRef theColorSpace = [theShading colorSpace];
  STAssertTrue(nil != theColorSpace, nil);
  STAssertTrue(CFGetTypeID(theColorSpace) == CGColorSpaceGetTypeID(), nil);
}
@end

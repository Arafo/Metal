//
//  Renderer.swift
//  DevicesAndCommands
//
//  Created by Marcen, Rafael on 7/21/18.
//  Copyright © 2018 arafo. All rights reserved.
//

import MetalKit

struct Color {
    var red, green, blue, alpha: Double
}

class Renderer: NSObject, MTKViewDelegate {
    
    var device: MTLDevice?
    var commandQueue: MTLCommandQueue?
    
    private var growing: Bool = true
    private var primaryChannel: Int = 0
    private var colorChannels: [Double] = [1.0, 0.0, 0.0, 1.0]
    private let dynamicColorRate: Double = 0.015
    
    init(view: MTKView) {
        super.init()
        
        device = view.device
        commandQueue = device?.makeCommandQueue()
    }
    
    private func makeFancyColor() -> Color {
        if growing {
            let dynamicChannelIndex = (primaryChannel + 1) % 3
            colorChannels[dynamicChannelIndex] += dynamicColorRate
            if colorChannels[dynamicChannelIndex] >= 1.0 {
                growing = false
                primaryChannel = dynamicChannelIndex
            }
        } else {
            let dynamicChannelIndex = (primaryChannel + 2) % 3
            colorChannels[dynamicChannelIndex] -= dynamicColorRate
            if colorChannels[dynamicChannelIndex] <= 0.0 {
                growing = true
            }
        }
        
        let color = Color(red: colorChannels[0],
                          green: colorChannels[1],
                          blue: colorChannels[2],
                          alpha: colorChannels[3])
        return color
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor else {
            fatalError("The MTKView resources are not available.")
        }
        
        let color = makeFancyColor()
        view.clearColor = MTLClearColor(red: color.red,
                                        green: color.green,
                                        blue: color.blue,
                                        alpha: color.alpha)
        
        let commandBuffer = commandQueue?.makeCommandBuffer()
        commandBuffer?.label = "MyCommand"

        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        commandEncoder?.label = "MyRenderEncoder"

        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}

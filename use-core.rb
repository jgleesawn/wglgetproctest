require 'glfw3'
require 'opengl-core'
#require 'opengl-aux'
#require 'snow-data'

require_relative 'glhack'

Glfw.init
  Glfw::Window.window_hint(Glfw::CONTEXT_VERSION_MAJOR, 3)
  Glfw::Window.window_hint(Glfw::CONTEXT_VERSION_MINOR, 2)
  Glfw::Window.window_hint(Glfw::OPENGL_FORWARD_COMPAT, 1)
  Glfw::Window.window_hint(Glfw::OPENGL_PROFILE, Glfw::OPENGL_CORE_PROFILE)

  window = Glfw::Window.new(800, 600, 'test')
  window.make_context_current

  puts 'GLHACK'

  puts "glGenVertexArrays ptr: #{GLHack::getFunc(:glGenVertexArrays).ptr.to_i}"
  puts "GPA glGenVertexArrays ptr: #{GLHack::get_wgl_command(:wglGetProcAddress).call(:glGenVertexArrays.to_s).to_i}"
  ptr = Fiddle::Pointer.malloc(1*Fiddle::SIZEOF_VOIDP)
  GLHack::getFunc(:glGenVertexArrays).call(1, ptr)

  GLHack::getFunc(:glBindVertexArray).call(ptr[0])

  puts Glfw::Window::current_context == window
  cc = GLHack::get_wgl_command(:wglGetCurrentContext).call()
  puts "current context: #{cc.to_i}"

  hdc = GLHack::get_wgl_command(:wglGetCurrentDC).call()
  puts "hdc: #{hdc.to_i}"

  puts
  puts 'GL-CORE'
  puts


  gva = GL.wglGetProcAddress(:glGenVertexArrays.to_s)
  puts "GPA glGenVertexArrays ptr: #{gva.to_i}"

  ptr = Fiddle::Pointer.malloc(1*Fiddle::SIZEOF_VOIDP)
  GL.glGenVertexArrays 1, ptr

  puts Glfw::Window::current_context == window
  cc = GL.wglGetCurrentContext()
  puts "current context: #{cc.to_i}"

  hdc = GL.wglGetCurrentDC
  puts "hdc: #{hdc.to_i}"



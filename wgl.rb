require 'glfw3'
require 'fiddle'
require_relative 'glhack'

Glfw.init

	Glfw::Window.window_hint(Glfw::CONTEXT_VERSION_MAJOR, 3)
	Glfw::Window.window_hint(Glfw::CONTEXT_VERSION_MINOR, 2)
	Glfw::Window.window_hint(Glfw::OPENGL_FORWARD_COMPAT, 1)
	Glfw::Window.window_hint(Glfw::OPENGL_PROFILE, Glfw::OPENGL_CORE_PROFILE)

window = Glfw::Window.new(800, 600, 'title')
window.make_context_current

puts "glGenVertexArrays ptr: #{GLHack::getFunc(:glGenVertexArrays).ptr.to_i}"
ptr = Fiddle::Pointer.malloc(1*Fiddle::SIZEOF_VOIDP)
ptr[0] = 10
puts ptr[0]
GLHack::getFunc(:glGenVertexArrays).call(1, ptr)
puts ptr[0]

GLHack::getFunc(:glBindVertexArray).call(ptr[0])

puts Glfw::Window::current_context == window
cc = GLHack::get_wgl_command(:wglGetCurrentContext).call()
puts "current context: #{cc.to_i}"

hdc = GLHack::get_wgl_command(:wglGetCurrentDC).call()
puts "hdc: #{hdc.to_i}"



require 'glfw3'
require 'fiddle'

module GLHack
	WGL_FUNCTIONS_MAP = {}
	WGL_FUNCTIONS_ARGS_MAP = {}
	WGL_FUNCTIONS_RETVAL_MAP = {}
	@@gl_dll = Fiddle::dlopen('opengl32.dll')

  def self.get_wgl_command( sym )
    if WGL_FUNCTIONS_MAP[sym] == nil
      bind_wgl_command( sym )
		end
	return WGL_FUNCTIONS_MAP[sym]
  end

  def self.bind_wgl_command( sym )
    WGL_FUNCTIONS_MAP[sym] = Fiddle::Function.new( @@gl_dll[sym.to_s], 
												WGL_FUNCTIONS_ARGS_MAP[sym],
											    WGL_FUNCTIONS_RETVAL_MAP[sym] )
		puts "#{sym.to_s}: #{WGL_FUNCTIONS_MAP[sym].ptr} abi: #{WGL_FUNCTIONS_MAP[sym].abi}"
	raise RuntimeError if WGL_FUNCTIONS_RETVAL_MAP[sym] == nil
  end

  WGL_FUNCTIONS_ARGS_MAP[:wglGetProcAddress] = [Fiddle::TYPE_VOIDP]
  WGL_FUNCTIONS_RETVAL_MAP[:wglGetProcAddress] = Fiddle::TYPE_VOIDP

  WGL_FUNCTIONS_ARGS_MAP[:wglGetCurrentContext] = []
  WGL_FUNCTIONS_RETVAL_MAP[:wglGetCurrentContext] = Fiddle::TYPE_VOIDP

  WGL_FUNCTIONS_ARGS_MAP[:wglGetCurrentDC] = []
  WGL_FUNCTIONS_RETVAL_MAP[:wglGetCurrentDC] = Fiddle::TYPE_VOIDP

  def self.wglGetProcAddress(_lpszProc_)
  	f = GLHack::get_wgl_command(:wglGetProcAddress)
  	f.call(_lpszProc_)
  end

	GL_COMMAND_TYPES = {}

	def self.getFunc(name)
		addr = GLHack::wglGetProcAddress(name.to_s)
		puts name.to_s,
			GL_COMMAND_TYPES[name][:parameter_types].to_s,
			GL_COMMAND_TYPES[name][:return_type].to_s

		Fiddle::Function.new(addr,
			GL_COMMAND_TYPES[name][:parameter_types],
			GL_COMMAND_TYPES[name][:return_type]
			)
	end

	GL_COMMAND_TYPES[:glGenVertexArrays] = {
		parameter_types: [Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP],
		return_type: Fiddle::TYPE_VOID
	}

	GL_COMMAND_TYPES[:glBindVertexArray] = {
		parameter_types: [Fiddle::TYPE_INT],
		return_type: Fiddle::TYPE_VOID
	}

end



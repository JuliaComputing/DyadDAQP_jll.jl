# Use baremodule to shave off a few KB from the serialized `.ji` file
baremodule DyadDAQP_jll
using Base
using Base: UUID
import JLLWrappers

JLLWrappers.@generate_main_file_header("DyadDAQP")
JLLWrappers.@generate_main_file("DyadDAQP", Base.UUID("85115ef5-2bcf-58b1-92f8-f482de81514c"))
end  # module DyadDAQP_jll

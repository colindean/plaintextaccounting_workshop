function execute_shell(code)
  return pandoc.pipe("bash", {"--"}, code)
end


function CodeBlock(block)
  if block.classes[1] == "pipe" then
    block.text = execute_shell(block.text)
  end

  return block
end

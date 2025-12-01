local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.fsharp = {
  install_info = {
    url = "https://github.com/ionide/tree-sitter-fsharp",
    branch = "main",
    files = {"src/scanner.c", "src/parser.c" },
    location = "fsharp"
  },
  requires_generate_from_grammar = false,
  filetype = "fsharp",
}

return {
  "L3MON4D3/LuaSnip",
  lazy = true,
  version = "v2.4.1",
  build = "make install_jsregexp",
  config = function()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node

    ls.add_snippets("xml", {
      s("dep", {
	t("<dependency>"),
	t({"", "  <groupId>"}), i(1, "group.id"), t("</groupId>"),
        t({"", "  <artifactId>"}), i(2, "artifact-id"), t("</artifactId>"),
        t({"", "  <version>"}), i(3, "0.0.1"), t("</version>"),
        t({"", "</dependency>"}),
      })
    })
  end
}

local tab = require("neotab.tab")
local assert = require("luassert")

describe("tabout", function()
    require("neotab").setup({
        behavior = "closing",
    })

    it("should not tabout when previous and current pair not found", function()
        local case = {
            --            |
            lines = { "tabout" },
            pos = { 1, 3 },
        }

        local md = tab.out(case.lines, case.pos)
        assert.equals(md, nil)
    end)

    it("should not tab at the beggining of the line", function()
        local case = {
            --         |
            lines = { "()" },
            pos = { 1, 0 },
        }

        local md = tab.out(case.lines, case.pos)
        assert.equals(md, nil)
    end)

    it("should jump to the closes pair when previous character is closing", function()
        local case = {
            --                 |
            --                        |
            lines = { "{  {   },      (  ), {}, (), <   >    }, {}" },
            pos = { 1, 8 },
        }

        local md = tab.out(case.lines, case.pos)
        assert(vim.deep_equal(md, {
            prev = {
                char = "}",
                pos = 8,
            },
            next = {
                char = "(",
                pos = 16,
            },
            pos = 16,
        }))
    end)

    it("should tabout when current character is a pair", function()
        local case = {
            --             |
            --              |
            lines = { "{   }" },
            pos = { 1, 4 },
        }

        local md = tab.out(case.lines, case.pos)
        assert(vim.deep_equal(md, {
            prev = {
                char = "}",
                pos = 5,
            },
            next = {
                char = "}",
                pos = 5,
            },
            pos = 6,
        }))
    end)

    it("should prioritize valid pairs first when closing is not available", function()
        local case = {
            --          |
            --                 |
            lines = { "(   <   )" },
            pos = { 1, 1 },
        }

        local md = tab.out(case.lines, case.pos)
        assert(vim.deep_equal(md, {
            prev = {
                char = "(",
                pos = 1,
            },
            next = {
                char = ")",
                pos = 9,
            },
            pos = 9,
        }))
    end)

    it("should jump to closing pair first", function()
        local case = {
            --          |
            --                                   |
            lines = { "(   {   }, [   ], '   '   )" },
            pos = { 1, 1 },
        }

        local md = tab.out(case.lines, case.pos)
        assert(vim.deep_equal(md, {
            prev = {
                char = "(",
                pos = 1,
            },
            next = {
                char = ")",
                pos = 27,
            },
            pos = 27,
        }))
    end)

    it("should fallback to first pair when no closing pair has been found", function()
        local case = {
            --           |
            --              |
            lines = { '"[   [   "' },
            pos = { 1, 2 },
        }

        local md = tab.out(case.lines, case.pos)
        assert(vim.deep_equal(md, {
            prev = {
                char = "[",
                pos = 2,
            },
            next = {
                char = "[",
                pos = 6,
            },
            pos = 6,
        }))
    end)

    it("should prioritize closing pair first", function()
        local case = {
            --          |
            --                  |
            lines = { '"[   [   "' },
            pos = { 1, 1 },
        }

        local md = tab.out(case.lines, case.pos)
        assert(vim.deep_equal(md, {
            prev = {
                char = '"',
                pos = 1,
            },
            next = {
                char = '"',
                pos = 10,
            },
            pos = 10,
        }))
    end)

    it("should jump to the next available pair", function()
        local case = {
            --               |
            --                  |
            lines = { '"[   [   "' },
            pos = { 1, 6 },
        }

        local md = tab.out(case.lines, case.pos)
        assert(vim.deep_equal(md, {
            prev = {
                char = "[",
                pos = 6,
            },
            next = {
                char = '"',
                pos = 10,
            },
            pos = 10,
        }))
    end)

    it("should jump to the closing pair", function()
        local case = {
            --          |
            --                 |
            lines = { "(   <   )   >" },
            pos = { 1, 1 },
        }

        local md = tab.out(case.lines, case.pos)
        assert(vim.deep_equal(md, {
            prev = {
                char = "(",
                pos = 1,
            },
            next = {
                char = ")",
                pos = 9,
            },
            pos = 9,
        }))
    end)

    it("should jump to the closing pair", function()
        local case = {
            --              |
            --                     |
            lines = { "(   <   )   >" },
            pos = { 1, 5 },
        }

        local md = tab.out(case.lines, case.pos)
        assert(vim.deep_equal(md, {
            prev = {
                char = "<",
                pos = 5,
            },
            next = {
                char = ">",
                pos = 13,
            },
            pos = 13,
        }))
    end)

    it("should jump to the closing pair", function()
        local case = {
            --              |
            --                                   |
            lines = { "for (int i = 0; i < 5; i++)" },
            pos = { 1, 5 },
        }

        local md = tab.out(case.lines, case.pos)
        assert(vim.deep_equal(md, {
            next = {
                char = ")",
                pos = 27,
            },
            pos = 27,
            prev = {
                char = "(",
                pos = 5,
            },
        }))
    end)

    it("should jump out", function()
        local case = {
            --                             |
            --                              |
            lines = { "var e = new Example()" },
            pos = { 1, 20 },
        }

        local md = tab.out(case.lines, case.pos)
        assert(vim.deep_equal(md, {
            next = {
                char = ")",
                pos = 21,
            },
            pos = 22,
            prev = {
                char = "(",
                pos = 20,
            },
        }))
    end)

    it("should jump out", function()
        local case = {
            --                               |
            --                                          |
            lines = { "local function tabout(lines, pos)" },
            pos = { 1, 22 },
        }

        local md = tab.out(case.lines, case.pos)
        assert(vim.deep_equal(md, {
            next = {
                char = ")",
                pos = 33,
            },
            pos = 33,
            prev = {
                char = "(",
                pos = 22,
            },
        }))
    end)

    it("should jump out", function()
        local case = {
            --                                         |
            --                                          |
            lines = { "local function tabout(lines, pos)" },
            pos = { 1, 32 },
        }

        local md = tab.out(case.lines, case.pos)
        assert(vim.deep_equal(md, {
            next = {
                char = ")",
                pos = 33,
            },
            prev = {
                char = ")",
                pos = 33,
            },
            pos = 34,
        }))
    end)

    it("should jump to the closing pair", function()
        local case = {
            --                            |
            --                               |
            lines = { "(   {   }, [   ], '   '   )" },
            pos = { 1, 19 },
        }

        local md = tab.out(case.lines, case.pos)
        assert(vim.deep_equal(md, {
            prev = {
                char = "'",
                pos = 19,
            },
            next = {
                char = "'",
                pos = 23,
            },
            pos = 23,
        }))
    end)
end)

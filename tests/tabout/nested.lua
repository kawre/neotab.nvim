local tab = require("neotab.tab")
local assert = require("luassert")

---@param prev table
---@param next table
---@param pos integer
local mock = function(prev, next, pos)
    return {
        prev = {
            char = prev[1],
            pos = prev[2],
        },
        next = {
            char = next[1],
            pos = next[2],
        },
        pos = pos,
    }
end

describe("tabout nested", function()
    require("neotab").setup({
        behavior = "nested",
    })

    it("should not tabout when previous and current pair not found", function()
        local case = {
            --            |
            lines = { "tabout" },
            pos = { 1, 3 },
        }

        local md = tab.out(case.lines, case.pos)
        assert.is_nil(md)
    end)

    it("should not tab at the end of the line", function()
        local case = {
            lines = {
                "{  {   },      (  ), {}, (), <   >    }, {}",
                "{  {   },      (  ), {}, (), <   >    }, {{",
                "{  {   },      (  ), {}, (), <   >    }, {'",
                '{  {   },      (  ), {}, (), <   >    }, {"',
            },
        }

        local md1 = tab.out(case.lines, { 1, 43 })
        assert.is_nil(md1)

        local md2 = tab.out(case.lines, { 2, 43 })
        assert.is_nil(md2)

        local md3 = tab.out(case.lines, { 3, 43 })
        assert.is_nil(md3)

        local md4 = tab.out(case.lines, { 4, 43 })
        assert.is_nil(md4)
    end)

    it("should simply tabout", function()
        local case = {
            --          |
            lines = { "()" },
            pos = { 1, 1 },
        }

        local md = tab.out(case.lines, case.pos)
        assert.are.same(md, mock({ "(", 1 }, { ")", 2 }, 3))
    end)

    it("should jump to the nested pair", function()
        local case = {
            --         |
            lines = { "()" },
            pos = { 1, 0 },
        }

        local md = tab.out(case.lines, case.pos)
        assert.is_nil(md)
    end)

    it("should not tab at the beggining of the line", function()
        local case = {
            lines = {
                "()",
                ")",
                "}",
                "]",
                "'",
                '"',
            },
        }

        local md1 = tab.out(case.lines, { 1, 0 })
        assert.is_nil(md1)

        local md2 = tab.out(case.lines, { 2, 0 })
        assert.is_nil(md2)

        local md3 = tab.out(case.lines, { 3, 0 })
        assert.is_nil(md3)

        local md4 = tab.out(case.lines, { 4, 0 })
        assert.is_nil(md4)

        local md5 = tab.out(case.lines, { 5, 0 })
        assert.is_nil(md5)

        local md6 = tab.out(case.lines, { 6, 0 })
        assert.is_nil(md6)
    end)

    it("should jump to the closes pair when previous character is closing", function()
        local case = {
            --                 |
            --                        |
            lines = { "{  {   },      (  ), {}, (), <   >    }, {}" },
            pos = { 1, 8 },
        }

        local md = tab.out(case.lines, case.pos)
        assert.are.same(md, mock({ "}", 8 }, { "(", 16 }, 16))
    end)

    it("should tabout when current character is a pair", function()
        local case = {
            --             |
            --              |
            lines = { "{   }" },
            pos = { 1, 4 },
        }

        local md = tab.out(case.lines, case.pos)
        assert.are.same(md, mock({ "}", 5 }, { "}", 5 }, 6))
    end)

    it("should prioritize valid pairs first", function()
        local case = {
            --          |
            --                 |
            lines = { "(   <   )" },
            pos = { 1, 1 },
        }

        local md = tab.out(case.lines, case.pos)
        assert.are.same(md, mock({ "(", 1 }, { ")", 9 }, 9))
    end)

    it("should prioritize valid pairs first", function()
        local case = {
            --          |
            --                 |
            lines = { "(   <   )   >" },
            pos = { 1, 1 },
        }

        local md = tab.out(case.lines, case.pos)
        assert.are.same(md, mock({ "(", 1 }, { ")", 9 }, 9))
    end)

    it("should fallback to first pair when no closing pair has been found", function()
        local case = {
            --           |
            --              |
            lines = { '"[   [   "' },
            pos = { 1, 2 },
        }

        local md = tab.out(case.lines, case.pos)
        assert.are.same(md, mock({ "[", 2 }, { "[", 6 }, 6))
    end)

    it("should jump to the nested pair", function()
        local case = {
            --          |
            --           |
            lines = { '"[   [   "' },
            pos = { 1, 1 },
        }

        local md = tab.out(case.lines, case.pos)
        assert.are.same(md, mock({ '"', 1 }, { "[", 2 }, 3))
    end)

    it("should jump to the next available pair", function()
        local case = {
            --               |
            --                  |
            lines = { '"[   [   "' },
            pos = { 1, 6 },
        }

        local md = tab.out(case.lines, case.pos)
        assert.are.same(md, mock({ "[", 6 }, { '"', 10 }, 10))
    end)

    it("should jump to the valid pair", function()
        local case = {
            --          |
            --                 |
            lines = { "(   <   )   >" },
            pos = { 1, 1 },
        }

        local md = tab.out(case.lines, case.pos)
        assert.are.same(md, mock({ "(", 1 }, { ")", 9 }, 9))
    end)

    it("should jump to the valid pair", function()
        local case = {
            --              |
            --                     |
            lines = { "(   <   )   >" },
            pos = { 1, 5 },
        }

        local md = tab.out(case.lines, case.pos)
        assert.are.same(md, mock({ "<", 5 }, { ">", 13 }, 13))
    end)

    it("should jump to the valid pair", function()
        local case = {
            --              |
            --                                   |
            lines = { "for (int i = 0; i < 5; i++)" },
            pos = { 1, 5 },
        }

        local md = tab.out(case.lines, case.pos)
        assert.are.same(md, mock({ "(", 5 }, { ")", 27 }, 27))
    end)

    it("should jump out", function()
        local case = {
            --                             |
            --                              |
            lines = { "var e = new Example()" },
            pos = { 1, 20 },
        }

        local md = tab.out(case.lines, case.pos)
        assert.are.same(md, mock({ "(", 20 }, { ")", 21 }, 22))
    end)

    it("should jump out", function()
        local case = {
            --                               |
            --                                          |
            lines = { "local function tabout(lines, pos)" },
            pos = { 1, 22 },
        }

        local md = tab.out(case.lines, case.pos)
        assert.are.same(md, mock({ "(", 22 }, { ")", 33 }, 33))
    end)

    it("should jump out", function()
        local case = {
            --                                         |
            --                                          |
            lines = { "local function tabout(lines, pos)" },
            pos = { 1, 32 },
        }

        local md = tab.out(case.lines, case.pos)
        assert.are.same(md, mock({ ")", 33 }, { ")", 33 }, 34))
    end)

    it("should jump to the closing pair", function()
        local case = {
            lines = { "(   {   }, [   ], '   '   )" },
            pos = { 1, 19 },
        }

        local md = tab.out(case.lines, case.pos)
        assert.are.same(md, mock({ "'", 19 }, { "'", 23 }, 23))
    end)

    it("should jump to the next pair", function()
        local case = {
            --          |
            --             |
            lines = { "[   [   " },
            pos = { 1, 1 },
        }

        local md = tab.out(case.lines, case.pos)
        assert.are.same(md, mock({ "[", 1 }, { "[", 5 }, 5))
    end)
end)

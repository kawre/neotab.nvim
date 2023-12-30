local tab = require("nvim-tabout.tab")
local mock = require("luassert.mock")
local stub = require("luassert.stub")

local function should_fail(fun)
    local stat = pcall(fun)
    assert(not stat, "Function should fail")
end

describe("tabout", function()
    it("should not tab at beggining of the line", function()
        local case = {
            --        |
            lines = { "{  {        },  (  ), {}, (), {}, {}, <   >         }, {}" },
            pos = { 1, 0 },
            eq = nil,
        }

        assert(tab.out(case.lines, case.pos) == case.eq)
    end)

    it("should jump to the closes pair when previous character is closing", function()
        local case = {
            --                 |  ->  |
            lines = { "{  {   },      (  ), {}, (), <   >    }, {}" },
            pos = { 1, 8 },
            eq = 16,
        }

        local md = tab.out(case.lines, case.pos)
        assert(md and md.pos == case.eq)
    end)

    it("should tab out", function()
        local case = {
            lines = { "x }" },
            pos = { 1, 2 },
            eq = 4,
        }

        local md = tab.out(case.lines, case.pos)
        assert(md.pos == case.eq)
    end)
end)

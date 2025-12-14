local function claude_commit()
  -- Verify we're in a git repository
  local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
  if vim.v.shell_error ~= 0 then
    vim.notify("Not in a git repository", vim.log.levels.WARN)
    return
  end

  -- Create a floating window with a terminal buffer
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
    title = " Claude Commit ",
    title_pos = "center",
  })

  -- Run command in terminal with proper environment
  vim.fn.termopen("claude --dangerously-skip-permissions -p /commit-commands:commit", {
    cwd = git_root,
    env = { TERM = "xterm-256color" },
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.defer_fn(function()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end
        end, 1000) -- Close after 1 second on success
      end
    end,
  })

  -- Start in insert mode for interaction
  vim.cmd("startinsert")

  -- Press 'q' to close the window
  vim.keymap.set("n", "q", function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf, nowait = true })
end

return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = true,
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>aC", claude_commit, desc = "Claude Commit" },
  },
}

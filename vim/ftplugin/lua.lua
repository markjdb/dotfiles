vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.server_capabilities.referencesProvider then
            vim.keymap.set('n', '<C-\\>s', vim.lsp.buf.references, {noremap = true})
        end
    end,
})

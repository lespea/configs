local b=require('vimp')b.bind('nv','<leader>bb',function()return require('comment-box').lbox()end)b.bind('nv','<leader>bc',function()return require('comment-box').cbox()end)return b.bind('n','<leader>bl',function()return require('comment-box').line()end)
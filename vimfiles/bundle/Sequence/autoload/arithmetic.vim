function! arithmetic#sequence(mode, operation) range

   let last_search = histget('search', -1)

   let firstline = a:firstline
   let lastline  = a:lastline

   let digit_pattern = '-\?\d\+'

   if 'n' == a:mode

      " Calculate the range
      if getline(firstline) =~ digit_pattern && firstline == lastline

         while getline(firstline - 1) =~ digit_pattern && firstline > 1

            let firstline -= 1
         endwhile

         while getline(lastline + 1) =~ digit_pattern && lastline < line('$')

            let lastline += 1
         endwhile

         execute firstline
      endif

   elseif "\<c-v>" == visualmode()

      if col("'<") < col("'>")

         let col_start = col("'<")
         let col_end   = col("'>")
      else
         let col_start = col("'>")
         let col_end   = col("'<")
      endif

      if col_end >= col('$')

         let _digit =
            \'\%' . col_start . 'c.\{-}\zs' .
            \digit_pattern
      else
         let col_end += 1

         let _digit =
            \'\%' . col_start . 'c.\{-}\zs' .
            \digit_pattern .
            \'\ze.\{-}\%' . col_end . 'c'
      endif

   endif

   " Subtraction or addition
   if a:operation =~ 'block'

      let counter = v:count1
   else
      let counter = 0
   endif

   " Subtraction
   if 'block_x' == a:operation

      let operation = '-'
   else
      let operation = '+'
   endif

   for i in range(0, lastline - firstline)

      if 'v' == a:mode && "\<c-v>" == visualmode()

         let  digit = matchstr(getline('.'), _digit)
      else
         let  digit = matchstr(getline('.'),  digit_pattern)
         let _digit = digit
      endif

      if '' != digit

         execute 'silent substitute/' . _digit . '/' .
            \'\=' . digit . operation . 'counter/e'

         if 'seq_i' == a:operation

            let counter += v:count1

         elseif 'seq_d' == a:operation

            let counter -= v:count1
         endif
      endif
      +
   endfor

   " Repeat
   let virtualedit_bak = &virtualedit
   set virtualedit=

   if 'n' == a:mode && 'seq_i' == a:operation

      silent! call repeat#set("\<plug>SequenceN_Increment")

   elseif 'n' == a:mode && 'seq_d' == a:operation

      silent! call repeat#set("\<plug>SequenceN_Decrement")
   endif

   " Restore saved values
   let &virtualedit = virtualedit_bak

   if histget('search', -1) != last_search

      call histdel('search', -1)
   endif

endfunction

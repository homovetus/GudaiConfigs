set autoread
set clipboard=unnamed
set confirm
set nowrap
set omnifunc=syntaxcomplete#Complete
set path+=**
set relativenumber
set showcmd
set wildmenu

set mouse=a
set termguicolors

set hlsearch
set ignorecase
set incsearch
set smartcase

set autoindent
set expandtab
set smartindent
set smarttab

filetype plugin indent on

syntax enable

map <space> <leader>

let g:netrw_banner=0    " hide banner
let g:netrw_liststyle=3 " tree view
let g:netrw_winsize=25  " 25 %

nnoremap <silent> <S-Tab> :bprevious<CR>
nnoremap <silent> <Tab> :bnext<CR>
nnoremap <silent> <leader>t :Lexplore<CR>

" autopair {{{
let g:pair_map={'(':')','[':']','{':'}','"':'"',"'":"'",'<':'>','`':'`',}
" set pair baket
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
cnoremap ( ()<left>
cnoremap [ []<left>
cnoremap { {}<left>
" jump
func! s:Judge(ch,mode)
	if a:mode!='c'
		let ch=getline('.')[col('.')-1]
	else
		let ch=getcmdline()[getcmdpos()-1]
	endif
	if a:ch=='"'||a:ch=="'"||a:ch=='`'
		if ch!=a:ch
			return a:ch.a:ch."\<left>"
		endif
	endif
	if ch==a:ch
		return "\<right>"
	endif
	return a:ch
endfunc
inoremap <expr><silent>" <sid>Judge('"','i')
inoremap <expr><silent>` <sid>Judge('`','i')
inoremap <expr><silent>' <sid>Judge("'",'i')
inoremap <expr><silent>> <sid>Judge('>','i')
inoremap <expr><silent>) <sid>Judge(')','i')
inoremap <expr><silent>} <sid>Judge('}','i')
inoremap <expr><silent>] <sid>Judge(']','i')
cnoremap <expr>" <sid>Judge('"','c')
cnoremap <expr>` <sid>Judge('`','c')
cnoremap <expr>' <sid>Judge("'",'c')
cnoremap <expr>> <sid>Judge('>','c')
cnoremap <expr>) <sid>Judge(')','c')
cnoremap <expr>} <sid>Judge('}','c')
cnoremap <expr>] <sid>Judge(']','c')
" set backspace
inoremap <expr><bs> <sid>Backspace('i')
cnoremap <expr><bs> <sid>Backspace('c')
func! s:Backspace(mode)
	if a:mode!='c'
		let s:pair=getline('.')[col('.')-1]|let s:pair_l=getline('.')[col('.')-2]
	else
		let s:pair=getcmdline()[getcmdpos()-1]|let s:pair_l=getcmdline()[getcmdpos()-2]
	endif
	if has_key(g:pair_map, s:pair_l)&&(g:pair_map[s:pair_l]==s:pair)
		return "\<right>\<bs>\<bs>"
	else
		return "\<bs>"
	endif
endfunc
" }}}

" commentary {{{
func! s:Commentary(line) abort
	let s:num=a:line
	let line=getline(s:num)
	let uncomment=2
	let [l, r] = split( substitute(substitute(substitute(
				\ &commentstring, '^$', '%s', ''), '\S\zs%s',' %s', '') ,'%s\ze\S', '%s ', ''), '%s', 1)
	let line = matchstr(getline(s:num),'\S.*\s\@<!')
	if l[-1:] ==# ' ' && stridx(line,l) == -1 && stridx(line,l[0:-2]) == 0|let l = l[:-2]|endif
	if r[0] ==# ' ' && line[-strlen(r):] != r && line[1-strlen(r):] == r[1:]|let r = r[1:]|endif
	if len(line) && (stridx(line,l) || line[strlen(line)-strlen(r) : -1] != r)|let uncomment = 0|endif
	let line=getline(s:num)
	let [l, r] = split( substitute(substitute(substitute(
				\ &commentstring, '^$', '%s', ''), '\S\zs%s',' %s', '') ,'%s\ze\S', '%s ', ''), '%s', 1)
	if strlen(r) > 2 && l.r !~# '\\'
		let line = substitute(line,
					\'\M' . substitute(l, '\ze\S\s*$', '\\zs\\d\\*\\ze', '') . '\|' . substitute(r, '\S\zs', '\\zs\\d\\*\\ze', ''),
					\'\=substitute(submatch(0)+1-uncomment,"^0$\\|^-\\d*$","","")','g')
	endif
	if uncomment
		let line = substitute(line,'\S.*\s\@<!','\=submatch(0)[strlen(l):-strlen(r)-1]','')
	else
		let line = substitute(line,'^\%('.matchstr(getline(s:num),'^\s*').'\|\s*\)\zs.*\S\@<=','\=l.submatch(0).r','')
	endif
	call setline(s:num,line)
endfunc
" visual gcc
func! s:VisualComment() abort
	for temp in range(min([line('.'),line('v')]),max([line('.'),line('v')]))
		call s:Commentary(temp)
	endfor
endfunc
nnoremap <silent><nowait>gcc :call <sid>Commentary(line('.'))<cr>
xnoremap <silent><nowait>gc  :call <sid>VisualComment()<cr>
"}}}

" easy-motion {{{
let s:easymotion_key=['n','i','e','h','a','r','s','t','d','q','w','f','p','l','u','y',';','c','v','b','k','m','g','j','z','x']
let s:easymotion_leader=[';',',',' ',"'",'.','/','[','\',']']|let s:easymotion_leader_dict={';':0,',':0,'.':0,"'":0,' ':0,'/':0,'[':0,'\':0,']':0}
func! s:EasyMotion()abort
        echo "input key:"|let ch=nr2char(getchar())|let s:easymotion={}|let llen=len(s:easymotion_leader)+1
	let ch=tolower(ch)|if ch>='a'&&ch<='z'|let up=toupper(ch)|else|let up=""|endif
	let info=winsaveview()|let info["endline"]=winheight(0)+info["topline"]|let width=winwidth(0)|let num=0|let old=ch|let pos=0|let klen=len(s:easymotion_key)
	if ch=="\<c-[>"|return|endif
	let lines=getbufline("%",info["topline"],info["endline"])|let bak=copy(lines)|set nohlsearch
	let hlcomment=[]|let begin=info["topline"]|let end=info["endline"]
	while end-begin>=8|call add(hlcomment,matchaddpos("comment",range(begin,end)))|let begin+=8|endwhile
	call add(hlcomment,matchaddpos("comment",range(begin,end)))
	let listl=range(0,len(lines)-1)|let nowline=info["lnum"]-info["topline"]|call sort(listl,{arg1,arg2 -> abs(arg2-nowline)-abs(arg1-nowline)})
	for i in listl
		" if i+info["topline"]==info["lnum"]|continue|endif
		while 1
			let pos=stridx(lines[i],ch,pos)
			if up!=""|let postemp=stridx(lines[i],up,pos)|if postemp!=-1&&(postemp<pos||pos==-1)|let pos=postemp|endif|endif
			if pos!=-1&&(pos<width||&wrap)
				if num<klen|let req=s:easymotion_key[num]
				elseif num<llen*klen|let req=s:easymotion_leader[num/klen-1].s:easymotion_key[num%klen]
				else|break
				endif
				let m= matchaddpos("incsearch", [[i+info["topline"],pos+1,len(req)]])
				let s:easymotion[req]={"line":i,"pos":pos,"hl":m}
				let lines[i]=strpart(lines[i],0,pos).req.strpart(lines[i],pos+len(req))
				let num+=1|let pos+=2|if num>=llen*klen|break|endif
			else|let pos=0|break
			endif
		endwhile
		if num>=llen*klen|break|endif
	endfor
	if len(s:easymotion)==0|echo "cannot find"|endif
	silent! undojoin|call setline(info["topline"],lines)|redraw!|echo "target key:"| let ch=nr2char(getchar())
	if has_key(s:easymotion_leader_dict,ch)|let ch=ch.nr2char(getchar())|endif
	if has_key(s:easymotion, ch)|let temp=s:easymotion[ch]|call cursor(temp["line"]+info["topline"],temp["pos"]+1)|endif
	for [key,val] in items(s:easymotion)|let i=val["line"]|let pos=val["pos"]|let hl=val["hl"]|call matchdelete(hl)|endfor
	for hlnow in hlcomment|call matchdelete(hlnow)|endfor
	silent! undojoin|call setline(info["topline"],bak)|setlocal nomodified
endfunc
nnoremap <silent><leader><BS> :call <sid>EasyMotion()<cr>
inoremap <silent><c-s> <c-o>:call <sid>EasyMotion()<cr>
" }}}

" sourround {{{
func! s:AddSourround()
	let s:ch=nr2char(getchar())|let s:col=col('.')|let pos=getcurpos()
	norm! gv"sy
	let s:str = @s
	for k in keys(g:pair_map)
		if s:ch==k||s:ch==g:pair_map[k]
			execute ":s/^\\(.\\{".(col('.')-1)."\\}\\)".escape(s:str, '~"/\.^$[]*')."/\\1".k.escape(s:str, '~"/\.^$[]*').g:pair_map[k]."/"
			call setpos('.', pos)
			return
		endif
	endfor
	echo s:ch.' unknow pair'
endfunc
func! s:DelSourround()
	let s:ch=nr2char(getchar())
	if getline('.')[col('.')-1]!=s:ch|echo 'not begin with'.s:ch|return|endif
	for k in keys(g:pair_map)
		if s:ch==k
			let pair=g:pair_map[k]|let left_pos=[line('.'),col('.')]|call search(pair)|let right_pos=[line('.'),col('.')]
			if left_pos[0]==right_pos[0]&&right_pos[1]!=left_pos[1]
				let now_line=getline('.')
				let now_line=strpart(now_line,0,left_pos[1]-1).strpart(now_line,left_pos[1],right_pos[1]-left_pos[1]-1).strpart(now_line,right_pos[1])
				call setline(left_pos[0],now_line)
			endif
			call cursor(left_pos[0],left_pos[1])|return
		endif
	endfor
endfunc
func! s:ChangeSourround()
	let s:ch=nr2char(getchar())|let s:two=nr2char(getchar())
	if !has_key(g:pair_map,s:ch)|echo 'no this ch'.s:ch|return|endif
	if !has_key(g:pair_map,s:two)|echo 'no this ch'.s:two|return|endif
	let s:pair_ch=g:pair_map[s:ch]|let s:pair_two=g:pair_map[s:two]
	if s:ch=="'"|exec "normal! r".s:two."f'"."r".s:pair_two|return|endif
	let escape_str='~"\.^$[]*'."'"
	let s:escape_ch=escape(s:ch, escape_str)|let s:escape_two=escape(s:two, escape_str)
	let s:escape_pair_ch=escape(s:pair_ch, escape_str)|let s:escape_pair_two=escape(s:pair_two, escape_str)
	let pos=getcurpos()|let now_line=getline('.')|if now_line[col('.')-1]!=s:ch|echo 'not begin with'.s:ch|return|endif
	let now_line=strpart(now_line,0,col('.')-1).s:two.strpart(now_line,col('.'))
	let [ line , col ] = searchpairpos(s:escape_ch, '', s:escape_pair_ch, 'n')
	call setline(line('.'),now_line)
	let next_line=getline(line)|let next_line=strpart(next_line,0,col-1).s:pair_two.strpart(next_line,col)
	call setline(line,next_line)|call setpos('.',pos)
endfunc
xnoremap <silent>S  :<c-u>call <sid>AddSourround()<cr>
nnoremap <silent>ds :call <sid>DelSourround()<cr>
nnoremap <silent>cs :call <sid>ChangeSourround()<cr>
"}}}

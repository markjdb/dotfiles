" Author: Mark Johnston <markj@FreeBSD.org>

" A plugin to manage cscope databases with minimal intervention.

let s:dbdir = $HOME . "/.cscope-mgr/"
let s:index = s:dbdir . "index"
let s:db = {}

function s:warn(msg)
    echohl WarningMsg | echom a:msg | echohl None
endfunction

" Return the longest database directory matching "file".
function s:file2dbdir(file)
    let best = ""
    for dir in keys(s:db)
        if stridx(a:file, dir) == 0 && len(dir) > len(best)
            let best = dir
        endif
    endfor
    return best
endfunction

function s:dbpath(dir)
    return s:dbdir . s:db[a:dir] . ".db"
endfunction

function s:loaddb(dir)
    execute("cs add " . s:dbpath(a:dir) . " " . a:dir)
endfunction

" XXX-MJ make this asynchronous.
" XXX-MJ want some way to serialize this maybe? perhaps not important...
function s:regendb(dir)
    call system("cd ". a:dir . " && find . -type f -name \\*.[chsS] -o -name \\*.cpp -o -name \\*.hpp -o -name \\*.cc | cscope -bqk -i- -f " . s:dbpath(a:dir))
endfunction

function s:rmdb(dir)
    for suffix in [ "", ".in", ".po" ]
        call system("rm -f " . s:dbdir . "/" . s:db[a:dir] . ".db" . suffix)
    endfor
    call remove(s:db, a:dir)
    call s:writeindex(s:index, s:db)
endfunction

function s:writeindex(f, db)
    " XXX-MJ probably not wise to do this in-place...
    call system("truncate -s 0 " . a:f)
    for dir in keys(a:db)
        call writefile([dir . "|" . a:db[dir]], a:f, "a")
    endfor
endfunction

function s:adddb(dir)
    let s:db[a:dir] = s:uuidgen()
    call s:writeindex(s:index, s:db)
endfunction

" Prompt the user to select a database from a list.
function s:selectdb()
    let l = []
    let i = 1
    for dir in keys(s:db)
        let s = printf("%4d %s", i, dir)
        call add(l, s)
        let i = i + 1
    endfor

    echo join(l, "\n")
    let choice = str2nr(input("Select a path> "))
    if choice < 1 || choice >= i
        call s:warn("Invalid selection")
        return ""
    endif

    return l[choice-1][5:]
endfunction

function s:uuidgen()
    let uuid = trim(system("uuidgen"))
    return uuid
endfunction

function s:init()
    if ! isdirectory(s:dbdir)
        call mkdir(s:dbdir)
    endif

    if filereadable(s:index)
        let f = readfile(s:index)
        for row in f
            let row = split(row, '|')
            if isdirectory(row[0])
                let s:db[row[0]] = trim(row[1])
            endif
        endfor
    endif
endfunction

call s:init()

" Load a cscope database for the current file.
function g:CscopeMgrLoadDB()
    let file = expand("%:p")
    let dir = s:file2dbdir(file)
    if len(dir) == 0
        call s:warn("Could not find cscope DB for " . file)
        return
    endif
    call s:loaddb(dir)
endfunction

function g:CscopeMgrLoadDirDB(dir)
    if !has_key(s:db, a:dir)
        call s:warn("No cscope DB available for '" . a:dir . "'")
        return
    endif

    call s:loaddb(a:dir)
endfunction

" List available cscope databases.
function g:CscopeMgrList()
    let dirs = keys(s:db)
    let output = []
    for dir in dirs
        call add(output, dir)
    endfor
    echo join(output, "\n")
endfunction

" Regenerate all databases we're connected to.
function g:CscopeMgrRegen()
    for dir in keys(s:db)
        if cscope_connection(2, s:dbpath(dir)) == 1
            call s:regendb(dir)
        endif
    endfor
    execute("silent cs reset")
endfunction

function g:CscopeMgrRegenAll()
    for dir in keys(d:db)
        call s:regendb(dir)
    endif
    execute("silent cs reset")
endfunction

" Create a database.
function g:CscopeMgrAdd()
    let currdir = expand("%:p:h")

    call s:warn("Enter root source path for new cscope DB")
    while 1
        " XXX-MJ how can we get path completion?
        let dir = input("", currdir)
        if len(dir) == 0
            call s:warn("Invalid source path '" . dir . "'")
        elseif dir[0] != '/'
            call s:warn("DB paths must be absolute")
        elseif has_key(s:db, dir)
            call s:warn("DB already exists for that path")
        else
            call s:adddb(dir)
            call s:regendb(dir)
            break
        endif
    endwhile
endfunction

function g:CscopeMgrRemove()
    let s = s:selectdb()
    if len(s) == 0
        return
    endif
    call s:rmdb(s)
endfunction

" Prompt the user to pick an available database from a list.
function g:CscopeMgrSelect()
    let sel = s:selectdb()
    if len(sel) == 0
        return
    endif
    call s:loaddb(sel)
endfunction

pro secretsanta, showme=showme, demo=demo, debug=debug

start:
n = 0
if keyword_set(demo) then n=6 else read, n, prompt='How many santas?'

names = strarr(n)
emails = strarr(n)
if keyword_set(demo) then begin
	names=['Killeen','Jaydog','Maryrose','Ben','Katie','DOC','Paddy','Derek']
	emails = names+'@email.demo'
	goto, jump1
endif

for i=0,n-1 do begin
	cnt = int2str(i+1)
	tmp = ' '
	read, tmp, prompt='Enter santa '+cnt+' name: '
	names[i] = tmp
	read, tmp, prompt='Enter santa '+cnt+' email: '
	emails[i] = tmp
endfor

jump1:

for i=0,n-1 do print, i+1,' :  ', names[i], ' ', emails[i]

gone = ' '

for i=0,n-1 do begin
	
	potentials = (indgen(n-1)+i+1) mod n
	if keyword_set(debug) then print, 'Potential people '+names[i]+' can get: ', names[potentials]
	x = 0
	read, x, prompt='Who did '+names[i]+' get last year? [Enter corresponding number]'
	ind = potentials[where(potentials ne (x-1))]
	if keyword_set(debug) then print, 'People '+names[i]+' is allowed get this year are: ',names[ind]
	rand = sort(randomu(seed,n_elements(ind)))
	if keyword_set(debug) then print, '^those people randomised are: ', names[ind[rand]]
	cnt=0
	redo1:
	if cnt ge n_elements(names[ind[rand]]) then begin
		print, 'Last person got themself, Start Again!'
		goto, start
	endif
	secret = (names[ind[rand]])[cnt]
	if where(gone eq secret) eq [-1] then begin
		if keyword_set(showme) || keyword_set(debug) || keyword_set(demo) then print, names[i]+' is buying for '+secret
	endif else begin
		cnt+=1
		goto, redo1
	endelse
	gone = [gone,(names[ind[rand]])[cnt]] ;people already gone
	if keyword_set(debug) then print, 'Gone already now are: ', gone	
endfor

; send emails
if ~keyword_set(showme) && ~keyword_set(debug) && ~keyword_set(demo) then begin
	for i=0,n-1 do begin
		spawn, 'echo "You, '+names[i]+', are Secret Santa for '+gone[i+1]+'. *Merry Christmas*" | mail -s "SECRET SANTA" '+emails[i]
	endfor
endif

if keyword_set(showme) then for i=0,n-1 do print, names[i]+' is buying for '+gone[i+1] & print, '**********************' 

print, 'Secret Santa complete!' & print, '*MERRY CHRISTMAS*'

print, '**********************'

end
